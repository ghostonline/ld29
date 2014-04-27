import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class SoundBoard
{
	static var explosionNames = [
		"audio/WaterExplosion2.wav",
		"audio/WaterExplosion3.wav",
		"audio/WaterExplosion4.wav",
		"audio/WaterExplosion5.wav",
		"audio/WaterExplosion6.wav",
	];

	static var hitNames = [
		"audio/Hit_Hurt.wav",
		"audio/Hit_Hurt2.wav",
		"audio/Hit_Hurt3.wav",
	];

	static var explosions:Array<Sfx>;
	static var hits:Array<Sfx>;

	inline public static function preload(files:Array<String>, array:Array<Sfx>)
	{
		for (filename in files)
		{
			array.push(new Sfx(filename));
		}
	}

	inline public static function playRandom(array:Array<Sfx>)
	{
		var idx = Math.floor(HXP.random * array.length);
		array[idx].play();
	}

	public static function init()
	{
		explosions = new Array<Sfx>();
		hits = new Array<Sfx>();
		preload(explosionNames, explosions);
		preload(hitNames, hits);
	}

	public static function explosion()
	{
		playRandom(explosions);
	}

	public static function hit()
	{
		playRandom(hits);
	}
}