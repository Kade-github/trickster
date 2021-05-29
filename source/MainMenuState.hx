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
	public static var curDifficulty:Int = 2;
	public static var trans:FlxSprite;
	public static var diffSelectedIndex = 2;

	var clownButton:TrickyButton;

	public static var instance:MainMenuState;

	public var listOfButtons:Array<TrickyButton> = 
	[
		new TrickyButton(800, 160, 'menu/Clown Mode Button', 'menu/Clown Mode Button CONFIRM', playStory,'clown'),
		new TrickyButton(1010, 165, 'menu/FreePlayButton', 'menu/FreePlayButton CONFIRM', goToFreeplay),
		new TrickyButton(925, 265, 'menu/MUSIC Button', 'menu/MUSIC button confirm', goToFreeplay),
		new TrickyButton(685, 330, 'menu/DIFFICULTY', 'menu/DIFFICULTY CONFIRM', startDiffSelect),
		new TrickyButton(975, 460, 'menu/OPTIONS Button', 'menu/OPTIONS Button CONFIRM', goToOptions)
	];

	public var listOfDiffButtons:Array<TrickyButton> = 
	[
		new TrickyButton(635,415,'menu/EASY button', 'menu/EASY button confirm', setDiff,'easy'),
		new TrickyButton(787,415,'menu/MEDIUM button', 'menu/MEDIUM Button confirm', setDiff),
		new TrickyButton(1015,415,'menu/HARD Button', 'menu/HARD button confirm', setDiff,'hard')
	];

	var listOfDiff:Array<String> = ['easy','medium','hard'];

	override function create()
	{

		instance = this;

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
		// also THIS IS BAD

		var random = FlxG.random.float(0,10000);
		show = 'bf';
		if (random >= 1000 && random <= 1999)
			show = 'tricky';
		if (random >= 3000 && random <= 3999)
			show = 'jebus';
		if (random >= 4000 && random <= 4999)
			show = 'sanford';
		if (random >= 2000 && random <= 2999)
			show = 'deimos';
		if (random >= 5000 && random <= 5999)
			show = 'hank';
		if (random >= 6000 && random <= 6999)
			show = 'auditor';
		if (random >= 7000 && random <= 7999)
			show = 'mag';
		if (random > 9800)
			show = 'sus';

		trace('random ' + random + ' im showin ' + show);

		shower = new FlxSprite(200,280);

		Conductor.changeBPM(165);


		switch(show)
		{
			case 'bf':
				shower.frames = Paths.getSparrowAtlas("menu/MenuBF/MenuBF","clown");
				shower.animation.addByPrefix('idle','BF idle menu');
				shower.flipX = true;
				FlxG.sound.playMusic(Paths.music("nexus_bf","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));
			case 'tricky':
				shower.frames = Paths.getSparrowAtlas("menu/MenuTricky/MenuTricky","clown");
				shower.animation.addByPrefix('idle','menutricky');
				shower.y -= 155;
				shower.x -= 120;
				FlxG.sound.playMusic(Paths.music("nexus_tricky","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));
			case 'sus':
				shower.frames = Paths.getSparrowAtlas("menu/Sus/Menu_ALLSUS","clown");
				shower.animation.addByPrefix('idle','AmongUsIDLE');
				shower.animation.addByPrefix('death','AMONG DEATH');
				shower.animation.addByPrefix('no','AmongUs NuhUh');
				FlxG.sound.playMusic(Paths.music("nexus_sussy","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));
			case 'jebus':
				shower.frames = Paths.getSparrowAtlas("menu/Jebus/Menu_jebus","clown");
				shower.animation.addByPrefix('idle','Jebus');
				shower.y -= 240;
				shower.x -= 145;
				FlxG.sound.playMusic(Paths.music("nexus_jebus","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));
			case 'hank':
				shower.frames = Paths.getSparrowAtlas("menu/Hank/Hank_Menu","clown");
				shower.animation.addByPrefix('idle','Hank');
				shower.y -= 240;
				shower.x -= 180;
				FlxG.sound.playMusic(Paths.music("nexus_hank","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.63));
			case 'deimos':
				shower.frames = Paths.getSparrowAtlas("menu/Deimos/Deimos_Menu","clown");
				shower.animation.addByPrefix('idle','Deimos');
				FlxG.sound.playMusic(Paths.music("nexus_other","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.68));
				shower.y -= 65;
				shower.x -= 145;
				shower.angle = -8;
			case 'auditor':
				shower.frames = Paths.getSparrowAtlas("menu/Auditor/Auditor","clown");
				shower.animation.addByPrefix('idle','Auditor');
				FlxG.sound.playMusic(Paths.music("nexus_auditor","clown"), 0);
				shower.y -= 300;
				shower.x -= 200;
				shower.setGraphicSize(Std.int(shower.width * 0.76));
			case 'mag':
				shower.frames = Paths.getSparrowAtlas("menu/Torture/Mag_Agent_Torture_Menu","clown");
				shower.animation.addByPrefix('idle','Mag Agent Torture');
				FlxG.sound.playMusic(Paths.music("nexus_other","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));
				shower.y -= 310;
				shower.x -= 500;
			case 'sanford':
				shower.frames = Paths.getSparrowAtlas("menu/Sanford/Menu_Sanford","clown");
				shower.animation.addByPrefix('idle','Sanford');
				FlxG.sound.playMusic(Paths.music("nexus_other","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));
				shower.y -= 180;
				shower.x -= 275;
		}
		
		FlxG.sound.music.fadeIn(4, 0, 0.7);

		shower.animation.play('idle');

	

		add(shower);

		var bgCover:FlxSprite = new FlxSprite(-455,-327).loadGraphic(Paths.image('menu/BGCover','clown'));
		bgCover.setGraphicSize(Std.int(bgCover.width * 0.7));
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

		var liners:FlxSprite = new FlxSprite(600, 390).loadGraphic(Paths.image("menu/Liners","clown"));
		liners.setGraphicSize(Std.int(liners.width * 0.7));
		add(liners);

		for (i in listOfDiffButtons)
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

		listOfButtons[selectedIndex].highlight(false);
		listOfDiffButtons[diffSelectedIndex].highlight(false);

		super.create();
	}

	public static function setDiff()
	{
		curDifficulty = diffSelectedIndex;
		selectingDiff = false;
		instance.listOfButtons[0].highlight();
		selectedIndex = 0;
	}

	public static function goToFreeplay()
	{
		curDifficulty = diffSelectedIndex;
		FreeplayState.diff = curDifficulty;
		trace(curDifficulty);
		FlxG.switchState(new FreeplayState());
	}

	public static function goToOptions()
	{
		FlxG.switchState(new OptionsMenu());
	}

	public static function startDiffSelect()
	{
		selectingDiff = true;
		instance.listOfButtons[selectedIndex].unHighlight();
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
	public static var selectedIndex = 0;
	public static var selectingDiff = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectingDiff)
		{
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
				{
					listOfButtons[selectedIndex].unHighlight();
					selectedIndex = 0;
					listOfButtons[selectedIndex].highlight();
					trace('selected ' + selectedIndex);
				}
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
				{
					listOfButtons[selectedIndex].unHighlight();
					listOfButtons[listOfButtons.length - 1].highlight();
					selectedIndex = listOfButtons.length - 1;
					trace('selected ' + selectedIndex);
				}
			}
			

			if (FlxG.keys.justPressed.ENTER && !selectedSmth)
			{
				selectedSmth = true;
				if (listOfButtons[selectedIndex].pognt == 'clown')
					transOut = null;
				listOfButtons[selectedIndex].select();
			}
		}
		else
		{
			if (FlxG.keys.justPressed.ESCAPE)
			{
				selectingDiff = false;
				listOfButtons[0].highlight();
				curDifficulty = diffSelectedIndex;
				selectedIndex = 0;
				selectedSmth = false;
			}

			if (FlxG.keys.justPressed.RIGHT)
				{
					if (diffSelectedIndex + 1 < listOfDiffButtons.length)
					{
						listOfDiffButtons[diffSelectedIndex].unHighlight();
						listOfDiffButtons[diffSelectedIndex + 1].highlight();
						diffSelectedIndex++;
						trace('selected ' + diffSelectedIndex);
					}
					else
						trace('CANT select ' + diffSelectedIndex);
				}
				if (FlxG.keys.justPressed.LEFT)
				{
					if (diffSelectedIndex > 0)
					{
						listOfDiffButtons[diffSelectedIndex].unHighlight();
						listOfDiffButtons[diffSelectedIndex - 1].highlight();
						diffSelectedIndex--;
						trace('selected ' + diffSelectedIndex);
					}
					else
						trace('CANT select ' + diffSelectedIndex);
				}
				
	
				if (FlxG.keys.justPressed.ENTER)
				{
					selectedSmth = false;
					listOfDiffButtons[diffSelectedIndex].select();
				}
		}
	}

	override function beatHit() 
	{
		shower.animation.play('idle');
		super.beatHit();
	}
}
