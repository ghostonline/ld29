import com.haxepunk.Scene;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import de.polygonal.Printf;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

class GameOverScene extends Scene
{
	static inline var slainText = "You have been slain!";
	static inline var wreckTemplateText = "Final score: %d";
	static inline var thanksText = "Thanks for playing!";
	static inline var bounceSpeed = 2;
	static inline var fadeSpeed = 0.5;

	var slain:Text;
	var wreck:Text;
	var thanks:Text;

	var bounceTween:NumTween;
	var fadeInTween:NumTween;

	public function new(score:Int){
		super();

		slain = new Text(slainText);
		slain.size = 32;
		addGraphic(slain);

		var wreckText = Printf.format(wreckTemplateText, [score]);
		wreck = new Text(wreckText);
		wreck.size = 24;
		addGraphic(wreck);

		thanks = new Text(thanksText);
		addGraphic(thanks);

		bounceTween = new NumTween(onBounceComplete, TweenType.Persist);
		addTween(bounceTween);
		fadeInTween = new NumTween(null, TweenType.Persist);
		addTween(fadeInTween);
	}

	override public function begin()
	{
		super.begin();

		slain.x = (HXP.screen.width - slain.textWidth) / 2;
		slain.y = 0 - slain.textHeight;

		wreck.x = (HXP.screen.width - wreck.textWidth) / 2;
		wreck.y = 200;

		thanks.x = (HXP.screen.width - thanks.textWidth) / 2;
		thanks.y = 400;

		fadeInTween.value = 0;
		bounceTween.tween(slain.y, 100, bounceSpeed, Ease.bounceOut);
	}

	function onBounceComplete(tween)
	{
		fadeInTween.tween(0, 1, fadeSpeed, Ease.sineInOut);
	}

	override public function update()
	{
		super.update();

		slain.y = bounceTween.value;
		wreck.alpha = fadeInTween.value;
		thanks.alpha = fadeInTween.value;
	}
}