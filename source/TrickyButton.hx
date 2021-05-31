
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

    public var selected:Bool = false;
    public var tween:FlxTween;

    public var trueX:Float;
    public var trueY:Float;
    public var tweenX:Float;
    public var tweenY:Float;
    

    public var func:Void->Void;

    public function new(_x:Int,_y:Int,pngOne:String,pngTwo:String, func:Void->Void, pogn:String = 'button', tweenDistanceX:Float = 0, tweenDistanceY:Float = 0)
    {
        super(-100,-100);

        tween = FlxTween.tween(this, {x: x}, 0.1);

        this.func = func;

        trueX = _x;
        trueY = _y;
        tweenX = tweenDistanceX;
        tweenY = tweenDistanceY;

        pognt = pogn;

        spriteOne = new FlxSprite(trueX + tweenX, trueY + tweenY).loadGraphic(Paths.image(pngOne,"clown"));
        spriteTwo = new FlxSprite(trueX + tweenX, trueY + tweenY).loadGraphic(Paths.image(pngTwo,"clown"));

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

        tween.cancel();
        tween = FlxTween.tween(spriteOne, {y: trueY, x: trueX}, 0.4, {ease: FlxEase.quintOut});
    }

    public function unHighlight()
    {
        spriteTwo.alpha = 0;
        spriteOne.alpha = 1;

        tween.cancel();
        tween = FlxTween.tween(spriteOne, {y: trueY + tweenY, x: trueX + tweenX, }, 0.5, {ease: FlxEase.quintOut});
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