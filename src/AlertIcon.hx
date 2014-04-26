import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class AlertIcon extends Entity
{
	public function new()
	{
		super(0,0);
		var icon = new Text("!", 0, 0, 0, 0, {size:24});
		icon.originX = icon.textWidth * 0.5;
		icon.originY = 25 + icon.textHeight * 0.5;
		graphic = icon;
		visible = false;
		layer = Layering.hud;
	}
}