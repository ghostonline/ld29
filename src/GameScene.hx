import com.haxepunk.Scene;
import com.haxepunk.HXP;

class GameScene extends Scene
{
	var monster:Monster;

	public function new()
	{
		super();

		monster = new Monster();
		add(monster);
	}

	public override function begin()
	{
		HXP.screen.color = Palette.lightBlue;
		monster.init(100, 100);
	}
}