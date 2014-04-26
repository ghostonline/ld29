import com.haxepunk.HXP;

class Submarine extends Ship
{

	static inline var maxPursuitTime = 3;
	static inline var chargeCooldown = 1.5;
	
	public function new(game:GameScene){
		super(game);
	}

	override function updateSearching()
	{
		var monster = game.findNearestMonster(x, y);
		pursuitTimer -= HXP.elapsed;
		if (monster.isVisibleFromSurface())
		{
			pursuitTimer = maxPursuitTime;
			currentTarget.x = lastKnownPosition.x = monster.x;
			currentTarget.y = lastKnownPosition.y = monster.y;
			alert.visible = true;
		}
	}

	override function updateAttack()
	{
		chargeTimer -= HXP.elapsed;
		if (chargeTimer < 0 && pursuitTimer > 0)
		{
			chargeTimer = chargeCooldown;
			var angle = HXP.angle(x, y, lastKnownPosition.x, lastKnownPosition.y);
			var charge = Torpedo.create(x, y, angle);
			if (charge != null) { scene.add(charge); }
		}
	}
}