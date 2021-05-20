package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * totally not Loosely based on Alphabet lolol
 */
class AlphabetTricky extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var text:String = "";

	var _finalText:String = "";
	var _curText:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	// custom shit
	// amp, backslash, question mark, apostrophy, comma, angry faic, period
	var lastSprite:TrickyAlphaCharacter;
	var xPosResetted:Bool = false;
	var lastWasSpace:Bool = false;

	var listAllLetters:Array<TrickyAlphaCharacter> = [];

	var splitWords:Array<String> = [];

	var isBold:Bool = false;

	var scaleOf:Float = 1;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false, scale:Float = 1)
	{
		super(x, y);

		_finalText = text;
		this.text = text;
		isBold = bold;

		if (text != "")
		{
			if (typed)
			{
				startTypedText();
			}
			else
			{
				addText();
			}
		}
	}

	public function addText()
	{
		doSplitWords();

		var xPos:Float = 0;
		for (character in splitWords)
		{
			// if (character.fastCodeAt() == " ")
			// {
			// }

			if (character == " " || character == "-")
			{
				lastWasSpace = true;
			}

			if (TrickyAlphaCharacter.alphabet.indexOf(character.toUpperCase()) != -1)
				// if (TrickyAlphaCharacter.alphabet.contains(character.toLowerCase()))
			{
				if (lastSprite != null)
					{
						xPos = lastSprite.x;
					}
	
					if (lastWasSpace)
					{
						xPos += 40;
						lastWasSpace = false;
					}

				// var letter:TrickyAlphaCharacter = new TrickyAlphaCharacter(30 * loopNum, 0);
				var letter:TrickyAlphaCharacter = new TrickyAlphaCharacter(xPos, 0);

				letter.createLetter(character);

				listAllLetters.push(letter);

				add(letter);
					
				letter.setGraphicSize(Std.int(letter.width * scaleOf));

				lastSprite = letter;
			}

			// loopNum += 1;
		}
	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	function resetWord():Void
	{
		for (i in listAllLetters)
			i.destroy();
	}

	public var personTalking:String = 'gf';

	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		// trace(arrayShit);

		var loopNum:Int = 0;

		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			#if (haxe >= "4.0.0")
			var isNumber:Bool = TrickyAlphaCharacter.numbers.contains(splitWords[loopNum]);
			#else
			var isNumber:Bool = TrickyAlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = TrickyAlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			#end

			if (TrickyAlphaCharacter.alphabet.indexOf(splitWords[loopNum].toUpperCase()) != -1 || isNumber)
				// if (TrickyAlphaCharacter.alphabet.contains(splitWords[loopNum].toLowerCase()) || isNumber || isSymbol)

			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += 12;
					// if (isBold)
					// xPos -= 80;
				}
				else
				{
					xPosResetted = false;
				}

				if (lastWasSpace)
				{
					xPos += 16;
					lastWasSpace = false;
				}
				// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));

				// var letter:TrickyAlphaCharacter = new TrickyAlphaCharacter(30 * loopNum, 0);
				var letter:TrickyAlphaCharacter = new TrickyAlphaCharacter(xPos, 55 * yMulti);
				letter.row = curRow;
	
				listAllLetters.push(letter);

					if (isNumber)
					{
						trace('creating numba');
						letter.createNumber(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}
		

				if (FlxG.random.bool(40))
				{
					var daSound:String = "GF_";
					FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
				}

				add(letter);

				letter.setGraphicSize(Std.int(letter.width * scaleOf));

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);
		}

		super.update(elapsed);
	}

	var selected = false;

	public function selectText()
	{
		selected = !selected;
		for (i in listAllLetters)
			i.selected(selected);
	}
}

class TrickyAlphaCharacter extends FlxSprite
{
	public static var alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	public static var numbers:String = "1234567890";

	public var letter:String = "";

	public var row:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var tex = Paths.getSparrowAtlas('menu/Alphabet','clown');
		frames = tex;

		antialiasing = true;
	}

	public function selected(select)
	{
		if (select)
			animation.play(letter + ' CONFIRM');
		else
			animation.play(letter);
	}

	public function createLetter(lette:String):Void
	{
		letter = lette.toUpperCase();
		animation.addByPrefix(letter, letter , 24);
		animation.addByPrefix(letter, letter + ' CONFIRM', 24);
		animation.play(letter);
		updateHitbox();

		FlxG.log.add('the row' + row);

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);

		updateHitbox();
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
				animation.play(letter);
		}

		updateHitbox();
	}
}
