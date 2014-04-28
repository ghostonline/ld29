import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Controller
{
	inline public static function down()
	{
		return Input.check(Key.DOWN) || Input.check(Key.S);
	}

	inline public static function up()
	{
		return Input.check(Key.UP) || Input.check(Key.W);
	}

	inline public static function left()
	{
		return Input.check(Key.LEFT) || Input.check(Key.A);
	}

	inline public static function right()
	{
		return Input.check(Key.RIGHT) || Input.check(Key.D);
	}
	
	inline public static function attack()
	{
		return Input.check(Key.Z) || Input.check(Key.SPACE);
	}
}