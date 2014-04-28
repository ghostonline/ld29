import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;

class Tutorial extends Scene
{

	public function new(){
		super();
	}

	function createBoat(y, boatName, description)
	{
		var image = new Spritemap("graphics/ships.png", 32, 24);
		image.add("bomber", [0, 1, 2, 3], 4);
		image.add("miner", [4, 5, 6, 7], 4);
		image.add("scanner", [8, 9, 10, 11], 4);
		image.add("submarine", [12, 13, 14, 15], 4);
		image.scale = 2;
		image.centerOrigin();
		image.play(boatName);
		var boat = addGraphic(image);
		boat.x = 100;
		boat.y = y;
		
		var description = addGraphic(new Text(description, 0,0,400, 100, {wordWrap:true}));
		description.x = 200;
		description.y = y;
	}

	override public function begin()
	{
		super.begin();
		
		var welcome = new Text("Meet your enemies:");
		welcome.x = (HXP.screen.width - welcome.textWidth) / 2;
		welcome.y = 50;
		addGraphic(welcome);
		
		var startY = 100;
		var increment = 75;
		createBoat(startY, "bomber", "Tosses explosive sachels when it thinks the monster is near.");
		startY += increment;
		createBoat(startY, "miner", "Drops mines while cruising around.");
		startY += increment;
		createBoat(startY, "scanner", "Able to detect the monster even when underwater, alerts other boats.");
		startY += increment;
		createBoat(startY, "submarine", "Stays at the side, launches torpedoes, but is useless when in close combat.");

		var prompt = new Text("Click to start the game");
		prompt.x = (HXP.screen.width - prompt.textWidth) / 2;
		prompt.y = 400;
		addGraphic(prompt);
	}

	override public function update()
	{
		super.update();

		if (Input.mouseReleased)
		{
			HXP.scene = new GameScene();
		}
	}
}