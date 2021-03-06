import com.haxepunk.Scene;
import com.haxepunk.HXP;
import de.polygonal.Printf;
import flash.geom.Rectangle;

class GameScene extends Scene
{
	static inline var initialLife = 5;
	static inline var maxLife = 10;
	static inline var overflowScore = 1000;
	static inline var levelUpText = "Level up!\n";
	static inline var bonusLifeText = "+1 life";
	static inline var bonusScoreText = "+%d score";

	var monster:Monster;
	var hangar:Hangar;
	var destroyed:Array<Ship>;
	var hud:Hud;
	var life:Int;
	var score:Int;
	var levelDeathCount:Int;
	var level:Int;

	public function new()
	{
		super();
		hud = new Hud();
		add(hud);
		life = initialLife;
		score = 0;
		level = 0;
		hud.setScore(score);
		hud.setLife(life);
		ExplosiveSachel.initPool(25);
		Mine.initPool(50);
		Torpedo.initPool(25);
		Debris.initPool(50, this);
		ScorePopup.initPool(25, this);
		WaterEmitter.init(this);
		destroyed = new Array<Ship>();
		monster = new Monster(this);
		add(monster);

		hangar = new Hangar(this);
	}

	function loadLevel(level:String)
	{
		levelDeathCount = 0;
		for (idx in 0...level.length)
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

			var char = level.charAt(idx);
			var instance:Ship = null;
			switch(char)
			{
			case Level.bomber:
				instance = hangar.bomber(offscreenX, offscreenY, shipWanderArea);
			case Level.scanner:
				instance = hangar.scanner(offscreenX, offscreenY, shipWanderArea);
			case Level.miner:
				instance = hangar.miner(offscreenX, offscreenY, shipWanderArea);
			case Level.submarine:
				shipWanderArea = selectRandomBorder(shipWanderArea);
				instance = hangar.submarine(offscreenX, offscreenY, shipWanderArea);
			}

			if (instance != null)
			{ 
				add(instance);
				++levelDeathCount;
			}
		}
	}

	function selectRandomBorder(rect:Rectangle)
	{
		var factor = HXP.random;
		if (factor < 0.25)
		{
			rect.width = 0;
		}
		else if (factor < 0.5)
		{
			rect.x += rect.width;
			rect.width = 0;
		}
		else if (factor < 0.75)
		{
			rect.height = 0;
		}
		else
		{
			rect.y += rect.height;
			rect.height = 0;
		}
		return rect;
	}

	public function onShipDestroy(ship:Ship)
	{
		remove(ship);

		--levelDeathCount;
		var popupText = "";
		if (levelDeathCount == 0)
		{
			++level;
			if (level >= Level.levels.length) { level = Level.levels.length - 1; }
			loadLevel(Level.levels[level]);

			if (life < maxLife)
			{
				popupText = levelUpText + bonusLifeText;
				++life;
			}
			else
			{
				popupText = levelUpText + Printf.format(bonusScoreText, [overflowScore]);
				score += overflowScore;
			}
			SoundBoard.levelUp();
		}
		else
		{
			popupText = Printf.format(bonusScoreText, [ship.score]);
			score += ship.score;
			SoundBoard.score();
		}
		
		ScorePopup.create(ship.x, ship.y, popupText);

		hud.setScore(score);
		hud.setLife(life);
	}

	public function onMonsterHit(monster:Monster)
	{
		--life;
		hud.setLife(life);
		if (life < 0)
		{
			HXP.scene = new GameOverScene(score);
		}
	}

	public function findNearestMonster(x:Float, y:Float)
	{
		return monster;
	}

	public override function begin()
	{
		super.begin();

		HXP.screen.color = Palette.lightBlue;
		monster.init(HXP.screen.width / 2, HXP.screen.height / 2);

		loadLevel(Level.levels[level]);
	}
}