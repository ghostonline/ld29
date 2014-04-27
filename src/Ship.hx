import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
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

	public var score(default, null):Int;

	var image:Spritemap;
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
		score = 20;
		image = new Spritemap("graphics/ships.png", 32, 24);
		image.add("bomber", [0, 1, 2, 3], 4);
		image.add("miner", [4, 5, 6, 7], 4);
		image.add("scanner", [8, 9, 10, 11], 4);
		image.add("submarine", [12, 13, 14, 15], 4);
		image.scale = 2;
		image.centerOrigin();
		image.originY *= 1.75;
		image.play("bomber");
		graphic = image;

		setHitbox(
			Math.floor(image.width * image.scale),
			Math.floor(image.height * image.scale),
			Math.floor(image.originX * image.scale),
			Math.floor(image.originY * image.scale)
			);


		currentTarget = new Point();
		wanderArea = new Rectangle();
		alert = AlertIcon.createExclamation();
		lastKnownPosition = new Point();
		type = collisionType;
		visible = false;
		this.game = game;
		chargeTimer = 0;
		pursuitTimer = -1;
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
	}

	public function takeDamage(monster:Monster)
	{
		health -= 1;
		visible = health > 0;
		if (health <= 0)
		{
			visible = false;
			game.onShipDestroy(this);
		}
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
			if (x > currentTarget.x) { image.scaleX = -1; }
			else { image.scaleX = 1; }
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