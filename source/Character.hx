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
				animation.addByPrefix('idle', 'Demon Dearest Idle', 15, true);
				animation.addByPrefix('singUP', 'Demon Dearest Up', 15, false);
				animation.addByPrefix('singRIGHT', 'Demon Dearest Right', 15, false);
				animation.addByPrefix('singDOWN', 'Demon Dearest Down', 15, false);
				animation.addByPrefix('singLEFT', 'Demon Dearest Left', 15, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');

			case 'erraticpissed':
				tex = Paths.getSparrowAtlas('characters/VENsit');
				frames = tex;
				animation.addByPrefix('idle', "VENsit idle", 18, false);
				animation.addByPrefix('singUP', "VENsit up", 18, false);
				animation.addByPrefix('singDOWN', "VENsit down", 18, false);
				animation.addByPrefix('singLEFT', 'VENsit left', 18, false);
				animation.addByPrefix('singRIGHT', 'VENsit right', 18, false);
				animation.addByPrefix('singUP-alt', 'VENsit Laugh', 15, false);
				animation.addByPrefix('singDOWN-alt', 'VENsit venanim', 15, true);

				addOffset('idle');
				addOffset("singUP", 3, -2);
				addOffset("singRIGHT", -6, -4);
				addOffset("singLEFT", 6, -1);
				addOffset("singDOWN", 3, -2);
				addOffset("singUP-alt", 4, 1);
				addOffset("singDOWN-alt", 1, 0);

				playAnim('idle');

			case 'erraticspeaks':
				tex = Paths.getSparrowAtlas('characters/VENsit');
				frames = tex;

				animation.addByPrefix('idle', "VENsit venanim", 15, false);
				animation.addByPrefix('singUP', "VENsit up", 15, false);
				animation.addByPrefix('singDOWN', "VENsit down", 15, false);
				animation.addByPrefix('singLEFT', 'VENsit left', 15, false);
				animation.addByPrefix('singRIGHT', 'VENsit right', 15, false);
				animation.addByPrefix('singUP-alt', 'VENsit Laugh', 15, true);
				animation.addByPrefix('singDOWN-alt', 'VENsit venanim', 15, true);

				addOffset('idle', 4, 1);
				addOffset("singUP", 12, 5);
				addOffset("singRIGHT", 6, 12);
				addOffset("singLEFT", 28, 4);
				addOffset("singDOWN", -2, 22);
				addOffset("singUP-alt", 13, 0);
				addOffset("singDOWN-alt", 1, 0);

				playAnim('idle');

			case 'gemlighterratic':
				tex = Paths.getSparrowAtlas('characters/Gemlight Erratic');
				frames = tex;
				animation.addByPrefix('idle', "Gemlight Erratic Happyidle", 24);
				animation.addByPrefix('singUP', 'Gemlight Erratic HappyUp', 24, false);
				animation.addByPrefix('singDOWN', 'Gemlight Erratic HappyDown', 24, false);
				animation.addByPrefix('singLEFT', 'Gemlight Erratic Happyleft', 24, false);
				animation.addByPrefix('singRIGHT', 'Gemlight Erratic HappyRight', 24, false);
				animation.addByPrefix('gunsout', 'Gemlight Erratic Pullsoutthegun', 24, false);
				animation.addByPrefix('gunidle', "Gemlight Erratic GunIdle", 24);
				animation.addByPrefix('gunsingUP', 'Gemlight Erratic GunUp', 24, false);
				animation.addByPrefix('gunsingDOWN', 'Gemlight Erratic GunDown', 24, false);
				animation.addByPrefix('gunsingLEFT', 'Gemlight Erratic GunLeft', 24, false);
				animation.addByPrefix('gunsingRIGHT', 'Gemlight Erratic GunRight', 24, false);
				animation.addByPrefix('shoots', 'Gemlight Erratic Shoots', 24, false);

				addOffset('idle');
				addOffset("singUP", -3, 15);
				addOffset("singRIGHT", 0, 1);
				addOffset("singLEFT", 0, 1);
				addOffset("singDOWN", 0, -1);
				addOffset('gunsout', 1, 0);
				addOffset('gunidle');
				addOffset("gunsingUP", -3, 15);
				addOffset("gunsingRIGHT", 0, 1);
				addOffset("gunsingLEFT", 0, 1);
				addOffset("gunsingDOWN", 0, -1);
				addOffset('shoots');

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
				animation.addByPrefix('idle', "Erratic_Rain Idle", 17);
				animation.addByPrefix('singUP', 'Erratic_Rain Up', 17, false);
				animation.addByPrefix('singDOWN', 'Erratic_Rain Down', 17, false);
				animation.addByPrefix('singLEFT', 'Erratic_Rain Left', 17, false);
				animation.addByPrefix('singRIGHT', 'Erratic_Rain Right', 17, false);

				addOffset('idle');
				addOffset("singUP", 1, 7);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", -7, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');
			case 'brokenerratic':
				tex = Paths.getSparrowAtlas('characters/B-Erratic');
				frames = tex;
				animation.addByPrefix('idle', "B-Erratic Idle", 24);
				animation.addByPrefix('singUP', 'B-Erratic Up', 24, false);
				animation.addByPrefix('singDOWN', 'B-Erratic Down', 24, false);
				animation.addByPrefix('singLEFT', 'B-Erratic Left', 24, false);
				animation.addByPrefix('singRIGHT', 'B-Erratic Right', 24, false);
				animation.addByPrefix('scream', 'B-Erratic Scream', 17, false);

				addOffset('idle');
				addOffset('scream');
				addOffset("singUP", 1, 7);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", -7, 1);
				addOffset("singDOWN", 10, 0);

				playAnim('idle');

			case 'brokenerraticscream':
				tex = Paths.getSparrowAtlas('characters/B-Erratic');
				frames = tex;
				animation.addByIndices('idle', "B-Erratic Scream", [
					0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 11, 12, 13, 14, 15, 16, 11, 12, 13, 14, 15, 16, 11, 12, 13, 14, 15, 16,
				], "", 24);
				animation.addByPrefix('singUP', 'B-Erratic Up', 24, false);
				animation.addByPrefix('singDOWN', 'B-Erratic Down', 24, false);
				animation.addByPrefix('singLEFT', 'B-Erratic Left', 24, false);
				animation.addByPrefix('singRIGHT', 'B-Erratic Right', 24, false);
				animation.addByPrefix('scream', 'B-Erratic Scream', 17, false);

				addOffset('idle');
				addOffset('scream');
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
				animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);
				animation.addByPrefix('gethit', 'BF hit', 24, false);

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
				addOffset('dodge', 5, -10);
				addOffset('gethit', 14, 20);

				playAnim('idle');

				flipX = true;

			case 'bfrain':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND_Rain', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BOYFRIEND_Rain Idle', 24, false);
				animation.addByPrefix('singUP', 'BOYFRIEND_Rain Up', 24, false);
				animation.addByPrefix('singLEFT', 'BOYFRIEND_Rain Left', 24, false);
				animation.addByPrefix('singRIGHT', 'BOYFRIEND_Rain Right', 24, false);
				animation.addByPrefix('singDOWN', 'BOYFRIEND_Rain Down', 24, false);
				animation.addByPrefix('singUPmiss', 'BOYFRIEND_Rain MissUp', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BOYFRIEND_Rain MissLeft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BOYFRIEND_Rain MissRight', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BOYFRIEND_Rain MissDown', 24, false);

				animation.addByPrefix('scared', 'BOYFRIEND_Rain Scared', 24);

				addOffset('idle', -5);
				addOffset("singUP", -19, -3);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", 0, 1);
				addOffset("singDOWN");
				addOffset("singUPmiss", -19, -3);
				addOffset("singRIGHTmiss", -10);
				addOffset("singLEFTmiss", -6);
				addOffset("singDOWNmiss", -2, -1);
				addOffset('scared', -7);

				playAnim('idle');

				flipX = true;

			case 'maledictabf':
				var tex = Paths.getSparrowAtlas('characters/Maledicta BF', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Maledicta BF Idle', 24, false);
				animation.addByPrefix('singUP', 'Maledicta BF Up', 24, false);
				animation.addByPrefix('singLEFT', 'Maledicta BF Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Maledicta BF Right', 24, false);
				animation.addByPrefix('singDOWN', 'Maledicta BF Down', 24, false);
				animation.addByPrefix('singUPmiss', 'Maledicta BF MISSUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Maledicta BF MISSLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Maledicta BF MISSRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Maledicta BF MISSDOWN', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -19, -3);
				addOffset("singRIGHT", -8, 3);
				addOffset("singLEFT", 0, 1);
				addOffset("singDOWN");
				addOffset("singUPmiss", -19, -3);
				addOffset("singRIGHTmiss", -10);
				addOffset("singLEFTmiss", -6);
				addOffset("singDOWNmiss", -2, -1);

				playAnim('idle');

			case 'vencitbf':
				var tex = Paths.getSparrowAtlas('characters/Vencit BF', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Vencit BF Idle', 16, false);
				animation.addByPrefix('singUP', 'Vencit BF Up', 16, false);
				animation.addByPrefix('singLEFT', 'Vencit BF Right', 16, false);
				animation.addByPrefix('singRIGHT', 'Vencit BF Left', 16, false);
				animation.addByPrefix('singDOWN', 'Vencit BF Down', 16, false);
				animation.addByPrefix('singUPscared', 'Vencit BF SCAREDUP', 16, false);
				animation.addByPrefix('singLEFTscared', 'Vencit BF SCAREDLEFT', 16, false);
				animation.addByPrefix('singRIGHTscared', 'Vencit BF SCAREDRIGHT', 16, false);
				animation.addByPrefix('singDOWNscared', 'Vencit BF SCAREDDOWN', 16, false);
				animation.addByPrefix('singUPmiss', 'Vencit BF MISSUP', 16, false);
				animation.addByPrefix('singLEFTmiss', 'Vencit BF MISSLEFT', 16, false);
				animation.addByPrefix('singRIGHTmiss', 'Vencit BF MISSRIGHT', 16, false);
				animation.addByPrefix('singDOWNmiss', 'Vencit BF MISSDOWN', 16, false);

				animation.addByPrefix('scaredidle', 'Vencit BF SCAREDIDLE', 13, false);

				addOffset('idle', -5);
				addOffset("singUP", 5, 6);
				addOffset("singRIGHT", -4, 1);
				addOffset("singLEFT", 3, 1);
				addOffset("singDOWN", 0, 1);
				addOffset("singUPscared", -64, -19);
				addOffset("singRIGHTscared", -67, -21);
				addOffset("singLEFTscared", -66, -21);
				addOffset("singDOWNscared", -68, -17);
				addOffset("singUPmiss", -2, 6);
				addOffset("singRIGHTmiss", 10, 1);
				addOffset("singLEFTmiss", 8, 2);
				addOffset("singDOWNmiss", -11, 4);
				addOffset('scaredidle', -67, -17);

				playAnim('idle');
				setGraphicSize(Std.int(width * 1.4));
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
				animation.addByIndices('idle', 'Maledicta Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singUP', 'Maledicta Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singLEFT', 'Maledicta Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singRIGHT', 'Maledicta Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singDOWN', 'Maledicta Erratic (Death) Death', [0], "", 24, false);
				animation.addByPrefix('firstDeath', "Maledicta Erratic (Death) Death", 24, false);
				animation.addByPrefix('deathLoop', "Maledicta Erratic (Death) LOOPDEATH", 24, true);
				animation.addByPrefix('deathConfirm', "Maledicta Erratic (Death) CONFIRMDEATH", 24, false);

				addOffset('idle');
				addOffset('firstDeath');
				addOffset('deathLoop');
				addOffset('deathConfirm');

				playAnim('firstDeath');
				flipX = true;
			case 'rockstarerratic':
				var tex = Paths.getSparrowAtlas('characters/Rockstar Erratic', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Rockstar Erratic Idle', 24, true);
				animation.addByPrefix('singUP', 'Rockstar Erratic Up', 24, false);
				animation.addByPrefix('singLEFT', 'Rockstar Erratic Right', 24, false); // I fucked up, ok? I'm the dumbass who mistook right for left.
				animation.addByPrefix('singRIGHT', 'Rockstar Erratic Left', 24, false); // fuck you if you mock me, you'd never know!!!!
				animation.addByPrefix('singDOWN', 'Rockstar Erratic Down', 24, false);
				animation.addByPrefix('singUPmiss', 'Rockstar Erratic MISSUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Rockstar Erratic MISSLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Rockstar Erratic MISSRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Rockstar Erratic MISSDOWN', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", 68, 89);
				addOffset("singRIGHTmiss", -150, -9);
				addOffset("singLEFTmiss", 122, -46);
				addOffset("singDOWNmiss", 42, -123);
				setGraphicSize(Std.int(width * 0.75)); // this is a gift from BrightFyre
				playAnim('idle');
				flipX = true;

			case 'rockstardad':
				var tex = Paths.getSparrowAtlas('characters/RockstarDearest', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'RockstarDearest Idle', 24, true);
				animation.addByPrefix('singUP', 'RockstarDearest Up', 24, false);
				animation.addByPrefix('singLEFT', 'RockstarDearest Left', 24, false);
				animation.addByPrefix('singRIGHT', 'RockstarDearest Right', 24, false);
				animation.addByPrefix('singDOWN', 'RockstarDearest Down', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 8, 3);
				addOffset("singRIGHT", -28, -7);
				addOffset("singLEFT", 12, 14);
				addOffset("singDOWN", -10, 10);
				playAnim('idle');

			case 'rockstarerratic-dead':
				var tex = Paths.getSparrowAtlas('characters/Rockstar Erratic (Death)', 'shared');
				frames = tex;
				animation.addByIndices('idle', 'Rockstar Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singUP', 'Rockstar Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singLEFT', 'Rockstar Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singRIGHT', 'Rockstar Erratic (Death) Death', [0], "", 24, false);
				animation.addByIndices('singDOWN', 'Rockstar Erratic (Death) Death', [0], "", 24, false);
				animation.addByPrefix('firstDeath', "Rockstar Erratic (Death) Death", 24, false);
				animation.addByPrefix('deathLoop', "Rockstar Erratic (Death) LOOPDEATH", 24, true);
				animation.addByPrefix('deathConfirm', "Rockstar Erratic (Death) CONFIRMDEATH", 24, false);

				addOffset('idle');
				addOffset('firstDeath');
				addOffset('deathLoop');
				addOffset('deathConfirm');
				setGraphicSize(Std.int(width * 0.75)); // this is a gift from BrightFyre
				playAnim('firstDeath');
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
