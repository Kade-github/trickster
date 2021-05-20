
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;

// this class sucks, I hate myself

class TrickyButton extends FlxSprite
{
    public var spriteOne:FlxSprite;
    public var spriteTwo:FlxSprite;
    public var pognt:String;

    var selected:Bool = false;

    var func:Void->Void;

    public function new(x:Int,y:Int,pngOne:String,pngTwo:String, func:Void->Void, pogn:String = 'button')
    {
        super(-100,-100);

        this.func = func;

        pognt = pogn;

        spriteOne = new FlxSprite(x,y).loadGraphic(Paths.image(pngOne,"clown"));
        spriteTwo = new FlxSprite(x,y).loadGraphic(Paths.image(pngTwo,"clown"));
        
        spriteTwo.alpha = 0;
    }

    override function update(elapsed)
    {
        super.update(elapsed);
    }

    public function highlight()
    {
        spriteTwo.alpha = 1;
        spriteOne.alpha = 0;
    }

    public function unHighlight()
    {
        spriteTwo.alpha = 0;
        spriteOne.alpha = 1;
    }

    public function select()
    {
        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("confirm","clown"));
        sound.play();
        new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
            func();
        });
    }
}