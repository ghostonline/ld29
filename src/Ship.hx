import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.HXP;

class Ship extends Entity
{
	public static inline var collisionType = "ship";
	public static inline var defaultHealth = 3;

	static inline var speed = 1;
	static inline var minTargetDistance = 1;
	static inline var chargeCooldown = 3;
	static inline var chargeSpeed = 2;
	static inline var maxChargeDistance = 150;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;
	var currentTarget:Point;
	var wanderArea:Rectangle;
	var health:Float;
	var game:GameScene;
	var chargeTimer:Float;
	var alert:AlertIcon;

	public function new(game:GameScene){
		super(0,0);
		horizontalGraphic = Image.createRect(20, 10, Palette.brown);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(10, 15, Palette.brown);
		verticalGraphic.centerOrigin();
		currentTarget = new Point();
		wanderArea = new Rectangle();
		alert = new AlertIcon();
		type = collisionType;
		visible = false;
		this.game = game;
		chargeTimer = 0;
	}

	override public function added()
	{
		scene.add(alert);
	}

	override public function removed()
	{
		alert.scene.remove(alert);
	}

	public function init(x:Float, y:Float, wanderArea:Rectangle, health:Float)
	{
		this.x = x; this.y = y;
		this.wanderArea = wanderArea;
		this.health = health;
		visible = true;
		alert.visible = true;
		aquireWanderTarget();
	}

	function aquireWanderTarget()
	{
		currentTarget.x = HXP.random * wanderArea.width + wanderArea.x;
		currentTarget.y = HXP.random * wanderArea.height + wanderArea.y;

		var dX = Math.abs(currentTarget.x - x);
		var dY = Math.abs(currentTarget.y - y);
		if (dX > dY)
		{
			graphic = horizontalGraphic;
			setHitboxTo(horizontalGraphic);
		}
		else
		{
			graphic = verticalGraphic;
			setHitboxTo(verticalGraphic);
		}
	}

	public function takeDamage(monster:Monster)
	{
		health -= 1;
		visible = health > 0;
		game.onShipDestroy(this);
		return health > 0;
	}

	override public function update()
	{
		super.update();
		moveTowards(currentTarget.x, currentTarget.y, speed);
		layer = Math.floor(-y);
		if (HXP.distanceSquared(x, y, currentTarget.x, currentTarget.y) < minTargetDistance * minTargetDistance)
		{
			aquireWanderTarget();
		}

		chargeTimer -= HXP.elapsed;
		if (chargeTimer < 0)
		{
			var monster = game.findNearestMonster(x, y);
			var target = new Point(monster.x - x, monster.y - y);
			if (target.length > maxChargeDistance)
			{
				target.normalize(maxChargeDistance);
			}

			chargeTimer = chargeCooldown;
			var charge = DepthCharge.initCharge(x, y, x + target.x, y + target.y, chargeSpeed);
			if (charge != null) { scene.add(charge); }
		}
		
		alert.x = x;
		alert.y = y;
	}

}