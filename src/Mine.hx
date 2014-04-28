import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.Tween;
import com.haxepunk.HXP;

class Mine extends Entity
{
	public static inline var collisionType = "mine";

	static var pool = new Pool<Mine>();

	public static function initPool(count:Int)
	{
		pool.initPool(count, function() { return new Mine(); });
	}

	public static function create(x:Float, y:Float)
	{
		var charge = pool.get(function (mine) { mine.init(x, y); });
		return charge;
	}

	static inline var bobAmplitude = 3;
	static inline var bobSpeed = 1;
	static inline var turnRate = 360 * 0.25;
	static inline var defaultMineLife = 4;
	static inline var primeTimeout = 0.5;
	var moveTween:CircularMotion;
	var image:Image;
	var lifeTimer:Float;
	var primeTimer:Float;

	function new(){
		super(0,0);
		visible = false;
		type = collisionType;
		image = Image.createRect(10, 5, Palette.blue);
		image.centerOrigin();
		addGraphic(image);
		moveTween = new CircularMotion(null, TweenType.Looping);
		addTween(moveTween);
	}

	function init(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
		moveTween.setMotion(x, y, bobAmplitude, HXP.random * 360, true, bobSpeed);
		image.angle = HXP.random * 360;
		visible = true;
		lifeTimer = defaultMineLife;
		primeTimer = primeTimeout;
	}

	override public function update()
	{
		super.update();
		if (!visible) return;

		image.angle += turnRate * HXP.elapsed;
		y = moveTween.y;

		primeTimer -= HXP.elapsed;
		if (primeTimer < 0)
		{
			var e = collide(Monster.collisionType, x, y);
			if (e != null)
			{
				var monster = cast(e, Monster);
				monster.takeDamage();
				lifeTimer = 0;
				SoundBoard.explosion();
			}
		}

		lifeTimer -= HXP.elapsed;

		if (lifeTimer < 0)
		{
			WaterEmitter.splash(x, y);
			visible = false;
			scene.remove(this);
		}
	}
}