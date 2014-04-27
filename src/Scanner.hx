import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.HXP;

class Scanner extends Ship
{
	static inline var maxPursuitTime = 1;
	static inline var scanWidth = 200;
	static inline var scanHeight = 100;

	public function new(game:GameScene){
		super(game);
	}

	override function updateSearching()
	{
		pursuitTimer -= HXP.elapsed;

		var monster = game.findNearestMonster(x, y);
		var dX = Math.abs(monster.x - x);
		var dY = Math.abs(monster.y - y);
		if (dX < scanWidth / 2 && dY < scanHeight / 2)
		{
			pursuitTimer = maxPursuitTime;
			currentTarget.x = lastKnownPosition.x = monster.x;
			currentTarget.y = lastKnownPosition.y = monster.y;
			alert.visible = true;
			monster.setMarked();
		}
	}

	override function updateAttack()
	{
		// Does not attack
	}
}