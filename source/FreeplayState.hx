package;

import AlphabetTricky.TrickyAlphaCharacter;
import flixel.system.FlxSound;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{

	public var songs:Array<TrickyButton> = [];
	var selectedIndex = 0;
	var selectedSmth = false;
	public static var diff = 0;
	
	public static var diffText:AlphabetTricky;

	override function create() {

		songs.push(new TrickyButton(45,120,'menu/freeplay/Improbable Outset Button','menu/freeplay/Improbable Outset Confirm',selectSong,'improbable-outset'));
		songs.push(new TrickyButton(80,240,'menu/freeplay/Madness Button','menu/freeplay/Madness Confirm',selectSong,'madness'));
		songs.push(new TrickyButton(80,340,'menu/freeplay/Hellclown Button','menu/freeplay/Hellclown Confirm',selectSong,'hellclown'));

		var bg:FlxSprite = new FlxSprite(-10,-10).loadGraphic(Paths.image('menu/freeplay/RedBG','clown'));
		add(bg);
		var hedge:FlxSprite = new FlxSprite(-810,-335).loadGraphic(Paths.image('menu/freeplay/hedge','clown'));
		hedge.setGraphicSize(Std.int(hedge.width * 0.65));
		add(hedge);
		var shade:FlxSprite = new FlxSprite(-205,-100).loadGraphic(Paths.image('menu/freeplay/Shadescreen','clown'));
		shade.setGraphicSize(Std.int(shade.width * 0.65));
		add(shade);
		var bars:FlxSprite = new FlxSprite(-225,-395).loadGraphic(Paths.image('menu/freeplay/theBox','clown'));
		bars.setGraphicSize(Std.int(bars.width * 0.65));
		add(bars);

		for (i in songs)
			{
				// just general compensation since pasc made this on 1920x1080 and we're on 1280x720
				i.spriteOne.setGraphicSize(Std.int(i.spriteOne.width * 0.7));
				i.spriteTwo.setGraphicSize(Std.int(i.spriteTwo.width * 0.7));
				add(i);
				add(i.spriteOne);
				add(i.spriteTwo);
			}

		//diffText = new AlphabetTricky(80,500,"Current Difficulty is " + diffGet());
		//add(diffText);

		var menuShade:FlxSprite = new FlxSprite(-1350,-1190).loadGraphic(Paths.image("menu/freeplay/Menu Shade","clown"));
		menuShade.setGraphicSize(Std.int(menuShade.width * 0.7));
		add(menuShade);

		songs[0].highlight();

	}

	function diffGet()
	{
		switch (diff)
		{
			case 0:
				return "easy";
			case 1:
				return "normal";
			case 2:
				return "hard";
		}
		return "what";
	}

	function selectSong()
	{
		var poop:String = Highscore.formatSong(songs[selectedIndex].pognt.toLowerCase(), diff);

		PlayState.SONG = Song.loadFromJson(poop, songs[selectedIndex].pognt.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = diff;
		PlayState.storyWeek = 7;

		LoadingState.loadAndSwitchState(new PlayState());
	}

	override function update(elapsed:Float)
		{
			super.update(elapsed);
	
			if (FlxG.keys.justPressed.BACKSPACE && !selectedSmth)
			{
				selectedSmth = true;
				FlxG.switchState(new MainMenuState());
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				if (selectedIndex + 1 < songs.length)
				{
					songs[selectedIndex].unHighlight();
					songs[selectedIndex + 1].highlight();
					selectedIndex++;
					trace('selected ' + selectedIndex);
				}
				else
					trace('CANT select ' + selectedIndex);
			}
			if (FlxG.keys.justPressed.UP)
			{
				if (selectedIndex > 0)
				{
					songs[selectedIndex].unHighlight();
					songs[selectedIndex - 1].highlight();
					selectedIndex--;
					trace('selected ' + selectedIndex);
				}
				else
					trace('CANT select ' + selectedIndex);
			}
			
	
			if (FlxG.keys.justPressed.ENTER && !selectedSmth)
			{
				selectedSmth = true;
				songs[selectedIndex].select();
			}
		}
}