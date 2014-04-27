import com.haxepunk.HXP;

class Submarine extends Ship
{

	static inline var maxPursuitTime = 3;
	static inline var chargeCooldown = 1.5;
	static inline var minFireRange = 50;
	
	public function new(game:GameScene){
		super(game);
		image.play("submarine");
	}

	override function aquireWanderTarget()
	{
		currentTarget.x = HXP.random * wanderArea.width + wanderArea.x;
		currentTarget.y = HXP.random * wanderArea.height + wanderArea.y;
	}

	override function updateSearching()
	{
		var monster = game.findNearestMonster(x, y);
		pursuitTimer -= HXP.elapsed;
		if (monster.isVisibleFromSurface())
		{
			pursuitTimer = maxPursuitTime;
			lastKnownPosition.x = monster.x;
			lastKnownPosition.y = monster.y;
			alert.visible = true;
		}
	}

	override function updateAttack()
	{
		chargeTimer -= HXP.elapsed;
		if (chargeTimer < 0 && pursuitTimer > 0)
		{
			var distance = HXP.distance(x, y, lastKnownPosition.x, lastKnownPosition.y);
			if (distance > minFireRange)
			{
				chargeTimer = chargeCooldown;
				var angle = HXP.angle(x, y, lastKnownPosition.x, lastKnownPosition.y);
				var charge = Torpedo.create(x, y, angle);
				if (charge != null) { scene.add(charge); }
			}
		}
	}
}