import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.Tween;
import com.haxepunk.HXP;

class ExplosiveSachel extends Entity
{
	public static inline var collisionType = "explosivesachel";

	static var pool:Array<ExplosiveSachel>;
	static var lastTaken = 0;

	public static function initPool(count:Int)
	{
		pool = new Array<ExplosiveSachel>();
		for (ii in 0...count)
		{
			var charge = new ExplosiveSachel();
			pool.push(charge);
		}
	}

	public static function create(x:Float, y:Float, targetX:Float, targetY:Float, throwSpeed:Float)
	{
		var charge:ExplosiveSachel = null;
		for (ii in 0...pool.length)
		{
			var idx = (lastTaken + ii) % pool.length;
			if (!pool[idx].visible)
			{
				charge = pool[idx];
				charge.init(x, y, targetX, targetY, throwSpeed);
				++lastTaken;
				break;
			}
		}

		return charge;
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
		image = Image.createRect(10, 5, Palette.red);
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
			}
		}

		if (!moveTween.active)
		{
			visible = false;
			scene.remove(this);
		}
	}
}