import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;

class AlertIcon extends Entity
{
	public static function createExclamation()
	{
		var icon = new AlertIcon();
		var iconGraphic = new Image("graphics/exclamation.png");
		iconGraphic.scale = 2;
		iconGraphic.originX = (iconGraphic.width * 2 * 0.5);
		iconGraphic.originY = iconGraphic.height + 15;
		icon.graphic = iconGraphic;
		return icon;
	}

	public static function createArrow()
	{
		var icon = new AlertIcon();
		var iconGraphic = new Spritemap("graphics/detected.png", 6, 8);
		iconGraphic.add("default", [0, 1], 4);
		iconGraphic.scale = 2;
		iconGraphic.centerOrigin();
		iconGraphic.originY += 20;
		iconGraphic.play("default");
		icon.graphic = iconGraphic;
		return icon;
	}

	function new()
	{
		super(0,0);
		visible = false;
		layer = Layering.hud;
	}
}