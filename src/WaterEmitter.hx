import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;
import com.haxepunk.Scene;
import flash.display.BitmapData;
import com.haxepunk.HXP;

class WaterEmitter extends Entity
{
	static var instance:WaterEmitter;

	public static function init(scene:Scene)
	{
		var emitter = new Emitter(new BitmapData(3,3, false, 0xFFFFFFFF));
		var particle = emitter.newType("splash");
		particle.setAlpha(1, 0, Ease.sineOut);
		particle.setColor(Palette.blue, Palette.blue);
		particle.setGravity(1, 1);
		particle.setMotion(90 - 45, 50, 1, 90, 10);
		
		var particle = emitter.newType("air");
		particle.setAlpha(1, 0, Ease.sineOut);
		particle.setColor(Palette.white, Palette.white);
		particle.setMotion(90 - 45, 50, 1, 90, 10);


		instance = new WaterEmitter(emitter);
		scene.add(instance);
	}

	public static function splash(x:Float, y:Float)
	{
		instance.doSplash(x, y);
	}

	public static function monsterSplash(x:Float, y:Float)
	{
		instance.doMonsterSplash(x, y);
	}

	var emitter:Emitter;
	static inline var splashParticleCount = 10;
	static inline var splashAirParticleCount = 5;
	static inline var monsterSplashParticleCount = 20;
	static inline var monsterSplashAirParticleCount = 15;

	public function new(emitter:Emitter){
		super(0,0);
		this.emitter = emitter;
		graphic = emitter;
		layer = -HXP.screen.height;
	}

	function doSplash(x:Float, y:Float)
	{
		for (ii in 0...splashParticleCount)
		{
			emitter.emitInRectangle("splash", x, y, 10, 5);
		}
		for (ii in 0...splashAirParticleCount)
		{
			emitter.emitInRectangle("air", x, y, 10, 5);
		}
	}
	
	function doMonsterSplash(x:Float, y:Float)
	{
		for (ii in 0...monsterSplashParticleCount)
		{
			emitter.emitInRectangle("splash", x, y, 32, 10);
		}
		for (ii in 0...monsterSplashAirParticleCount)
		{
			emitter.emitInRectangle("air", x - 16, y, 32, 10);
		}
	}
}