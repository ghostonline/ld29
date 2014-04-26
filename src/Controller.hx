import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Controller
{
	inline public static function down()
	{
		return Input.check(Key.DOWN);
	}

	inline public static function up()
	{
		return Input.check(Key.UP);
	}

	inline public static function left()
	{
		return Input.check(Key.LEFT);
	}

	inline public static function right()
	{
		return Input.check(Key.RIGHT);
	}
	
	inline public static function attack()
	{
		return Input.check(Key.Z);
	}
}