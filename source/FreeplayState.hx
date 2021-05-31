package;

import flixel.addons.transition.FlxTransitionableState;
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
	public static var diffAndScore:FlxText;
	
	
	public static var diffText:AlphabetTricky;

	override function create() {

		trace(diff);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		songs.push(new TrickyButton(45,120,'menu/freeplay/Improbable Outset Button','menu/freeplay/Improbable Outset Confirm',selectSong,'Improbable-Outset'));
		songs.push(new TrickyButton(80,240,'menu/freeplay/Madness Button','menu/freeplay/Madness Confirm',selectSong,'Madness'));
		songs.push(new TrickyButton(80,340,'menu/freeplay/Hellclown Button','menu/freeplay/Hellclown Confirm',selectSong,'Hellclown'));

			
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

		if (FlxG.save.data.beatenHard)
			songs.push(new TrickyButton(300,470,'menu/freeplay/Expurgation Button','menu/freeplay/Expurgation CONFIRM',selectSong,'expurgation'));
		else
		{
			var locked:FlxSprite = new FlxSprite(300,470).loadGraphic(Paths.image('menu/freeplay/Expurgation LOCKED','clown'));
			add(locked);
		}

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

		var score = Highscore.getScore(songs[selectedIndex].pognt,diff);

		diffAndScore = new FlxText(125,600,0,diffGet() + " - " + score);
		diffAndScore.setFormat("tahoma-bold.ttf",42,FlxColor.RED);

		add(diffAndScore);

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
				return "EASY";
			case 1:
				return "MEDIUM";
			case 2:
				return "HARD";
		}
		return "what";
	}

	function selectSong()
	{
		var poop:String = Highscore.formatSong(songs[selectedIndex].pognt.toLowerCase(), diff);

		PlayState.SONG = Song.loadFromJson(poop, songs[selectedIndex].pognt.toLowerCase());
		PlayState.isStoryMode = false;
		if (songs[selectedIndex].pognt == 'expurgation')
			PlayState.storyDifficulty = 2;
		else
			PlayState.storyDifficulty = diff;
		PlayState.storyWeek = 7;

		LoadingState.loadAndSwitchState(new PlayState());
	}

	override function update(elapsed:Float)
		{
			super.update(elapsed);
	
			var score = Highscore.getScore(songs[selectedIndex].pognt,diff);
			diffAndScore.text = diffGet() + " - " + score; 

			if (FlxG.keys.justPressed.ESCAPE && !selectedSmth)
			{
				selectedSmth = true;
				MainMenuState.curDifficulty = diff;
				FlxG.switchState(new MainMenuState());
			}

			if (FlxG.keys.justPressed.RIGHT)
			{
				FlxG.sound.play(Paths.sound('Hover','clown'));
				diff += 1;
			}
			if (FlxG.keys.justPressed.LEFT)
			{
				FlxG.sound.play(Paths.sound('Hover','clown'));
				diff -= 1;
			}

			if (diff >= 3)
				diff = 0;
			if (diff < 0)
				diff = 2;

			if (FlxG.keys.justPressed.DOWN)
				{
					if (selectedIndex + 1 < songs.length)
					{
						songs[selectedIndex].unHighlight();
						songs[selectedIndex + 1].highlight();
						//doTweensReverse();
						selectedIndex++;
						//doTweens();
						trace('selected ' + selectedIndex);
					}
					else
					{
						//doTweensReverse();
						songs[selectedIndex].unHighlight();
						selectedIndex = 0;
						//doTweens();
						songs[selectedIndex].highlight();
						trace('selected ' + selectedIndex);
					}
				}
				if (FlxG.keys.justPressed.UP)
				{
					if (selectedIndex > 0)
					{
						songs[selectedIndex].unHighlight();
						songs[selectedIndex - 1].highlight();
						//doTweensReverse();
						selectedIndex--;
						//doTweens();
						trace('selected ' + selectedIndex);
					}
					else
					{
						//doTweensReverse();
						songs[selectedIndex].unHighlight();
						songs[songs.length - 1].highlight();
						selectedIndex = songs.length - 1;
						//doTweens();
						trace('selected ' + selectedIndex);
					}
				}
			
	
			if (FlxG.keys.justPressed.ENTER && !selectedSmth)
			{
				selectedSmth = true;
				songs[selectedIndex].select();
			}
		}
}