import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.Tween;
import com.haxepunk.HXP;

class ExplosiveSachel extends Entity
{
	public static inline var collisionType = "explosivesachel";

	static var pool = new Pool<ExplosiveSachel>();

	public static function initPool(count:Int)
	{
		pool.initPool(count, function() { return new ExplosiveSachel(); });
	}

	public static function create(x:Float, y:Float, targetX:Float, targetY:Float, throwSpeed:Float)
	{
		return pool.get(function (instance) { instance.init(x, y, targetX, targetY, throwSpeed); });
	}

	static inline var maxHeight = 25;
	static inline var turnRate = 360 * 2;
	static inline var maxHeightForTopDamage = 0.75;
	var verticalVelocity:Float;
	var travelHeight:Float;
	var moveTween:LinearMotion;
	var image:Image;
	var shadow:Image;

	function new(){
		super(0,0);
		visible = false;
		type = collisionType;
		shadow = Image.createRect(10, 5, Palette.blue);
		shadow.centerOrigin();
		addGraphic(shadow);
		image = new Image("graphics/sachel.png");
		image.scale = 2;
		image.centerOrigin();
		addGraphic(image);
		moveTween = new LinearMotion(null, TweenType.Persist);
		addTween(moveTween);
	}

	function init(x:Float, y:Float, targetX:Float, targetY:Float, throwSpeed:Float)
	{
		this.x = x;
		this.y = y;
		travelHeight = 0;
		moveTween.setMotion(x, y, targetX, targetY, throwSpeed);
		visible = true;
	}

	override public function update()
	{
		super.update();
		if (!visible) return;

		image.angle += turnRate * HXP.elapsed;
		var progress = (moveTween.percent - 0.5) * 2;
		travelHeight = maxHeight * (progress * progress) - maxHeight;
		moveTo(moveTween.x, moveTween.y + travelHeight);
		
		shadow.originY = travelHeight + shadow.height / 2;
		shadow.scaleX = Math.max(1 + (travelHeight / maxHeight), 0.5);

		layer = -Math.floor(y + travelHeight);

		if (moveTween.percent > maxHeightForTopDamage)
		{
			var e = collide(Monster.collisionType, x, y);
			if (e != null)
			{
				var monster = cast(e, Monster);
				if (moveTween.percent == 1 || monster.canTakeTopDamage())
				{
					monster.takeDamage();
					moveTween.active = false;
				}
				SoundBoard.explosion();
			}
		}

		if (!moveTween.active)
		{
			visible = false;
			scene.remove(this);
		}
	}
}