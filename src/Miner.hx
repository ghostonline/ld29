import com.haxepunk.HXP;

class Miner extends Ship
{

	static inline var chargeCooldown = 1;
	
	public function new(game:GameScene){
		super(game);
	}

	override function updateSearching()
	{
		// Does not seek out the player
	}

	override function updateAttack()
	{
		chargeTimer -= HXP.elapsed;
		if (chargeTimer < 0)
		{
			chargeTimer = chargeCooldown;
			var charge = Mine.create(x, y);
			if (charge != null) { scene.add(charge); }
		}
	}
}