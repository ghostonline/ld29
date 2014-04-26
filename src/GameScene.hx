import com.haxepunk.Scene;
import com.haxepunk.HXP;
import flash.geom.Rectangle;

class GameScene extends Scene
{
	static inline var initialLife = 5;

	var monster:Monster;
	var ship:Ship;
	var destroyed:Array<Ship>;
	var hud:Hud;
	var life:Int;
	var score:Int;

	public function new()
	{
		super();
		hud = new Hud();
		add(hud);
		life = initialLife;
		score = 0;
		hud.setScore(score);
		hud.setLife(life);
		ExplosiveSachel.initPool(25);
		Mine.initPool(50);
		Torpedo.initPool(25);
		destroyed = new Array<Ship>();
		monster = new Monster(this);
		add(monster);

		ship = new Submarine(this);
		add(ship);
	}

	public function onShipDestroy(ship:Ship)
	{
		score += ship.score;
		hud.setScore(score);
		destroyed.push(ship);
	}

	public function onMonsterHit(monster:Monster)
	{
		--life;
		hud.setLife(life);
	}

	public function findNearestMonster(x:Float, y:Float)
	{
		return monster;
	}

	public override function begin()
	{
		super.begin();

		HXP.screen.color = Palette.lightBlue;
		monster.init(100, 100);
		initShip(ship);
	}

	function initShip(ship:Ship)
	{
		var offscreenPadding = 25;
		var offscreenX = HXP.random * (offscreenPadding * 2) - offscreenPadding;
		var offscreenY = HXP.random * (offscreenPadding * 2) - offscreenPadding;
		if (offscreenX > 0)
		{
			offscreenX += HXP.screen.width;
		}
		if (offscreenY > 0)
		{
			offscreenY += HXP.screen.height;
		}

		var shipWanderArea = new Rectangle(0, 0, HXP.screen.width, HXP.screen.height);
		shipWanderArea.inflate(-50, -50);
		ship.init(offscreenX, offscreenY, shipWanderArea, Ship.defaultHealth);
	}

	public override function update()
	{
		super.update();
		while (destroyed.length > 0)
		{
			var ship = destroyed.pop();
			initShip(ship);
		}
	}
}