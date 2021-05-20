package;

import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var slider:FlxBackdrop;
	var show:String = "";
	var shower:FlxSprite;
	public static var curDifficulty:Int = 1;
	public static var trans:FlxSprite;

	var clownButton:TrickyButton;

	public var listOfButtons:Array<TrickyButton> = 
	[
	new TrickyButton(800, 160, 'menu/Clown Mode Button', 'menu/Clown Mode Button CONFIRM', playStory,'clown'),
	new TrickyButton(1010, 165, 'menu/FreePlayButton', 'menu/FreePlayButton CONFIRM', goToFreeplay)
	];
	var listOfDiff:Array<String> = ['easy','medium','hard'];

	override function create()
	{
		trans = new FlxSprite(-300,-760);
		trans.frames = Paths.getSparrowAtlas('Jaws','clown');
		trans.antialiasing = true;

		trans.animation.addByPrefix("Close","Jaws smol", 24, false);
		
		trace(trans.animation.frames);

		trans.setGraphicSize(Std.int(trans.width * 1.38));

		var bg:FlxSprite = new FlxSprite(-10,-10).loadGraphic(Paths.image('menu/RedBG','clown'));
		add(bg);
		var hedgeBG:FlxSprite = new FlxSprite(-750,110).loadGraphic(Paths.image('menu/HedgeBG','clown'));
		hedgeBG.setGraphicSize(Std.int(hedgeBG.width * 0.65));
		add(hedgeBG);
		var foreground:FlxSprite = new FlxSprite(-750,110).loadGraphic(Paths.image('menu/Transforeground','clown'));
		foreground.setGraphicSize(Std.int(foreground.width * 0.65));
		add(foreground);
		slider = new FlxBackdrop(Paths.image('menu/MenuSlider','clown'),1,0,true,false);
		slider.velocity.set(-14,0);
		slider.x = -20;
		slider.y = 209;
		slider.setGraphicSize(Std.int(slider.width * 0.65));
		add(slider);

		// figure out who the fuck do I show lol

		var random = FlxG.random.float(0,10000);
		show = 'bf';
		if (random >= 6000 && random <= 9998)
			show = 'tricky';
		else if (random > 9800)
			show = 'sus';

		trace('random ' + random + ' im showin ' + show);

		shower = new FlxSprite(200,280);

		switch(show)
		{
			case 'bf':
				shower.frames = Paths.getSparrowAtlas("menu/MenuBF/MenuBF","clown");
				shower.animation.addByPrefix('idle','BF idle menu');
				shower.flipX = true;
			case 'tricky':
				shower.frames = Paths.getSparrowAtlas("menu/MenuTricky/MenuTricky","clown");
				shower.animation.addByPrefix('idle','menutricky');
				shower.y -= 155;
			case 'sus':
				shower.frames = Paths.getSparrowAtlas("menu/Sus/Menu_ALLSUS","clown");
				shower.animation.addByPrefix('idle','AmongUsIDLE');
				shower.animation.addByPrefix('death','AMONG DEATH');
				shower.animation.addByPrefix('no','AmongUs NuhUh');
		}
		

		shower.setGraphicSize(Std.int(shower.width * 0.76));

		shower.animation.play('idle');

		add(shower);

		var bgCover:FlxSprite = new FlxSprite(-10,-445).loadGraphic(Paths.image('menu/BGCover','clown'));
		add(bgCover);

		var hedgeCover:FlxSprite = new FlxSprite(-750,-414).loadGraphic(Paths.image('menu/Hedgecover','clown'));
		hedgeCover.setGraphicSize(Std.int(hedgeCover.width * 0.65));
		add(hedgeCover);

		for (i in listOfButtons)
			{
				// just general compensation since pasc made this on 1920x1080 and we're on 1280x720
				i.spriteOne.setGraphicSize(Std.int(i.spriteOne.width * 0.7));
				i.spriteTwo.setGraphicSize(Std.int(i.spriteTwo.width * 0.7));
				add(i);
				add(i.spriteOne);
				add(i.spriteTwo);
			}
	

		var redLines:FlxSprite = new FlxSprite(-749,98).loadGraphic(Paths.image("menu/MenuRedLines","clown"));
		redLines.setGraphicSize(Std.int(redLines.width * 0.7));
		add(redLines);

		var logo:FlxSprite = new FlxSprite(75,-15).loadGraphic(Paths.image("menu/Mainlogo","clown"));
		add(logo);

		var menuShade:FlxSprite = new FlxSprite(-1350,-1190).loadGraphic(Paths.image("menu/Menu Shade","clown"));
		menuShade.setGraphicSize(Std.int(menuShade.width * 0.7));
		add(menuShade);

		var credits:FlxSprite = new FlxSprite(-340,585).loadGraphic(Paths.image("menu/Credits","clown"));
		credits.setGraphicSize(Std.int(credits.width * 0.65));
		add(credits);



		add(trans);
		trans.alpha = 0;

		listOfButtons[0].highlight();

		super.create();
	}

	public static function goToFreeplay()
	{
		FreeplayState.diff = curDifficulty;
		FlxG.switchState(new FreeplayState());
	}

	public static function playStory()
	{
		PlayState.storyPlaylist = ['Improbable Outset', 'Madness', 'Hellclown'];
		PlayState.isStoryMode = true;

		var diffic = "";

		switch (curDifficulty)
		{
			case 0:
				diffic = '-easy';
			case 2:
				diffic = '-hard';
		}

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson('improbable-outset' + diffic, 'improbable-outset');
		PlayState.storyWeek = 7;
		PlayState.campaignScore = 0;

		FlxG.sound.music.fadeOut();

		trans.animation.play("Close");
		trans.alpha = 1;
		var snd = new FlxSound().loadEmbedded(Paths.sound('swipe','clown'));
		snd.play();

		var once = false;

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{


					if (trans.animation.frameIndex == 10 && !once)
					{
						once = true;
						FlxG.sound.music.volume = 1;
						var snd = new FlxSound().loadEmbedded(Paths.sound('clink','clown'));
						snd.play();
					}
					if (trans.animation.frameIndex == 18)
					{
						trans.animation.pause();
						LoadingState.loadAndSwitchState(new PlayState(), true);
					}
					else
						tmr.reset(0.01);
			});

	}
	
	var selectedSmth = false;
	var selectedIndex = 0;
	var selectingDiff = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (selectedIndex + 1 < listOfButtons.length)
			{
				listOfButtons[selectedIndex].unHighlight();
				listOfButtons[selectedIndex + 1].highlight();
				selectedIndex++;
				trace('selected ' + selectedIndex);
			}
			else
				trace('CANT select ' + selectedIndex);
		}
		if (FlxG.keys.justPressed.LEFT)
		{
			if (selectedIndex > 0)
			{
				listOfButtons[selectedIndex].unHighlight();
				listOfButtons[selectedIndex - 1].highlight();
				selectedIndex--;
				trace('selected ' + selectedIndex);
			}
			else
				trace('CANT select ' + selectedIndex);
		}
		

		if (FlxG.keys.justPressed.ENTER && !selectedSmth)
		{
			selectedSmth = true;
			if (!selectingDiff)
			{
				if (listOfButtons[selectedIndex].pognt == 'clown')
					transOut = null;
				listOfButtons[selectedIndex].select();
			}
		}
	}

	override function beatHit() 
	{
		shower.animation.play('idle');
		super.beatHit();
	}
}
