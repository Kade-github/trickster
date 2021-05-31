import flixel.FlxG;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class OptionText extends FlxText
{
    public var targetY:Float;

    public function new(yy:Float,xx,yyy,fuck,string)
    {
        trace('create ');
        targetY = yy;
        trace(targetY);
        super(xx,yyy,fuck,string);
    }

    override function update(elapsed:Float)
    {
        var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

        y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.30);
        x = FlxMath.lerp(x, (targetY * 20) + 90, 0.30);
        
        super.update(elapsed);
    }
}