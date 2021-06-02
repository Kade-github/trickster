package;

import openfl.text.TextFormatAlign;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var slider:FlxBackdrop;
	public static var killed:Bool = false;
	var show:String = "";
	var hand:FlxSprite;
	var shower:FlxSprite;
	public static var curDifficulty:Int = 2;
	public static var trans:FlxSprite;
	public static var diffSelectedIndex = 2;

	public static var lastRoll:String = "bf";
	public static var reRoll:Bool = true;

	var clownButton:TrickyButton;

	public static var instance:MainMenuState;

	public var listOfButtons:Array<TrickyButton> = 
	[
		new TrickyButton(800, 160, 'menu/Clown Mode Button', 'menu/Clown Mode Button CONFIRM', playStory,'clown', 0, -40),
		new TrickyButton(1010, 165, 'menu/FreePlayButton', 'menu/FreePlayButton CONFIRM', goToFreeplay, "free", 0, -40),
		new TrickyButton(925, 265, 'menu/MUSIC Button', 'menu/MUSIC button confirm', goToMusic),
		new TrickyButton(685, 330, 'menu/DIFFICULTY', 'menu/DIFFICULTY CONFIRM', startDiffSelect),
		new TrickyButton(975, 460, 'menu/OPTIONS Button', 'menu/OPTIONS Button CONFIRM', goToOptions, "options", 0, 45)
	];

	public var listOfDiffButtons:Array<TrickyButton> = 
	[
		new TrickyButton(635,415,'menu/EASY button', 'menu/EASY button confirm', setDiff, 'easy'),
		new TrickyButton(787,415,'menu/MEDIUM button', 'menu/MEDIUM Button confirm', setDiff),
		new TrickyButton(1015,415,'menu/HARD Button', 'menu/HARD button confirm', setDiff, 'hard')
	];

	var listOfDiff:Array<String> = ['easy','medium','hard'];

	var tinyMan:FlxSprite;

	override function create()
	{

		instance = this;

		if (FlxG.save.data.beatenHard)
		{
			listOfButtons[1].spriteOne = new FlxSprite(listOfButtons[1].spriteOne.x,listOfButtons[1].spriteOne.y).loadGraphic(Paths.image("menu/FreePlayEX","clown"));
			listOfButtons[1].spriteTwo = new FlxSprite(listOfButtons[1].spriteTwo.x,listOfButtons[1].spriteTwo.y).loadGraphic(Paths.image("menu/FreePlayEX_Confirm","clown"));
		}

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

		

		if (reRoll)
		{
			FlxG.sound.music.stop();
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
			killed = false;
			lastRoll = show;
			trace('random ' + random + ' im showin ' + show);
		}
		else
			show = lastRoll;

		shower = new FlxSprite(200,280);


		Conductor.changeBPM(165);

		switch(show)
		{
			case 'bf':
				shower.frames = Paths.getSparrowAtlas("menu/MenuBF/MenuBF","clown");
				shower.animation.addByPrefix('idle','BF idle menu');
				shower.flipX = true;
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_bf","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));

				lines.push('THE KID IS WEAK...');

			case 'tricky':
				shower.frames = Paths.getSparrowAtlas("menu/MenuTricky/MenuTricky","clown");
				shower.animation.addByPrefix('idle','menutricky');
				shower.y -= 155;
				shower.x -= 120;
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_tricky","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));

				lines.push('MY LESSER FORM...');
			case 'sus':
				FlxG.mouse.visible = true;
				shower.frames = Paths.getSparrowAtlas("menu/Sus/Menu_ALLSUS","clown");
				shower.animation.addByPrefix('idle','AmongUsIDLE', 24);
				shower.animation.addByPrefix('death','AMONG DEATH', 24, false);
				shower.animation.addByIndices('deathPost','AMONG DEATH', [5], "", 24, false);
				shower.animation.addByPrefix('no','AmongUs NuhUh', 24, false);
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_sussy","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.76));

				shower.y += 35;

				hand = new FlxSprite(shower.x + 75,shower.y + 50).loadGraphic(Paths.image('menu/Sus/AmongHand','clown'));
				hand.setGraphicSize(Std.int(hand.width * 0.67));
				hand.antialiasing = true;
				hand.alpha = 0;

				lines.push('A DESPICABLE THING LURKS HERE');
				
			case 'jebus':
				shower.frames = Paths.getSparrowAtlas("menu/Jebus/Menu_jebus","clown");
				shower.animation.addByPrefix('idle','Jebus');
				shower.y -= 240;
				shower.x -= 145;
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_jebus","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));

				lines.push('HE CAUSED THIS');

			case 'hank':
				shower.frames = Paths.getSparrowAtlas("menu/Hank/Hank_Menu","clown");
				shower.animation.addByPrefix('idle','Hank');
				shower.y -= 240;
				shower.x -= 180;
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_hank","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.63));

				lines.push('WEAK FLESH');

			case 'deimos':
				shower.frames = Paths.getSparrowAtlas("menu/Deimos/Deimos_Menu","clown");
				shower.animation.addByPrefix('idle','Deimos');
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_deimos","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.68));
				shower.y -= 65;
				shower.x -= 145;
				shower.angle = -8;

				lines.push('ROCK UPGRADGE... INTERESTING');

			case 'auditor':
				shower.frames = Paths.getSparrowAtlas("menu/Auditor/Auditor","clown");
				shower.animation.addByPrefix('idle','Auditor');
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_auditor","clown"), 0);
				shower.y -= 300;
				shower.x -= 200;
				shower.setGraphicSize(Std.int(shower.width * 0.76));

				lines.push('I HAVE NOTHING TO SAY...');

			case 'mag':
				shower.frames = Paths.getSparrowAtlas("menu/Torture/Mag_Agent_Torture_Menu","clown");
				shower.animation.addByPrefix('idle','Mag Agent Torture');
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_torture","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));
				shower.y -= 310;
				shower.x -= 500;

				lines.push('AN ABOMINATION');

			case 'sanford':
				shower.frames = Paths.getSparrowAtlas("menu/Sanford/Menu_Sanford","clown");
				shower.animation.addByPrefix('idle','Sanford');
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music("nexus_sanford","clown"), 0);
				shower.setGraphicSize(Std.int(shower.width * 0.66));
				shower.y -= 180;
				shower.x -= 275;

				lines.push('WEAKER THEN THE OTHERS...');
		}
		
		shower.antialiasing = true;

		if (reRoll)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			reRoll = false;
		}

		if (show == 'sus' && killed)
		{
			shower.offset.set(5,10);
			shower.animation.play('deathPost');
		}
		else
			shower.animation.play('idle');

		for (i in listOfButtons)
			{
				// just general compensation since pasc made this on 1920x1080 and we're on 1280x720
				i.spriteOne.setGraphicSize(Std.int(i.spriteOne.width * 0.7));
				i.spriteTwo.setGraphicSize(Std.int(i.spriteTwo.width * 0.7));
				add(i);
				add(i.spriteOne);
				add(i.spriteTwo);
			}


		add(shower);
			

		var bgCover:FlxSprite = new FlxSprite(-455,-327).loadGraphic(Paths.image('menu/BGCover','clown'));
		bgCover.setGraphicSize(Std.int(bgCover.width * 0.7));
		bgCover.antialiasing = true;
		add(bgCover);
		
		var hedgeCover:FlxSprite = new FlxSprite(-750,-414).loadGraphic(Paths.image('menu/Hedgecover','clown'));
		hedgeCover.setGraphicSize(Std.int(hedgeCover.width * 0.65));
		hedgeCover.antialiasing = true;
		add(hedgeCover);

		var liners:FlxSprite = new FlxSprite(600, 390).loadGraphic(Paths.image("menu/Liners","clown"));
		liners.setGraphicSize(Std.int(liners.width * 0.7));
		liners.antialiasing = true;
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
		redLines.antialiasing = true;
		add(redLines);



		var logo:FlxSprite = new FlxSprite(-50,-15).loadGraphic(Paths.image("menu/Mainlogo","clown"));
		logo.antialiasing = true;
		add(logo);

		if (FlxG.save.data.beaten)
		{
			var troph:FlxSprite = new FlxSprite(875, 60).loadGraphic(Paths.image("menu/Silver_Trophy","clown"));
			if (FlxG.save.data.beatenHard)
			{


				troph = new FlxSprite(875, -20).loadGraphic(Paths.image("menu/Gold_Trophy","clown"));

				if (FlxG.save.data.beatEx)
				{
					FlxG.mouse.visible = true;
					tinyMan = new FlxSprite(980,-100);
			
					tinyMan.frames = Paths.getSparrowAtlas('menu/Fixed_Tiny_Desk_Tricky','clown');
			
					tinyMan.animation.addByPrefix('idle','Tiny Desk Tricky Idle',24);
					tinyMan.animation.addByPrefix('click','Tiny Desk Tricky Click',24, false);
					tinyMan.animation.addByPrefix('meow','Tiny Desk Tricky Meow',24, false);

					tinyMan.animation.play('idle');

					tinyMan.setGraphicSize(Std.int(tinyMan.width * 0.66));

					tinyMan.antialiasing = true;

					add(tinyMan);
				}
			}

			troph.antialiasing = true;
			troph.setGraphicSize(Std.int(troph.width * 0.8));


			add(troph);
		}

		if (show == 'sus')
			add(hand);


		var menuShade:FlxSprite = new FlxSprite(-1350,-1190).loadGraphic(Paths.image("menu/Menu Shade","clown"));
		menuShade.setGraphicSize(Std.int(menuShade.width * 0.7));
		menuShade.antialiasing = true;
		add(menuShade);

		var credits:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image("menu/CreditsOverlay","clown"));
		credits.antialiasing = true;
		add(credits);


		add(trans);
		trans.alpha = 0;

		/*switch(selectedIndex)
		{
			case 0:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 160},1,{ease: FlxEase.expoInOut});
				listOfButtons[selectedIndex].highlight(false);
			case 1:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 165},1,{ease: FlxEase.expoInOut});
				listOfButtons[selectedIndex].highlight(false);
			case 4:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 460},1,{ease: FlxEase.expoInOut});
				listOfButtons[selectedIndex].highlight(false);
		}*/

		diffSelectedIndex = curDifficulty;

		listOfDiffButtons[diffSelectedIndex].highlight(false);

		listOfButtons[selectedIndex].highlight();

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
		FlxG.mouse.visible = false;
		curDifficulty = diffSelectedIndex;
		FreeplayState.diff = curDifficulty;
		trace(curDifficulty);
		FlxG.switchState(new FreeplayState());
	}

	public static function goToMusic()
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new MusicMenu());
		}
	

	public static function goToOptions()
	{
		FlxG.mouse.visible = false;
		FlxG.switchState(new OptionsMenu());
	}

	public static function startDiffSelect()
	{
		selectingDiff = true;
		instance.listOfButtons[selectedIndex].unHighlight();
	}

	public static function playStory()
	{
		FlxG.mouse.visible = false;
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

		if (MusicMenu.Vocals != null)
			if (MusicMenu.Vocals.playing)
				MusicMenu.Vocals.stop();

		PlayState.playCutscene = true;

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


	function doTweens()
		{
			switch(selectedIndex)
			{
				case 0:
					FlxTween.tween(listOfButtons[selectedIndex],{y: 160},1,{ease: FlxEase.expoInOut});
				case 1:
					FlxTween.tween(listOfButtons[selectedIndex],{y: 165},1,{ease: FlxEase.expoInOut});
				case 4:
					FlxTween.tween(listOfButtons[selectedIndex],{y: 460},1,{ease: FlxEase.expoInOut});
			}
		}

	function doTweensReverse()
	{
		switch(selectedIndex)
		{
			case 0:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 50},1,{ease: FlxEase.expoInOut});
			case 1:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 50},1,{ease: FlxEase.expoInOut});
			case 4:
				FlxTween.tween(listOfButtons[selectedIndex],{y: 500},1,{ease: FlxEase.expoInOut});
		}
	}

	var lines:Array<String> = ['CHAOC... THE CHAOS', 'THE HALO...', 'UNFORESEEN POWER','WHY HAVE YOU REDUCDED ME TO THIS', '...', 'I HATE YOU...', 'LEAVE ME BE', "YOU'VE CAUSED ENOUGH PAIN FOR ME", 'GO AWAY'];

	function doHand()
	{
		shower.animation.play('no');

		var selected = listOfButtons[selectedIndex].spriteTwo;

		trace(selected.x);
		trace(selected.y);

		FlxTween.tween(hand, {alpha: 1, x: selected.x + 10, y: selected.y - 10}, 0.6, {ease: FlxEase.expoInOut});
	}

	function resyncVocals():Void
		{
			MusicMenu.Vocals.pause();
	
			FlxG.sound.music.play();
			MusicMenu.Vocals.time = FlxG.sound.music.time;
			MusicMenu.Vocals.play();
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MusicMenu.Vocals != null)
		{
			if (MusicMenu.Vocals.playing)
			{
				if (FlxG.sound.music.time > MusicMenu.Vocals.time + 20 || FlxG.sound.music.time < MusicMenu.Vocals.time - 20)
                    resyncVocals();
			}
		}

		if (tinyMan != null)
		{
			if (FlxG.mouse.overlaps(tinyMan) && FlxG.mouse.justPressed && tinyMan.animation.curAnim.name == 'idle')
			{
				var random = FlxG.random.int(0,50);
				if (random < 45)
				{
					tinyMan.offset.set(33,9);
					tinyMan.animation.play('click');

					var text = new FlxText(tinyMan.x - 200,tinyMan.y + 285,0,lines[FlxG.random.int(0,lines.length - 1)]);

					text.setFormat('tahoma-bold.ttf',24,FlxColor.WHITE,FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

					add(text);

					FlxTween.tween(text, {alpha: 0}, 0.7, {
						onComplete: function(tween:FlxTween)
						{
							text.destroy();
						}
					});
				}
				else
				{
					tinyMan.offset.set(5,-1);
					FlxG.sound.play(Paths.sound('Meow','clown'));
					tinyMan.animation.play('meow');
				}
			}

			if (tinyMan.animation.finished && tinyMan.animation.curAnim.name != 'idle')
			{
				tinyMan.offset.set(0,0);
				tinyMan.animation.play('idle');
			}
		}

		if (show == 'sus' && !killed && shower.animation.finished)
			shower.animation.play('idle');
		else if (show == 'sus' && FlxG.mouse.overlaps(shower) && FlxG.mouse.justPressed && !killed)
		{
			shower.offset.set(5,10);
			shower.animation.play('death');
			killed = true;
			FlxG.sound.play(Paths.sound('AmongUs-Kill','clown'));
			if (hand.alpha == 1)
				FlxTween.tween(hand, {y: FlxG.height + 20 + hand.height,angle: 125, alpha: 0}, 5, {ease: FlxEase.expoOut});
		}
		if (!selectingDiff)
		{
			if (FlxG.keys.justPressed.RIGHT)
			{
				if (show == 'sus' && !killed && hand.alpha == 1)
					FlxTween.tween(hand, {alpha: 0, x: shower.x + 60, y: shower.y + 60}, 0.6, {ease: FlxEase.expoInOut});
				if (selectedIndex + 1 < listOfButtons.length)
				{
					listOfButtons[selectedIndex].unHighlight();
					listOfButtons[selectedIndex + 1].highlight();
					//doTweensReverse();
					selectedIndex++;
					//doTweens();
					trace('selected ' + selectedIndex);
				}
				else
				{
					//doTweensReverse();
					listOfButtons[selectedIndex].unHighlight();
					selectedIndex = 0;
					//doTweens();
					listOfButtons[selectedIndex].highlight();
					trace('selected ' + selectedIndex);
				}
			}
			if (FlxG.keys.justPressed.LEFT)
			{
				if (show == 'sus' && !killed && hand.alpha == 1)
					FlxTween.tween(hand, {alpha: 0, x: shower.x + 60, y: shower.y + 60}, 0.6, {ease: FlxEase.expoInOut});
				if (selectedIndex > 0)
				{
					listOfButtons[selectedIndex].unHighlight();
					listOfButtons[selectedIndex - 1].highlight();
					//doTweensReverse();
					selectedIndex--;
					//doTweens();
					trace('selected ' + selectedIndex);
				}
				else
				{
					//doTweensReverse();
					listOfButtons[selectedIndex].unHighlight();
					listOfButtons[listOfButtons.length - 1].highlight();
					selectedIndex = listOfButtons.length - 1;
					//doTweens();
					trace('selected ' + selectedIndex);
				}
			}
			

			if (FlxG.keys.justPressed.ENTER && !selectedSmth)
			{
				if (show == 'sus' && !killed)
				{
					doHand();
					return;
				}
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
