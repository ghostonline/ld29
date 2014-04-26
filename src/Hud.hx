import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import de.polygonal.Printf;
import flash.text.TextFormatAlign;
import com.haxepunk.HXP;

class Hud extends Entity
{
	static inline var scoreTemplate = "%08d";
	static inline var maxLifeCount = 10;

	var scoreLabel:Text;
	var lifeImages:Array<Image>;

	public function new()
	{
		super(0,0);
		scoreLabel = new Text("");
		lifeImages = new Array<Image>();
		for (ii in 0...maxLifeCount)
		{
			var img = Image.createCircle(10, Palette.red);
			img.x = img.width * ii;
			img.visible = false;
			lifeImages.push(img);
			addGraphic(img);
		}
		addGraphic(scoreLabel);
		layer = Layering.hud;
	}

	public function setScore(points:Int)
	{
		scoreLabel.text = Printf.format(scoreTemplate, [points]);
		scoreLabel.x = HXP.screen.width - scoreLabel.textWidth;
	}

	public function setLife(life:Int)
	{
		for (ii in 0...maxLifeCount)
		{
			lifeImages[ii].visible = ii < life;
		}
	}
}