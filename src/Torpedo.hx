import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.Tween;
import com.haxepunk.HXP;
import flash.geom.Point;

class Torpedo extends Entity
{
	public static inline var collisionType = "torpedo";

	static var pool = new Pool<Torpedo>();

	public static function initPool(count:Int)
	{
		pool.initPool(count, function() { return new Torpedo(); });
	}

	public static function create(x:Float, y:Float, angle:Float)
	{
		return pool.get(function (instance) { instance.init(x, y, angle); });
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

		var factor = Macro.smoothstep(HXP.clamp(defaultLife - lifeTimer, 0, 1) / 2) * 2;
		moveBy(direction.x * factor, direction.y * factor);

		var e = collide(Monster.collisionType, x, y);
		if (e != null)
		{
			var monster = cast(e, Monster);
			monster.takeDamage();
			lifeTimer = 0;
			WaterEmitter.splash(x, y);
			SoundBoard.explosion();
		}

		lifeTimer -= HXP.elapsed;
		if (lifeTimer < 0)
		{
			visible = false;
			scene.remove(this);
		}
	}
}