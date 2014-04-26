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
	static inline var swimSpeed = 4;
	static inline var attackSpeed = 1;
	static inline var minAttackDuration = 1;

	static var tmpDirection:Point;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;
	var attackGraphic:Image;
	var swimState:SwimState;
	var attackTimer:Float;

	public function new()
	{
		super(0,0);
		horizontalGraphic = Image.createRect(40, 20, Palette.blue);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(20, 30, Palette.blue);
		verticalGraphic.centerOrigin();
		attackGraphic = Image.createRect(30, 30, Palette.red);
		attackGraphic.centerOrigin();
		attackGraphic.originY = attackGraphic.height;
		graphic = horizontalGraphic;
		setHitboxTo(horizontalGraphic);
		tmpDirection = new Point();
		swimState = SwimState.SurfaceSwim;
	}

	public function init(x:Float, y:Float)
	{
		this.x = x; this.y = y;
	}

	function surfaceSwimStateUpdate()
	{
		if (Controller.attack())
		{
			swimState = SwimState.Attacking;
			attackTimer = 0;
		}
		movementUpdate(swimSpeed, horizontalGraphic, verticalGraphic);
	}

	function attackStateUpdate()
	{
		attackTimer += HXP.elapsed;
		if (!Controller.attack() && attackTimer > minAttackDuration)
		{
			swimState = SwimState.SurfaceSwim;
		}
		movementUpdate(attackSpeed, attackGraphic, attackGraphic);
	}

	function movementUpdate(speed:Float, horizontal:Image, vertical:Image)
	{
		tmpDirection.x = 0;
		tmpDirection.y = 0;
		if (Controller.down())
		{
			tmpDirection.y += 1;
		}
		if (Controller.up())
		{
			tmpDirection.y -= 1;
		}
		if (Controller.left())
		{
			tmpDirection.x -= 1;
		}
		if (Controller.right())
		{
			tmpDirection.x += 1;
		}

		if (tmpDirection.x != 0 || tmpDirection.y != 0)
		{
			var frame:Image = null;
			if (Math.abs(tmpDirection.x) > Math.abs(tmpDirection.y))
			{
				frame = horizontal;
			}
			else
			{
				frame = vertical;
			}

			setHitboxTo(frame);
			graphic = frame;

			tmpDirection.normalize(speed);
			moveBy(tmpDirection.x, tmpDirection.y);
		}
	}

	override public function update()
	{
		super.update();

		switch(swimState)
		{
			case SwimState.SurfaceSwim:
				surfaceSwimStateUpdate();
			case SwimState.Attacking:
				attackStateUpdate();
		}
	}
}