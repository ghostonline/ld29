import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

class Debris extends Entity
{
	static var pool = new Pool<Debris>();

	public static function initPool(count:Int, scene:Scene)
	{
		pool.initPool(count, function() { return new Debris(scene); });
	}

	public static function create(x:Float, y:Float, throwSpeed:Float)
	{
		return pool.get(function (instance) { instance.init(x, y, throwSpeed); });
	}
	
	static inline var maxHeight = 25;
	static inline var turnRate = 360 * 2;
	static inline var maxHeightForTopDamage = 0.75;
	static inline var radius = 50;
	var verticalVelocity:Float;
	var travelHeight:Float;
	var moveTween:LinearMotion;
	var image:Spritemap;
	var shadow:Image;
	var targetScene:Scene;

	function new(scene:Scene){
		super(0,0);
		visible = false;
		shadow = Image.createRect(10, 5, Palette.blue);
		shadow.centerOrigin();
		addGraphic(shadow);
		image = new Spritemap("graphics/debris.png", 8, 8);
		image.scale = 2;
		image.centerOrigin();
		addGraphic(image);
		moveTween = new LinearMotion(null, TweenType.Persist);
		addTween(moveTween);
		targetScene = scene;
	}

	function init(x:Float, y:Float, throwSpeed:Float)
	{
		this.x = x;
		this.y = y;
		travelHeight = 0;

		var targetAngle = 360 * HXP.random;
		var target = {x:0.0, y:0.0};
		HXP.angleXY(target, targetAngle, radius);
		target.y *= 0.5;

		moveTween.setMotion(x, y, x + target.x, y + target.y, throwSpeed);
		image.setFrame(Math.floor(image.frameCount * HXP.random));
		visible = true;
		targetScene.add(this);
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

		layer = -Math.floor(y - travelHeight);

		if (!moveTween.active)
		{
			visible = false;
			scene.remove(this);
		}
	}
}