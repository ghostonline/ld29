import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
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
		var iconGraphic = new Text("V", 0, 0, 0, 0, {size:24});
		iconGraphic.originX = iconGraphic.textWidth * 0.5;
		iconGraphic.originY = 40 + iconGraphic.textHeight * 0.5;
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