import haxe.macro.Context;

class Macro
{
    macro public static function color(r:Int, g:Int, b:Int)
    {
        var color = (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);
        return Context.makeExpr(color, Context.currentPos());
    }
}