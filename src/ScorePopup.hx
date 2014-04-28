import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.utils.Ease;

class ScorePopup extends Entity
{

	static var pool = new Pool<ScorePopup>();

	public static function initPool(count:Int, scene:Scene)
	{
		pool.initPool(count, function() { return new ScorePopup(scene); });
	}

	public static function create(x:Float, y:Float, text:String)
	{
		return pool.get(function (instance) { instance.init(x, y, text); });
	}

	static inline var driftDuration = 2;
	static inline var driftHeight = 30;

	var label:Text;
	var targetScene:Scene;
	var drifter:LinearMotion;

	public function new(scene:Scene){
		super(0,0);
		label = new Text("");
		graphic = label;
		targetScene = scene;
		drifter = new LinearMotion(null, TweenType.Persist);
		addTween(drifter);
		visible = false;
		layer = Layering.hud;
	}

	public function init(x:Float, y:Float, text:String)
	{
		this.x = x; this.y = y;
		targetScene.add(this);
		label.text = text;
		label.originX = label.textWidth / 2;
		label.originY = label.textHeight;
		visible = true;
		drifter.setMotion(x, y, x, y - driftHeight, driftDuration, Ease.sineOut);
	}

	override public function update()
	{
		super.update();
		x = drifter.x;
		y = drifter.y;

		if (!drifter.active)
		{
			scene.remove(this);
			visible = false;
		}
	}
}