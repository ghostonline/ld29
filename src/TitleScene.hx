import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;

class TitleScene extends Scene
{

	static inline var titleName = "Deep terror";
	static inline var promptText = "Click to start the game...";
	static inline var authorText = "Ludum Dare 29 entry by GhostOnline.";
	static inline var fadeSpeed = 2;

	var title:Text;
	var prompt:Text;
	var author:Text;

	var fadeAwayTween:NumTween;

	public function new(){
		super();

		title = new Text(titleName, 0, 0, 0, {font:"font/DoubleFeature20.ttf"});
		title.size = 64;
		addGraphic(title);

		prompt = new Text(promptText);
		addGraphic(prompt);

		author = new Text(authorText);
		addGraphic(author);

		fadeAwayTween = new NumTween(onTweenDone, TweenType.Persist);
		addTween(fadeAwayTween);
	}

	override public function begin()
	{
		super.begin();

		HXP.screen.color = Palette.lightBlue;
		title.x = (HXP.screen.width - title.textWidth) / 2;
		title.y = 100;
		
		prompt.x = (HXP.screen.width - prompt.textWidth) / 2;
		prompt.y = 200;
		
		author.y = HXP.screen.height - author.textHeight;
		author.x = 0;
	}

	function onTweenDone(tweener)
	{
		HXP.scene = new Tutorial();
	}

	override public function update()
	{
		super.update();

		if (Input.mouseReleased && !fadeAwayTween.active)
		{
			fadeAwayTween.tween(title.y, 0 - title.textHeight, fadeSpeed, Ease.sineIn);
		}
		else if (fadeAwayTween.active)
		{
			title.y = fadeAwayTween.value;
			author.alpha = prompt.alpha = 1 - Macro.smoothstep(fadeAwayTween.percent) * 2;
		}
	}
}