import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.HXP;

class Ship extends Entity
{
	public static inline var collisionType = "ship";
	public static inline var defaultHealth = 3;

	static inline var speed = 1;
	static inline var minTargetDistance = 1;

	var horizontalGraphic:Image;
	var verticalGraphic:Image;
	var currentTarget:Point;
	var wanderArea:Rectangle;
	var health:Float;

	public function new(){
		super(0,0);
		horizontalGraphic = Image.createRect(20, 10, Palette.brown);
		horizontalGraphic.centerOrigin();
		verticalGraphic = Image.createRect(10, 15, Palette.brown);
		verticalGraphic.centerOrigin();
		graphic = horizontalGraphic;
		setHitboxTo(horizontalGraphic);
		currentTarget = new Point();
		wanderArea = new Rectangle();
		type = collisionType;
	}

	public function init(x:Float, y:Float, wanderArea:Rectangle, health:Float)
	{
		this.x = x; this.y = y;
		this.wanderArea = wanderArea;
		aquireWanderTarget();
		this.health = health;
	}

	function aquireWanderTarget()
	{
		currentTarget.x = HXP.random * wanderArea.width + wanderArea.x;
		currentTarget.y = HXP.random * wanderArea.height + wanderArea.y;

		var dX = Math.abs(currentTarget.x - x);
		var dY = Math.abs(currentTarget.y - y);
		if (dX > dY)
		{
			graphic = horizontalGraphic;
			setHitboxTo(horizontalGraphic);
		}
		else
		{
			graphic = verticalGraphic;
			setHitboxTo(verticalGraphic);
		}
	}

	public function takeDamage(monster:Monster)
	{
		health -= 1;
		if (health <= 0)
		{
			scene.remove(this);
		}
	}

	override public function update()
	{
		super.update();
		moveTowards(currentTarget.x, currentTarget.y, speed);
		layer = Math.floor(-y);
		if (HXP.distanceSquared(x, y, currentTarget.x, currentTarget.y) < minTargetDistance * minTargetDistance)
		{
			aquireWanderTarget();
		}
	}

}