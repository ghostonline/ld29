import com.haxepunk.Scene;
import com.haxepunk.HXP;
import flash.geom.Rectangle;

class GameScene extends Scene
{
	var monster:Monster;
	var ship:Ship;

	public function new()
	{
		super();

		monster = new Monster();
		add(monster);
		ship = new Ship();
		add(ship);
	}

	public override function begin()
	{
		HXP.screen.color = Palette.lightBlue;
		monster.init(100, 100);
		var shipWanderArea = new Rectangle(0, 0, HXP.screen.width, HXP.screen.height);
		shipWanderArea.inflate(-50, -50);
		ship.init(200, 100, shipWanderArea, Ship.defaultHealth);
	}
}