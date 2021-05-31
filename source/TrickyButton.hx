
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxSprite;

// this class sucks, I hate myself\\
//I hate you too\\

class TrickyButton extends FlxSprite
{
    public var spriteOne:FlxSprite;
    public var spriteTwo:FlxSprite;
    public var pognt:String;

    var selected:Bool = false;
    var tween:FlxTween;

    var trueX:Float;
    var trueY:Float;
    var tweenDistance:Float;

    var func:Void->Void;

    public function new(_x:Int,_y:Int,pngOne:String,pngTwo:String, func:Void->Void, tweenDistance:Float = 0, pogn:String = 'button')
    {
        super(-100,-100);

        tween = FlxTween.tween(this, {x: x}, 0.1);

        this.func = func;

        trueX = _x;
        trueY = _y;
        this.tweenDistance = tweenDistance;

        pognt = pogn;

        spriteOne = new FlxSprite(trueX, trueY - tweenDistance).loadGraphic(Paths.image(pngOne,"clown"));
        spriteTwo = new FlxSprite(trueX, trueY - tweenDistance).loadGraphic(Paths.image(pngTwo,"clown"));
        
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

        tween.cancel();
        tween = FlxTween.tween(spriteOne, {y: trueY}, 0.4, {ease: FlxEase.quintOut});
    }

    public function unHighlight()
    {
        spriteTwo.alpha = 0;
        spriteOne.alpha = 1;

        tween.cancel();
        tween = FlxTween.tween(spriteOne, {y: trueY - tweenDistance}, 0.5, {ease: FlxEase.quintOut});
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