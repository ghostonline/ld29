import flash.geom.Rectangle;

class Hangar
{
	var submarines:Pool<Submarine>;
	var bombers:Pool<Ship>;
	var scanners:Pool<Scanner>;
	var miners:Pool<Miner>;

	public function new(game:GameScene)
	{
		submarines = new Pool<Submarine>();
		submarines.initPool(25, function () { return new Submarine(game); });
		bombers = new Pool<Ship>();
		bombers.initPool(25, function () { return new Ship(game); });
		scanners = new Pool<Scanner>();
		scanners.initPool(25, function () { return new Scanner(game); });
		miners = new Pool<Miner>();
		miners.initPool(25, function () { return new Miner(game); });
	}

	public function submarine(x:Float, y:Float, wanderArea:Rectangle)
	{
		return submarines.get(
			function (instance)
			{
				instance.init(x, y, wanderArea, Ship.defaultHealth);
			});
	}
	
	public function bomber(x:Float, y:Float, wanderArea:Rectangle)
	{
		return bombers.get(
			function (instance)
			{
				instance.init(x, y, wanderArea, Ship.defaultHealth);
			});
	}
	
	public function scanner(x:Float, y:Float, wanderArea:Rectangle)
	{
		return scanners.get(
			function (instance)
			{
				instance.init(x, y, wanderArea, Ship.defaultHealth);
			});
	}
	
	public function miner(x:Float, y:Float, wanderArea:Rectangle)
	{
		return miners.get(
			function (instance)
			{
				instance.init(x, y, wanderArea, Ship.defaultHealth);
			});
	}
}