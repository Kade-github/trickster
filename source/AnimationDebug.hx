package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	public static var staticVar:AnimationDebug = null;
	var bf:Boyfriend;
	public static var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	public function new(daAnim:String = 'spooky')
	{
		super();
		staticVar = this;
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		FlxG.mouse.visible = true;

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10,20000,20000);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(PlayState.dad.x, PlayState.dad.y, daAnim, false, true);
			dad.setGraphicSize(Std.int(dad.width * 0.7));
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		if (char.otherFrames == null)
		{
			for (anim => offsets in char.animOffsets)
			{
				var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
				text.scrollFactor.set();
				text.color = FlxColor.BLUE;
				dumbTexts.add(text);

				if (pushList)
					animList.push(anim);

				daLoop++;
			}
		}

		if (char.otherFrames != null)
		{
			for (i in char.otherFrames)
			{
				i.setGraphicSize(Std.int(i.width * 0.7));
				for (anim => offsets in i.animOffsets)
				{
					var anim = "";
					if (StringTools.contains(i.curCharacter.toLowerCase(),"left"))
						anim = "singLEFT";
					if (StringTools.contains(i.curCharacter.toLowerCase(),"up"))
						anim = "singUP";
					if (StringTools.contains(i.curCharacter.toLowerCase(),"down"))
						anim = "singDOWN";
					if (StringTools.contains(i.curCharacter.toLowerCase(),"right"))
						anim = "singRIGHT";
					var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
					text.scrollFactor.set();
					text.color = FlxColor.BLUE;
					dumbTexts.add(text);
		
					if (pushList)
						animList.push(anim);
		
					daLoop++;
				}
			}
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.ONE)
			camFollow.y += 10;
		else if (FlxG.keys.pressed.TWO)
			camFollow.y -= 10;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
			switch(animList[curAnim])
			{
				case 'singLEFT':
					curAnim = 0;
				case 'singRIGHT':
					curAnim = 1;
				case 'singUP':
					curAnim = 2;
				case 'singDOWN':
					curAnim = 3;
			}
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
			switch(animList[curAnim])
			{
				case 'singLEFT':
					curAnim = 0;
				case 'singRIGHT':
					curAnim = 1;
				case 'singUP':
					curAnim = 2;
				case 'singDOWN':
					curAnim = 3;
			}
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (char.otherFrames != null)
			{
				trace(char.otherFrames[curAnim].animOffsets);
				if (upP)
					char.otherFrames[curAnim].animOffsets.get('idle')[1] += 1 * multiplier;
				if (downP)
					char.otherFrames[curAnim].animOffsets.get('idle')[1] -= 1 * multiplier;
				if (leftP)
					char.otherFrames[curAnim].animOffsets.get('idle')[0] += 1 * multiplier;
				if (rightP)
					char.otherFrames[curAnim].animOffsets.get('idle')[0] -= 1 * multiplier;
				updateTexts();
				genBoyOffsets(false);
				var anim = "";
				if (StringTools.contains(char.otherFrames[curAnim].curCharacter.toLowerCase(),"left"))
					anim = "singLEFT";
				if (StringTools.contains(char.otherFrames[curAnim].curCharacter.toLowerCase(),"up"))
					anim = "singUP";
				if (StringTools.contains(char.otherFrames[curAnim].curCharacter.toLowerCase(),"down"))
					anim = "singDOWN";
				if (StringTools.contains(char.otherFrames[curAnim].curCharacter.toLowerCase(),"right"))
					anim = "singRIGHT";
				
				char.playAnim(anim);
			}
			else
			{
				if (upP)
					char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				if (downP)
					char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				if (leftP)
					char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				if (rightP)
					char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

				updateTexts();
				genBoyOffsets(false);
				char.playAnim(animList[curAnim]);
			}

		}

		super.update(elapsed);
	}
}
