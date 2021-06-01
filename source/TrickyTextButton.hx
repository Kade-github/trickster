
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxSprite;

// tricky button but for text

class TrickyTextButton extends FlxSprite
{
    public var spriteOne:FlxText;
    public var spriteTwo:FlxText;
    public var pognt:String;

    public var selected:Bool = false;

    public var func:Void->Void;

    public function new(_x:Int,_y:Int,textOne:String,textTwo:String, size:Int, func:Void->Void, pogn:String = 'button')
    {
        super(-100,-100);

        this.func = func;

        pognt = pogn;

        spriteOne = new FlxText(x,y,0,textOne, size);
        spriteTwo =  new FlxText(x,y,0,textTwo, size);

        spriteOne.setFormat("tahoma-bold.ttf",size,FlxColor.RED);
        spriteTwo.setFormat("tahoma-bold.ttf",size,FlxColor.WHITE);

        spriteOne.antialiasing = true;
        spriteTwo.antialiasing = true;
        
        spriteTwo.alpha = 0;
    }

    override function update(elapsed)
    {
        super.update(elapsed);
        spriteTwo.x = spriteOne.x;
        spriteTwo.y = spriteOne.y;
    }

    public function highlight(playSound:Bool = true)
    {
        if (playSound)
        {
            var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("Hover","clown"));
            sound.play();
        }
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