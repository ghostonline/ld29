import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.math.Vector;
import flash.geom.Point;

class Monster extends Entity
{
	static inline var speed = 4;
	static var tmpDirection:Point;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;

	public function new()
	{
		super(0,0);
		horizontalGraphic = Image.createRect(40, 20, Palette.blue);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(20, 30, Palette.blue);
		verticalGraphic.centerOrigin();
		graphic = horizontalGraphic;
		setHitboxTo(horizontalGraphic);
		tmpDirection = new Point();
	}

	public function init(x:Float, y:Float)
	{
		this.x = x; this.y = y;
	}

	override public function update()
	{
		super.update();
		
		tmpDirection.x = 0;
		tmpDirection.y = 0;
		if (Controller.down())
		{
			tmpDirection.y += 1;
		}
		if (Controller.up())
		{
			tmpDirection.y -= 1;
		}
		if (Controller.left())
		{
			tmpDirection.x -= 1;
		}
		if (Controller.right())
		{
			tmpDirection.x += 1;
		}

		if (tmpDirection.x != 0 || tmpDirection.y != 0)
		{
			var frame:Image = null;
			if (Math.abs(tmpDirection.x) > Math.abs(tmpDirection.y))
			{
				frame = horizontalGraphic;
			}
			else
			{
				frame = verticalGraphic;
			}
			setHitboxTo(frame);
			graphic = frame;

			tmpDirection.normalize(speed);
			moveBy(tmpDirection.x, tmpDirection.y);
		}
	}
}