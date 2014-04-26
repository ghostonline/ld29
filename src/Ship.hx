import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.HXP;

class Ship extends Entity
{
	public static inline var collisionType = "ship";
	public static inline var defaultHealth = 3;
	public static inline var maxPursuitTime = 5;

	static inline var speed = 1;
	static inline var minTargetDistance = 1;
	static inline var chargeCooldown = 1;
	static inline var chargeSpeed = 2;
	static inline var maxChargeDistance = 150;
	static inline var minLaunchDistance = 50;
	static inline var maxLaunchDistance = 200;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;
	var currentTarget:Point;
	var wanderArea:Rectangle;
	var health:Float;
	var game:GameScene;
	var chargeTimer:Float;
	var alert:AlertIcon;
	var lastKnownPosition:Point;
	var pursuitTimer:Float;

	public function new(game:GameScene){
		super(0,0);
		horizontalGraphic = Image.createRect(20, 10, Palette.brown);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(10, 15, Palette.brown);
		verticalGraphic.centerOrigin();
		currentTarget = new Point();
		wanderArea = new Rectangle();
		alert = AlertIcon.createExclamation();
		lastKnownPosition = new Point();
		type = collisionType;
		visible = false;
		this.game = game;
		chargeTimer = 0;
		pursuitTimer = 0;
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
		alert.visible = false;
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

	function updateSearching()
	{
		var monster = game.findNearestMonster(x, y);
		pursuitTimer -= HXP.elapsed;
		if (monster.isVisibleFromSurface())
		{
			pursuitTimer = maxPursuitTime;
			currentTarget.x = lastKnownPosition.x = monster.x;
			currentTarget.y = lastKnownPosition.y = monster.y;
			alert.visible = true;
		}
	}

	function updateAttack()
	{
		chargeTimer -= HXP.elapsed;
		var target = new Point(lastKnownPosition.x - x, lastKnownPosition.y - y);
		var targetLength = target.length;
		if (targetLength < maxLaunchDistance && chargeTimer < 0 && pursuitTimer > 0)
		{
			if (targetLength > maxChargeDistance)
			{
				target.normalize(maxChargeDistance);
			}

			chargeTimer = chargeCooldown;
			var charge = ExplosiveSachel.create(x, y, x + target.x, y + target.y, chargeSpeed);
			if (charge != null) { scene.add(charge); }
		}
	}

	function updateMovement()
	{
		var minDistance = minTargetDistance;
		if (pursuitTimer > 0)
		{
			minDistance = minLaunchDistance;
		}
		
		if (HXP.distanceSquared(x, y, currentTarget.x, currentTarget.y) > minDistance * minDistance)
		{
			moveTowards(currentTarget.x, currentTarget.y, speed);
		}
		else if (pursuitTimer < 0)
		{
			aquireWanderTarget();
		}
		
		layer = Math.floor(-y);
		alert.x = x;
		alert.y = y;		
	}

	override public function update()
	{
		super.update();

		updateSearching();
		updateAttack();
		updateMovement();
		
		alert.visible = pursuitTimer > 0;
	}

}