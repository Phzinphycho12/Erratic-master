package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'vencitgf':
				tex = Paths.getSparrowAtlas('characters/gfvencit');
				frames = tex;
				animation.addByPrefix('idle', 'gf idle dance', 16, false);
				addOffset('idle');

				playAnim('idle');
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Demon Dearest', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Demon Dearest Idle', 24, true);
				animation.addByPrefix('singUP', 'Demon Dearest Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Demon Dearest Right', 24, false);
				animation.addByPrefix('singDOWN', 'Demon Dearest Down', 24, false);
				animation.addByPrefix('singLEFT', 'Demon Dearest Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');

			case 'erraticpissed':
				tex = Paths.getSparrowAtlas('characters/ErraticVencit');
				frames = tex;
				animation.addByPrefix('idle', "ErraticVencit Idle", 24, false);
				animation.addByPrefix('singUP', "ErraticVencit Up", 24, false);
				animation.addByPrefix('singDOWN', "ErraticVencit Down", 24, false);
				animation.addByPrefix('singLEFT', 'ErraticVencit Left', 24, false);
				animation.addByPrefix('singRIGHT', 'ErraticVencit Right', 24, false);
				animation.addByPrefix('singUP-alt', 'ErraticVencit Laugh', 24, false);
				animation.addByPrefix('singDOWN-alt', 'ErraticVencit NotDone', 24, true);

				addOffset('idle');
				addOffset("singUP", 12, 5);
				addOffset("singRIGHT", 6, 12);
				addOffset("singLEFT", 28, 4);
				addOffset("singDOWN", -2, 22);
				addOffset("singUP-alt", 13, 0);
				addOffset("singDOWN-alt", 1, 0);

				playAnim('idle');

			case 'erraticspeaks':
				tex = Paths.getSparrowAtlas('characters/ErraticVencit');
				frames = tex;

				animation.addByPrefix('idle', "ErraticVencit NotDone", 24, false);
				animation.addByPrefix('singUP', "ErraticVencit Up", 24, false);
				animation.addByPrefix('singDOWN', "ErraticVencit Down", 24, false);
				animation.addByPrefix('singLEFT', 'ErraticVencit Left', 24, false);
				animation.addByPrefix('singRIGHT', 'ErraticVencit Right', 24, false);
				animation.addByPrefix('singUP-alt', 'ErraticVencit Laugh', 24, true);
				animation.addByPrefix('singDOWN-alt', 'ErraticVencit NotDone', 24, true);

				addOffset('idle', 1, 0);
				addOffset("singUP", 12, 5);
				addOffset("singRIGHT", 6, 12);
				addOffset("singLEFT", 28, 4);
				addOffset("singDOWN", -2, 22);
				addOffset("singUP-alt", 13, 0);
				addOffset("singDOWN-alt", 1, 0);

				playAnim('idle');

			case 'erratic':
				tex = Paths.getSparrowAtlas('characters/Erratic');
				frames = tex;
				animation.addByPrefix('idle', "Erratic idle yuh", 17);
				animation.addByPrefix('singUP', 'Erratic up yo momma', 17, false);
				animation.addByPrefix('singDOWN', 'Erratic down lol', 17, false);
				animation.addByPrefix('singLEFT', 'Erratic left me', 17, false);
				animation.addByPrefix('singRIGHT', 'Erratic right ok cq', 17, false);

				addOffset('idle');
				addOffset("singUP", 1, 7);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", -7, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');

			case 'gooderratic':
				tex = Paths.getSparrowAtlas('characters/Erratic_Rain');
				frames = tex;
				animation.addByPrefix('idle', "Erratic idle yuh", 17);
				animation.addByPrefix('singUP', 'Erratic up yo momma', 17, false);
				animation.addByPrefix('singDOWN', 'Erratic down lol', 17, false);
				animation.addByPrefix('singLEFT', 'Erratic left me', 17, false);
				animation.addByPrefix('singRIGHT', 'Erratic right ok cq', 17, false);

				addOffset('idle');
				addOffset("singUP", 1, 7);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", -7, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');
			case 'brokenerratic':
				tex = Paths.getSparrowAtlas('characters/B-Erratic');
				frames = tex;
				animation.addByPrefix('idle', "B-Erratic idle", 24);
				animation.addByPrefix('singUP', 'B-Erratic up', 24, false);
				animation.addByPrefix('singDOWN', 'B-Erratic down', 24, false);
				animation.addByPrefix('singLEFT', 'B-Erratic left', 24, false);
				animation.addByPrefix('singRIGHT', 'B-Erratic right', 24, false);

				addOffset('idle');
				addOffset("singUP", 1, 7);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", -7, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');

			case 'erraticmad':
				tex = Paths.getSparrowAtlas('characters/CQ erratic');
				frames = tex;
				animation.addByPrefix('idle', "CQ erratic Idle", 17);
				animation.addByPrefix('singUP', 'CQ erratic Up', 17, false);
				animation.addByPrefix('singDOWN', 'CQ erratic Down', 17, false);
				animation.addByPrefix('singLEFT', 'CQ erratic Left', 17, false);
				animation.addByPrefix('singRIGHT', 'CQ erratic Right', 17, false);

				addOffset('idle');
				addOffset("singUP", 1, 2);
				addOffset("singRIGHT", -8, -4);
				addOffset("singLEFT", -5, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bfrain':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND_Rain', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'vencitbf':
				var tex = Paths.getSparrowAtlas('characters/Vencit BF', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Vencit BF Idle', 16, false);
				animation.addByPrefix('singUP', 'Vencit BF Up', 16, false);
				animation.addByPrefix('singLEFT', 'Vencit BF Left', 16, false);
				animation.addByPrefix('singRIGHT', 'Vencit BF Right', 16, false);
				animation.addByPrefix('singDOWN', 'Vencit BF Down', 16, false);
				animation.addByPrefix('singUPscared', 'Vencit BF SCAREDUP', 16, false);
				animation.addByPrefix('singLEFTscared', 'Vencit BF SCAREDLEFT', 16, false);
				animation.addByPrefix('singRIGHTscared', 'Vencit BF SCAREDRIGHT', 16, false);
				animation.addByPrefix('singDOWNscared', 'Vencit BF SCAREDDOWN', 16, false);
				animation.addByPrefix('singUPmiss', 'Vencit BF MISSUP', 16, false);
				animation.addByPrefix('singLEFTmiss', 'Vencit BF MISSLEFT', 16, false);
				animation.addByPrefix('singRIGHTmiss', 'Vencit BF MISSRIGHT', 16, false);
				animation.addByPrefix('singDOWNmiss', 'Vencit BF MISSDOWN', 16, false);

				animation.addByPrefix('firstDeath', "Vencit BF Death", 16, false);
				animation.addByPrefix('deathLoop', "Vencit BF Death LOOP", 16, true);
				animation.addByPrefix('deathConfirm', "Vencit BF Death CONFIRM", 16, false);

				animation.addByPrefix('scaredidle', 'Vencit BF SCAREDIDLE', 16);

				addOffset('idle', -5);
				addOffset("singUP", 6, 1);
				addOffset("singRIGHT", -4, 1);
				addOffset("singLEFT", 14, -1);
				addOffset("singDOWN", 0, 6);
				addOffset("singUPscared", 6, 1);
				addOffset("singRIGHTscared", -4, 1);
				addOffset("singLEFTscared", 14, -1);
				addOffset("singDOWNscared", 0, 6);
				addOffset("singUPmiss", 11, 5);
				addOffset("singRIGHTmiss", 10, 1);
				addOffset("singLEFTmiss", 12, 1);
				addOffset("singDOWNmiss", -11, 11);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scaredidle', 7, -1);

				playAnim('idle');
				setGraphicSize(Std.int(width * 0.45));
				flipX = true;

			case 'erratic_md':
				var tex = Paths.getSparrowAtlas('characters/Maledicta Erratic', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Maledicta Erratic Idle', 24, true);
				animation.addByPrefix('singUP', 'Maledicta Erratic Up', 24, false);
				animation.addByPrefix('singLEFT', 'Maledicta Erratic Right', 24, false); // I fucked up, ok? I'm the dumbass who mistook right for left.
				animation.addByPrefix('singRIGHT', 'Maledicta Erratic Left', 24, false); // fuck you if you mock me, you'd never know!!!!
				animation.addByPrefix('singDOWN', 'Maledicta Erratic Down', 24, false);
				animation.addByPrefix('singUPmiss', 'Maledicta Erratic MISSUp', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Maledicta Erratic MISSLeft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Maledicta Erratic MISSRight', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Maledicta Erratic MISSDown', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", 68, 89);
				addOffset("singRIGHTmiss", -150, -9);
				addOffset("singLEFTmiss", 122, -46);
				addOffset("singDOWNmiss", 42, -123);

				playAnim('idle');
				setGraphicSize(Std.int(width * 1.5)); // this is a gift from BrightFyre
				flipX = true;

			case 'erratic_md-dead':
				var tex = Paths.getSparrowAtlas('characters/Maledicta Erratic (Death)', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Maledicta Erratic (Death) Death', 24, false);
				animation.addByPrefix('singUP', 'Maledicta Erratic (Death) Death', 24, false);
				animation.addByPrefix('singLEFT', 'Maledicta Erratic (Death) Death', 24, false);
				animation.addByPrefix('singRIGHT', 'Maledicta Erratic (Death) Death', 24, false);
				animation.addByPrefix('singDOWN', 'Maledicta Erratic (Death) Death', 24, false);
				animation.addByPrefix('firstDeath', "Maledicta Erratic (Death) Death", 24, false);
				animation.addByPrefix('deathLoop', "Maledicta Erratic (Death) Death LOOP", 24, true);
				animation.addByPrefix('deathConfirm', "Maledicta Erratic (Death) CONFIRM Death", 24, false);

				addOffset('idle');
				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);

				playAnim('firstDeath');
				setGraphicSize(Std.int(width * 1.5)); // this is a gift from BrightFyre
				flipX = true;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 16;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
// The FitnessGram™ Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues.
// The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly, but gets faster each minute after you hear this signal.
// [beep] A single lap should be completed each time you hear this sound. [ding] Remember to run in a straight line, and run as long as possible.
// The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark, get ready, start.
