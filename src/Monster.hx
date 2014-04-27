import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.math.Vector;
import flash.geom.Point;
import com.haxepunk.HXP;

enum SwimState
{
	SurfaceSwim;
	Attacking;
}

class Monster extends Entity
{
	public static inline var collisionType = "monster";
	static inline var swimSpeed = 4;
	static inline var attackSpeed = 1;
	static inline var minAttackDuration = 1;
	static inline var attackInterval = 0.75;
	static inline var markTimeout = 2;

	static var lastDirection:Point;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;
	var attackGraphic:Image;
	var swimState:SwimState;
	var attackTimer:Float;
	var attackPreparation:Float;
	var markedTimer:Float;
	var alert:AlertIcon;
	var game:GameScene;

	public function new(game:GameScene)
	{
		super(0,0);
		this.game = game;
		horizontalGraphic = Image.createRect(40, 20, Palette.blue);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(20, 30, Palette.blue);
		verticalGraphic.centerOrigin();
		attackGraphic = Image.createRect(30, 30, Palette.red);
		attackGraphic.centerOrigin();
		attackGraphic.originY = attackGraphic.height;
		graphic = horizontalGraphic;
		setHitboxTo(horizontalGraphic);
		lastDirection = new Point();
		swimState = SwimState.SurfaceSwim;
		type = collisionType;
		markedTimer = -1;
		alert = AlertIcon.createArrow();
	}

	public function init(x:Float, y:Float)
	{
		this.x = x; this.y = y;
	}
	
	public function setMarked()
	{
		markedTimer = markTimeout;
	}

	override public function added()
	{
		scene.add(alert);
	}

	override public function removed()
	{
		alert.scene.remove(alert);
	}

	public function takeDamage()
	{
		game.onMonsterHit(this);
	}

	public function isVisibleFromSurface()
	{
		return swimState == SwimState.Attacking || markedTimer > 0;
	}

	public function canTakeTopDamage()
	{
		return swimState == SwimState.Attacking;
	}

	function surfaceSwimStateUpdate()
	{
		movementUpdate(swimSpeed);
		if (Controller.attack())
		{
			swimState = SwimState.Attacking;
			attackTimer = 0;
			attackPreparation = 0;
			updateVisibility();
		}
	}

	function attackStateUpdate()
	{
		movementUpdate(attackSpeed);
		attackTimer += HXP.elapsed;
		attackPreparation += HXP.elapsed;
		if (attackPreparation >= attackInterval)
		{
			attackPreparation = 0;
			var e = collide(Ship.collisionType, x, y);
			if (e != null)
			{
				var ship = cast(e, Ship);
				ship.takeDamage(this);
			}
		}

		if (!Controller.attack() && attackTimer > minAttackDuration)
		{
			swimState = SwimState.SurfaceSwim;
			updateVisibility();
		}
	}

	function movementUpdate(speed:Float)
	{
		lastDirection.x = 0;
		lastDirection.y = 0;
		if (Controller.down())
		{
			lastDirection.y += 1;
		}
		if (Controller.up())
		{
			lastDirection.y -= 1;
		}
		if (Controller.left())
		{
			lastDirection.x -= 1;
		}
		if (Controller.right())
		{
			lastDirection.x += 1;
		}

		if (lastDirection.x != 0 || lastDirection.y != 0)
		{
			lastDirection.normalize(speed);
			moveBy(lastDirection.x, lastDirection.y);
			updateVisibility();
			alert.x = x;
			alert.y = y;
		}
	}

	function updateVisibility()
	{
		var horizontal = horizontalGraphic;
		var vertical = verticalGraphic;
		if (swimState == SwimState.Attacking)
		{
			horizontal = attackGraphic;
			vertical = attackGraphic;
			layer = Math.floor(-y);
		}
		else
		{
			layer = Layering.surface;
		}

		var frame:Image = null;
		if (Math.abs(lastDirection.x) > Math.abs(lastDirection.y))
		{
			frame = horizontal;
		}
		else
		{
			frame = vertical;
		}

		setHitboxTo(frame);
		graphic = frame;

		alert.visible = markedTimer > 0;
	}

	override public function update()
	{
		super.update();

		markedTimer -= HXP.elapsed;

		switch(swimState)
		{
			case SwimState.SurfaceSwim:
				surfaceSwimStateUpdate();
			case SwimState.Attacking:
				attackStateUpdate();
		}
	}
}