import com.haxepunk.Entity;

class Pool<T : Entity>
{
	var pool:Array<T>;
	var lastTaken = 0;

	public function new()
	{
	}

	public function initPool(count:Int, construct:Void->T)
	{
		pool = new Array<T>();
		for (ii in 0...count)
		{
			var instance = construct();
			pool.push(instance);
		}
	}

	public function get(init:T->Void)
	{
		var instance:T = null;
		for (ii in 0...pool.length)
		{
			var idx = (lastTaken + ii) % pool.length;
			if (!pool[idx].visible)
			{
				instance = pool[idx];
				init(instance);
				++lastTaken;
				break;
			}
		}
		return instance;
	}
}