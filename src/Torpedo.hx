import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.Tween;
import com.haxepunk.HXP;
import flash.geom.Point;

class Torpedo extends Entity
{
	public static inline var collisionType = "torpedo";

	static var pool:Array<Torpedo>;
	static var lastTaken = 0;

	public static function initPool(count:Int)
	{
		pool = new Array<Torpedo>();
		for (ii in 0...count)
		{
			var charge = new Torpedo();
			pool.push(charge);
		}
	}

	public static function create(x:Float, y:Float, angle:Float)
	{
		var charge:Torpedo = null;
		for (ii in 0...pool.length)
		{
			var idx = (lastTaken + ii) % pool.length;
			if (!pool[idx].visible)
			{
				charge = pool[idx];
				charge.init(x, y, angle);
				++lastTaken;
				break;
			}
		}

		return charge;
	}

	static inline var defaultLife = 4;
	static inline var speed = 5;
	var image:Image;
	var lifeTimer:Float;
	var direction:Point;

	function new(){
		super(0,0);
		visible = false;
		type = collisionType;
		image = Image.createRect(10, 5, Palette.blue);
		image.centerOrigin();
		addGraphic(image);
		direction = new Point();
	}

	function init(x:Float, y:Float, angle:Float)
	{
		this.x = x;
		this.y = y;
		image.angle = angle;
		visible = true;
		lifeTimer = defaultLife;
		HXP.angleXY(direction, angle, speed);
	}

	override public function update()
	{
		super.update();
		if (!visible) return;

		moveBy(direction.x, direction.y);

		var e = collide(Monster.collisionType, x, y);
		if (e != null)
		{
			var monster = cast(e, Monster);
			monster.takeDamage();
			lifeTimer = 0;
		}

		lifeTimer -= HXP.elapsed;
		if (lifeTimer < 0)
		{
			visible = false;
			scene.remove(this);
		}
	}
}