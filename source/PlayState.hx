package;

import Replay.Ana;
import Replay.Analysis;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.EnumTools;
import haxe.Exception;
import haxe.Json;
import lime.app.Application;
import lime.graphics.Image;
import lime.media.AudioContext;
import lime.media.AudioManager;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;
import openfl.ui.KeyLocation;
import openfl.ui.Keyboard;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetManifest;
import openfl.utils.AssetType;

using StringTools;

#if windows
// me when ur mom
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;
	public static var erraticRageBG:FlxSprite;
	public static var erraticRageBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;
	var floatpattern:Int = 0;
	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	var curWeek:Int = 0;
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var dad:Character;
	public static var erraticScreams:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	public static var boyfriendAssist:Character;

	public var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;

	public var health:Float = 1; // making public because sethealth doesnt work without it
	public var rage:Float = 0;

	private var combo:Int = 0;

	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;

	public var accuracy:Float = 0.00;

	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var maldictaRageBarBG:FlxSprite;
	private var maldictaRageBar:FlxBar;
	private var songPositionBar:Float = 0;
	private var theRageBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; // making these public again because i may be stupid
	public var iconP2:HealthIcon; // what could go wrong?
	public var camHUD:FlxCamera;

	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;
	public static var isCutscene:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var daSection:Int = 1;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var ragePercent:FlxText;
	var demon_r:Float = 600;
	var bottomBoppers:FlxSprite;
	var enough:FlxSound;
	var santa:FlxSprite;
	var notlight:FlxSprite;
	var notlights:FlxSprite;
	var ringmasterAudience:FlxSprite;
	var stompAudience:FlxSprite;
	var lightning:FlxSprite;
	var rain:FlxSprite;
	var damagedStage:FlxSprite;
	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;

	public var songScore:Int = 0;

	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var brazil:Int = 9999;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;

	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;

	// Per song additive offset
	public static var songOffset:Float = 0;

	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	// API stuff

	function playCutscene(name:String)
	{
		inCutscene = true;

		{
			startCountdown();
		}
		
	}

	function playEndCutscene(name:String)
	{
		inCutscene = true;

		{
			SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
			LoadingState.loadAndSwitchState(new PlayState());
		}
		
	}

	public function addObject(object:FlxBasic)
	{
		add(object);
	}

	public function removeObject(object:FlxBasic)
	{
		remove(object);
	}

	override public function create()
	{
		instance = this;

		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;

		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase)
		{
			case 'dad-battle':
				songLowercase = 'dadbattle';
			case 'philly-nice':
				songLowercase = 'philly';
		}

		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: '
			+ Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);

		// defaults if no stage was found in chart
		var stageCheck:String = 'stage';

		if (SONG.stage == null)
		{
			switch (storyWeek)
			{
				case 2:
					stageCheck = 'halloween';
				case 3:
					stageCheck = 'circus';
					// i should check if its stage (but this is when none is found in chart anyway)
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		if (!PlayStateChangeables.Optimize)
		{
			switch (stageCheck)
			{
				case 'circus':
					{
						defaultCamZoom = 0.65;
						curStage = 'circus';

						var circusbg:FlxSprite = new FlxSprite(-17.5, 50).loadGraphic(Paths.image('circus/circuswall', 'erratic'));
						circusbg.setGraphicSize(Std.int(circusbg.width * 1.5));
						add(circusbg);

						var circusseats:FlxSprite = new FlxSprite(circusbg.x, circusbg.y).loadGraphic(Paths.image('circus/circusseats', 'erratic'));
						circusseats.setGraphicSize(Std.int(circusseats.width * 1.5));
						add(circusseats);

						var audience:FlxSprite = new FlxSprite(circusseats.x, circusseats.y).loadGraphic(Paths.image('circus/Audience', 'erratic'));
						audience.setGraphicSize(Std.int(audience.width * 1.5));
						add(audience);

						var lights:FlxSprite = new FlxSprite(circusbg.x, circusbg.x).loadGraphic(Paths.image('circus/lightsdarker', 'erratic'));
						lights.setGraphicSize(Std.int(lights.width * 1.5));
						add(lights);

						var light:FlxSprite = new FlxSprite(lights.x, lights.y).loadGraphic(Paths.image('circus/thebrightnessfuckinghurts', 'erratic'));
						light.setGraphicSize(Std.int(light.width * 1.5));
						add(light);

						var floor:FlxSprite = new FlxSprite(circusbg.x, circusbg.y).loadGraphic(Paths.image('circus/circusfloor', 'erratic'));
						floor.setGraphicSize(Std.int(floor.width * 1.5));
						add(floor);
					}
				case 'disrepaircircus':
					{
						defaultCamZoom = 0.65;
						curStage = 'disrepaircircus';

						enough = new FlxSound().loadEmbedded(Paths.sound('enough', 'erratic'));

						var circusbg:FlxSprite = new FlxSprite(-17.5, 100).loadGraphic(Paths.image('circus/circuswall', 'erratic'));
						circusbg.setGraphicSize(Std.int(circusbg.width * 1.5));
						add(circusbg);

						var circusseats:FlxSprite = new FlxSprite(circusbg.x, circusbg.y).loadGraphic(Paths.image('circus/circusseats', 'erratic'));
						circusseats.setGraphicSize(Std.int(circusseats.width * 1.5));
						add(circusseats);

						stompAudience = new FlxSprite(circusseats.x - 5000, circusseats.y - 5000);
						stompAudience.frames = Paths.getSparrowAtlas('circus/Circus Crowd', 'erratic');
						stompAudience.animation.addByPrefix('stomp', 'Circus Crowd bop', true);
						stompAudience.setGraphicSize(Std.int(stompAudience.width * 1.5));
						stompAudience.animation.play('stomp');
						add(stompAudience);

						ringmasterAudience = new FlxSprite(circusseats.x, circusseats.y).loadGraphic(Paths.image('circus/Audience', 'erratic'));
						ringmasterAudience.setGraphicSize(Std.int(ringmasterAudience.width * 1.5));
						add(ringmasterAudience);

						notlights = new FlxSprite(circusbg.x, circusbg.x).loadGraphic(Paths.image('circus/lightsdarker', 'erratic'));
						notlights.setGraphicSize(Std.int(notlights.width * 1.5));
						add(notlights);

						notlight = new FlxSprite(notlights.x, notlights.y).loadGraphic(Paths.image('circus/thebrightnessfuckinghurts', 'erratic'));
						notlight.setGraphicSize(Std.int(notlights.width * 1.5));
						add(notlight);

						var lights:FlxSprite = new FlxSprite(circusbg.x, circusbg.x).loadGraphic(Paths.image('circus/lightsoff', 'erratic'));
						lights.setGraphicSize(Std.int(lights.width * 1.5));
						add(lights);

						var floor:FlxSprite = new FlxSprite(circusbg.x, circusbg.y).loadGraphic(Paths.image('circus/circusfloor', 'erratic'));
						floor.setGraphicSize(Std.int(floor.width * 1.5));
						add(floor);
					}
				case 'emptycircus':
					{
						defaultCamZoom = 0.65;
						curStage = 'emptycircus';

						rain = new FlxSprite(0, 0);
						rain.frames = Paths.getSparrowAtlas('ruined circus/rain', 'erratic');
						rain.animation.addByPrefix('idle', 'rain downpour', 17, true);
						rain.animation.play('idle');
						rain.screenCenter();
						rain.alpha = 0.5;
						add(rain);
						rain.cameras = [camHUD];

						var circusbg:FlxSprite = new FlxSprite(-17.5, 100).loadGraphic(Paths.image('ruined circus/broken stage sky', 'erratic'));
						circusbg.setGraphicSize(Std.int(circusbg.width * 1.5));
						add(circusbg);

						lightning = new FlxSprite(0, 0);
						lightning.frames = Paths.getSparrowAtlas('ruined circus/lightning', 'erratic');
						lightning.animation.addByPrefix('idle', 'lightning Idle', false);
						lightning.animation.addByPrefix('strike', 'lightning Crash', false);
						lightning.animation.play('idle');
						lightning.screenCenter();
						lightning.y -= 100;
						lightning.x -= 50;
						add(lightning);

						var circusseats:FlxSprite = new FlxSprite(circusbg.x,
							circusbg.y).loadGraphic(Paths.image('ruined circus/broken stage tent', 'erratic'));
						circusseats.setGraphicSize(Std.int(circusseats.width * 1.5));
						add(circusseats);

						damagedStage = new FlxSprite(circusbg.x, circusbg.y);
						damagedStage.frames = Paths.getSparrowAtlas('ruined circus/brokenstage', 'erratic');
						damagedStage.animation.addByPrefix('idle', 'brokenstage flickering', 15, true);
						damagedStage.animation.play('idle');
						damagedStage.setGraphicSize(Std.int(damagedStage.width * 1.5));
						add(damagedStage);
					}
				case 'stage':
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
					}
				case 'erratichell':
					{
						defaultCamZoom = 0.75;
						curStage = 'erratichell';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hell/hellscene', 'erratic'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hell/rockystage', 'erratic'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
					}
				case 'finalhell':
					{
						defaultCamZoom = 0.35;
						curStage = 'finalhell';
						var bg:FlxSprite = new FlxSprite(-3000, -750).loadGraphic(Paths.image('truehell/True Hell', 'erratic'));
						bg.setGraphicSize(Std.int(bg.width * 1.2));
						bg.scrollFactor.set(0.3, 0.3);
						bg.updateHitbox();
						bg.antialiasing = true;
						add(bg);
					}
				case 'rockstarstage':
					{
						defaultCamZoom = 0.65;
						curStage = 'rockstarstage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('rockout/2ndPersonStage', 'erratic'));
						bg.setGraphicSize(Std.int(bg.width * 1.2));
						bg.scrollFactor.set(0.3, 0.3);
						bg.updateHitbox();
						bg.antialiasing = true;
						add(bg);
					}
				default:
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
					}
			}
		}
		// defaults if no gf was found in chart
		var gfCheck:String = 'gf';

		if (SONG.gfVersion == null)
		{
			switch (storyWeek)
			{
				case 5:
					gfCheck = 'gf-christmas';
				case 6:
					gfCheck = 'gf-pixel';
			}
		}
		else
		{
			gfCheck = SONG.gfVersion;
		}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'vencitgf':
				curGf = 'vencitgf';
			case 'maledictabf':
				curGf = 'maledictabf';
			default:
				curGf = 'gf';
		}

		if (SONG.song.toLowerCase() == 'vencit')
		{
			gf = new Character(175, -200, curGf);
			gf.setGraphicSize(Std.int(gf.width * 0.3));
			gf.scrollFactor.set(0.95, 0.95);
		}
		else if (curStage == 'circus' || curStage == 'disrepaircircus')
		{
			gf = new Character(600, 200, curGf);
			gf.scrollFactor.set(0.95, 0.95);
		}
		else if (curStage == 'emptycircus')
		{
			gf = new Character(brazil, brazil, 'brokenerratic');
			gf.scrollFactor.set(0.95, 0.95);
		}
		else if (curStage == 'finalhell')
		{
			gf = new Character(1500, -120, curGf);
			gf.scrollFactor.set(0.95, 0.95);
		}
		else if (curStage == 'rockstarstage')
		{
			gf = new Character(brazil, brazil, curGf);
		}
		else
		{
			gf = new Character(400, 130, curGf);
			gf.scrollFactor.set(0.95, 0.95);
		}

		if (curStage == 'erratichell')
		{
			dad = new Character(0, 100, SONG.player2);
		}
		else if (curStage == 'finalhell')
		{
			dad = new Character(500, 100, SONG.player2);
		}
		else if (curStage == 'rockstarstage')
		{
			dad = new Character(-1200, 200, SONG.player2);
		}
		else
		{
			if (SONG.song.toLowerCase() == 'gemlighten')
			{
				dad = new Character(100, 400, SONG.player2);
			}
			else
				dad = new Character(100, 200, SONG.player2);
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		{
			switch (SONG.player2)
			{
				case 'gf':
					dad.setPosition(gf.x, gf.y);
					gf.visible = false;
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
					}

				case 'dad':
					camPos.x += 400;
				case 'erratic':
					camPos.x += 600;
					dad.y += 200;
				case 'gooderratic':
					camPos.x += 600;
					dad.y += 200;
				case 'brokenerratic':
					camPos.x += 600;
					dad.y += 200;
				case 'erraticmad':
					dad.y += 200;
				case 'erraticpissed':
					dad.width += 50;
					dad.y += 160;
					dad.x -= 100;
			}
		}

		if (curStage == 'circus' || curStage == 'disrepaircircus' || curStage == 'emptycircus')
		{
			boyfriend = new Boyfriend(1100, 550, SONG.player1);
		}
		else if (curStage == 'erratichell')
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else if (curStage == 'finalhell')
		{
			boyfriend = new Boyfriend(1700, 0, SONG.player1);
		}
		else if (curStage == 'rockstarstage')
		{
			boyfriend = new Boyfriend(-300, 200, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}

		// REPOSITIONING PER STAGE
		if (dad.curCharacter == 'dad')
		{
			FlxTween.tween(dad, {
				x: dad.x + 256 * 0.9 + Math.sin((Conductor.songPosition / 200) * (Conductor.bpm / 60) * 3.5) * 0.5,
				y: dad.y + 256 * 1.7 * Math.cos((Conductor.songPosition / 200) * (Conductor.bpm / 60) * 3.7 * Math.PI)
			}, 5, {
				type: FlxTween.PINGPONG,
				ease: FlxEase.quadInOut,
				onComplete: null,
				startDelay: 0,
				loopDelay: 0
			});
		}
		if (SONG.player1 == 'erratic_md')
		{
			FlxTween.tween(boyfriend, {
				x: boyfriend.x - 256 * 0.8 + Math.sin((Conductor.songPosition / 250) * (Conductor.bpm / 60) * 3) * 0.5,
				y: boyfriend.y - 256 * 1.3 * Math.cos((Conductor.songPosition / 250) * (Conductor.bpm / 60) * 3 * Math.PI)
			}, 4, {
				type: FlxTween.PINGPONG,
				ease: FlxEase.quadInOut,
				onComplete: null,
				startDelay: 0,
				loopDelay: 0
			});
		}
		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			add(dad);
			add(boyfriend);
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y, 0, SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);
			songName.cameras = [camHUD];
		}
		if (SONG.song.toLowerCase() == 'vencit')
		{
			erraticRageBG = new FlxSprite(-275, 10).loadGraphic(Paths.image('healthBar'));
			erraticRageBG.angle = -90;
			erraticRageBG.screenCenter(Y);
			erraticRageBG.scrollFactor.set();
			add(erraticRageBG);

			erraticRageBar = new FlxBar(erraticRageBG.x + 4, erraticRageBG.y + 4, LEFT_TO_RIGHT, Std.int(erraticRageBG.width - 8),
				Std.int(erraticRageBG.height - 8), this, 'theRageBar', 0, 155000);

			erraticRageBar.angle = -90;
			erraticRageBar.scrollFactor.set();

			erraticRageBar.createFilledBar(FlxColor.BLACK, FlxColor.RED);
			add(erraticRageBar);

			var ragePercent = new FlxText(erraticRageBG.x + (erraticRageBG.width / 2) - (SONG.song.length * 5), erraticRageBG.y + 10, 0, "R A G E", 50);
			ragePercent.angle = -90;
			ragePercent.setFormat(Paths.font("vcr.ttf"), 16, 0xFFDC143C, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			ragePercent.scrollFactor.set();
			add(ragePercent);
			ragePercent.cameras = [camHUD];
		}
		if (SONG.song.toLowerCase() == "maledicta")
		{
			maldictaRageBarBG = new FlxSprite(900, 300).loadGraphic(Paths.image('healthBar'));
			maldictaRageBarBG.angle = -90;
			maldictaRageBarBG.screenCenter(Y);
			maldictaRageBarBG.scrollFactor.set();
			add(maldictaRageBarBG);

			maldictaRageBar = new FlxBar(maldictaRageBarBG.x + 4, maldictaRageBarBG.y + 4, LEFT_TO_RIGHT, Std.int(maldictaRageBarBG.width - 8),
				Std.int(maldictaRageBarBG.height - 8), this, 'rage', 0, 5);
			maldictaRageBar.angle = -90;
			maldictaRageBar.scrollFactor.set();
			maldictaRageBar.createFilledBar(0xFF808080, 0xFFFFD700);
			add(maldictaRageBar);

			var maledictaragePercent = new FlxText(maldictaRageBarBG.x + (maldictaRageBarBG.width / 2) - (SONG.song.length * 5) - 35,
				maldictaRageBarBG.y + 150, 0, "C U R S E D   R A G E", 50);
			maledictaragePercent.angle = 90;
			maledictaragePercent.setFormat(Paths.font("vcr.ttf"), 16, 0xFFD4AF37, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			maledictaragePercent.scrollFactor.set();
			add(maledictaragePercent);
			maledictaragePercent.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (dad.curCharacter == 'erratic'
			|| dad.curCharacter == 'erraticmad'
			|| dad.curCharacter == 'brokenerratic'
			|| dad.curCharacter == 'brokenerraticscream'
			|| dad.curCharacter == 'gooderratic')
		{
			healthBar.createFilledBar(0xFFd05774, 0xFF31b0d1);
		}
		else if (dad.curCharacter == 'erraticpissed' || dad.curCharacter == 'erraticspeaks')
		{
			healthBar.createFilledBar(0xFFff4640, 0xFFff4b61);
		}
		else if (dad.curCharacter == 'dad' && SONG.player1 == 'erratic_md')
		{
			healthBar.createFilledBar(0xFFbf7cd4, 0xFFe1c099);
		}
		else if (dad.curCharacter == 'dad')
		{
			healthBar.createFilledBar(0xFFbf7cd4, 0xFF31b0d1);
		}
		else
		{
			healthBar.createFilledBar(0xFF61006a, 0xFF31b0d1);
		}
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		if (SONG.song.toLowerCase() == "maledicta")
		{
			kadeEngineWatermark = new FlxText(4, healthBarBG.y + 50, 0, SONG.song + " - " + "GRAND FINALE");
		}
		else if (SONG.song.toLowerCase() == "gemlighten")
		{
			kadeEngineWatermark = new FlxText(4, healthBarBG.y + 50, 0, SONG.song + " - " + "GEMLIGHT");
		}
		else
		{
			kadeEngineWatermark = new FlxText(4, healthBarBG.y + 50, 0, SONG.song + " - " + CoolUtil.difficultyFromInt(storyDifficulty));
		}

		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;

		scoreTxt.scrollFactor.set();

		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY",
			20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0,
			"C H E A T E R", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.RED, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if (PlayStateChangeables.botPlay && !loadRep)
			add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (curStage == ' emptycircus')
			rain.cameras = [camHUD];

		if (SONG.song.toLowerCase() == 'vencit')
		{
			erraticRageBG.cameras = [camHUD];
			erraticRageBar.cameras = [camHUD];
		}

		if (SONG.song.toLowerCase() == 'maledicta')
		{
			maldictaRageBarBG.cameras = [camHUD];
			maldictaRageBar.cameras = [camHUD];
		}

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong, " ", "-").toLowerCase())
			{
				case 'encounter':
					playCutscene('GrandOpening');
				case 'kermis':
					playCutscene('KermisCutscene');
				case 'ringmaster':
					playCutscene('AngryErratic');
				case 'vencit':
					playCutscene('VencitCutscene');
				case 'freakshow':
					playCutscene('Freakshow');
				case 'vengeance':
					playCutscene('DDincoming');
				case 'maledicta':
					playCutscene('Foes');
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

          #if android
      addVirtualPad(FULL, A_B);
      #end
		super.create();
	}

	function rageHitMiss()
	{
		if (SONG.song.toLowerCase() == 'maledicta')
		{
			rage += 1;
		}
		else
		{
			health -= 0.5;
			SONG.speed += 0.2;
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				SONG.speed -= 0.2;
			});
		}
	}

	function demonHit()
	{
		FlxG.sound.play(Paths.sound('burnSound'), 0.6);
		health -= 0.4;
	}

	function rageHit()
	{
		if (SONG.song.toLowerCase() == 'maledicta')
		{
			rage -= 0.21;
		}
		else if (SONG.song.toLowerCase() == 'sentimental')
		{
			health += 0.25;
		}
		else if (SONG.song.toLowerCase() == 'gemlighten')
		{
			FlxG.sound.play(Paths.sound('gunshot'), 1.5);
		}
		else
		{
			SONG.speed += 0.15;
			new FlxTimer().start(2.5, function(tmr:FlxTimer)
			{
				SONG.speed -= 0.15;
			});
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		if (dialogueBox != null)
		{
			inCutscene = true;

			add(dialogueBox);
		}
		else
			startCountdown();
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		#if android	 
androidc.visible = true;
#end

		SONG.noteStyle = ChartingState.defaultnoteStyle;

		var doesitTween:Bool = if (SONG.song.toLowerCase() == "vencit") true else false;

		inCutscene = false;

		generateStaticArrows(0, doesitTween);
		generateStaticArrows(1, doesitTween);

		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase)
		{
			case 'dad-battle':
				songLowercase = 'dadbattle';
			case 'philly-nice':
				songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start', [songLowercase]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (SONG.song.toLowerCase() == 'gemlighten')
			{
				if (curStep <= 295)
					dad.playAnim('idle');
				else if (curStep > 295 && curStep <= 336)
					dad.playAnim('gunsout', true);
				else if (curStep > 336)
					dad.playAnim('gunidle');
			}
			else
				dad.dance();
			gf.dance();
			if (SONG.song.toLowerCase() == 'vencit' && curStep >= 567 && SONG.player1 == 'vencitbf')
			{
				boyfriend.playAnim('scaredidle');
			}
			else
			{
				boyfriend.playAnim('idle');
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	private function handleInput(evt:KeyboardEvent):Void
	{ // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));

		var binds:Array<String> = [
			FlxG.save.data.leftBind,
			FlxG.save.data.downBind,
			FlxG.save.data.upBind,
			FlxG.save.data.rightBind
		];

		var data = -1;

		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (evt.keyLocation == KeyLocation.NUM_PAD)
		{
			trace(String.fromCharCode(evt.charCode) + " " + key);
		}

		if (data == -1)
			return;

		var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit

		dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note

		if (dataNotes.length != 0)
		{
			var coolNote = dataNotes[0];

			goodNoteHit(coolNote);
			var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			ana.hit = true;
			ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
		}
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x
				+ 4, songPosBG.y
				+ 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength
				- 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y, 0, SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		// Song check real quick
		switch (curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog':
				allowedToHeadbang = true;
			default:
				allowedToHeadbang = false;
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase)
		{
			case 'dad-battle':
				songLowercase = 'dadbattle';
			case 'philly-nice':
				songLowercase = 'philly';
		}

		var songPath = 'assets/data/' + songLowercase + '/';

		for (file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if (!sys.FileSystem.isDirectory(path))
			{
				if (path.endsWith('.offset'))
				{
					trace('Found offset file: ' + path);
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					break;
				}
				else
				{
					trace('Offset file not found. Creating one @: ' + songPath);
					sys.io.File.saveContent(songPath + songOffset + '.offset', '');
				}
			}
		}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			if (daSection == 180 && curSong.toLowerCase() == 'vencit')
				SONG.noteStyle = 'shattered';

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				// 1. Basically if it's the 50th, section, it changes the skin

				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];

				// 2. I added a new parameter: daSkin which basically make the notes specific skins
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];

				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			// 3. Make sure to change the section number so i can do if's
			daSection += 1;
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function removeStatics()
	{
		playerStrums.forEach(function(todel:FlxSprite)
		{
			playerStrums.remove(todel);
			todel.destroy();
		});
		cpuStrums.forEach(function(todel:FlxSprite)
		{
			cpuStrums.remove(todel);
			todel.destroy();
		});
		strumLineNotes.forEach(function(todel:FlxSprite)
		{
			strumLineNotes.remove(todel);
			todel.destroy();
		});
	}

	private function generateStaticArrows(player:Int, tweened:Bool):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			// defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';

			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null)
			{
				switch (storyWeek)
				{
					case 6:
						noteTypeCheck = 'pixel';
				}
			}
			else
			{
				noteTypeCheck = SONG.noteStyle;
			}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}
				case 'shattered':
					babyArrow.frames = Paths.getSparrowAtlas('crackedarrows/NOTE_assets', 'erratic');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
					}
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 270;

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); // CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"Acc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					songLength
					- Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
		if (SONG.song.toLowerCase() == 'vencit')
		{
			strumLineNotes.forEach(function(babyArrow:FlxSprite)
			{
				babyArrow.alpha = 0.8 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2) * 0.4;
			});
		}
		#if !debug
		perfectMode = false;
		#end

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos', Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom', FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle', 'float');

			if (luaModchart.getVar("showOnlyStrums", 'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible", 'bool');
			var p2 = luaModchart.getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}
		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length - 1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				if (SONG.song.toLowerCase() == 'vencit' && SONG.player1 == 'vencitbf' && curStep >= 567)
				{
					iconP1.animation.play('vencitbfdrained');
				}
				else
				{
					iconP1.animation.play(SONG.player1);
				}
			else
				iconP1.animation.play('bf-old');
		}

		if (SONG.song.toLowerCase() == 'vencit' && SONG.player1 == 'vencitbf' && curStep == 567)
		{
			iconP1.animation.play('vencitbfdrained');
		}

		if (dad.curCharacter == 'brokenerratic')
		{
			iconP2.animation.play('brokenerratic2');
		}

		if (dad.curCharacter == 'gemlighterratic' && SONG.song.toLowerCase() == 'gemlighten' && curStep == 336)
		{
			iconP2.animation.play('gemlighterraticangry');
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		if (SONG.song.toLowerCase() == "vencit")
			if (health > 2)
				health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else if (healthBar.percent < 20 && dad.curCharacter == 'gooderratic' || healthBar.percent > 20 && dad.curCharacter == 'brokenerratic')
			iconP2.animation.curAnim.curFrame = 2;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
				{
					FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;
			theRageBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if (allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if (gf.animation.curAnim.name == 'danceLeft'
					|| gf.animation.curAnim.name == 'danceRight'
					|| gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch (curSong)
					{
						case 'Philly Nice':
							{
								// General duration of the song
								if (curBeat < 250)
								{
									// Beats to skip or to stop GF from cheering
									if (curBeat != 184 && curBeat != 216)
									{
										if (curBeat % 16 == 8)
										{
											// Just a garantee that it'll trigger just once
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Bopeebo':
							{
								// Where it starts || where it ends
								if (curBeat > 5 && curBeat < 130)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
						case 'Blammed':
							{
								if (curBeat > 30 && curBeat < 190)
								{
									if (curBeat < 90 || curBeat > 128)
									{
										if (curBeat % 4 == 2)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Cocoa':
							{
								if (curBeat < 170)
								{
									if (curBeat < 65 || curBeat > 130 && curBeat < 145)
									{
										if (curBeat % 16 == 15)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Eggnog':
							{
								if (curBeat > 10 && curBeat != 111 && curBeat < 220)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
					}
				}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit", PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'erraticpissed':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 || rage >= 5)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"\nAcc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		if (rage < 0)
			rage = 0;

		if (FlxG.save.data.resetButton)
		{
			if (FlxG.keys.justPressed.R)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if windows
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("GAME OVER -- "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC);
				#end

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.modifiedByLua)
				{
					if (PlayStateChangeables.useDownscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2));
						if (daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (!PlayStateChangeables.botPlay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2));
						if (daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							if (!PlayStateChangeables.botPlay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					if (SONG.song.toLowerCase() == 'gemlighten' && curStep >= 295)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('gunsingUP' + altAnim, true);
							case 3:
								dad.playAnim('gunsingRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('gunsingDOWN' + altAnim, true);
							case 0:
								dad.playAnim('gunsingLEFT' + altAnim, true);
						}
					}
					else
					{
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
					}
					if (FlxG.save.data.cpuStrums)
					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
					#end

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress && !daNote.modifiedByLua)
				{
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}
				else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
				{
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}

				if (daNote.isSustainNote)
					daNote.x += daNote.width / 2 + 17;

				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var maledicta = SONG.song.toLowerCase() == 'maledicta' || SONG.song.toLowerCase() == 'sentimental';
				if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate
					&& PlayStateChangeables.useDownscroll)
					&& daNote.mustPress)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
					}
					else
					{
						if (daNote.noteType == 3)
						{
							health -= 0.0;
						}
						if (daNote.noteType == 2)
						{
							if (storyDifficulty == 3 && !maledicta)
							{
								health -= 9999;
							}
							else
							{
								noteMiss(daNote.noteData, daNote);
								rageHitMiss();
								vocals.volume = 0;
							}
						}
						if (daNote.noteType == 1 || daNote.noteType == 0)
						{
							if (storyDifficulty == 3 && !maledicta)
							{
								health -= 0.15;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
						}
					}

					daNote.visible = false;
					daNote.kill();
					notes.remove(daNote, true);
				}
			});
		}
		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		if (SONG.song.toLowerCase() == 'sentimental')
		{
			camFollow.setPosition(-100, 600);
		}
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore)
			{
				case 'Dad-Battle':
					songHighscore = 'Dadbattle';
				case 'Philly-Nice':
					songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);
				if (storyPlaylist.length <= 1 && storyDifficulty <= 1 && storyWeek == 0 && !FlxG.save.data.cutscenes)
				{
					playEndCutscene('TooBadCutscene');
				}
				else if (storyPlaylist.length <= 0)
				{
					paused = true;

					FlxG.sound.music.stop();
					if (storyWeek == 0 && !FlxG.save.data.cutscenes)
					{
						playEndCutscene('Erratic Spares BF');
						FlxG.save.data.weekcompleted = true;
					}
					else if (storyWeek == 1 && !FlxG.save.data.cutscenes)
					{
						playEndCutscene('GrandFinale');
						FlxG.save.data.week2completed = true;
					}
					else if (storyWeek == 0 && FlxG.save.data.cutscenes)
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new MainMenuState());
						FlxG.save.data.weekcompleted = true;
					}
					else if (storyWeek == 1 && FlxG.save.data.cutscenes)
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new MainMenuState());
						FlxG.save.data.week2completed = true;
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new MainMenuState());
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{ #if newgrounds
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
						#end
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat)
					{
						case 'Dad-Battle':
							songFormat = 'Dadbattle';
						case 'Philly-Nice':
							songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);

					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState(), true);
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;

				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
					openSubState(new ResultsScreen());
				else
					FlxG.switchState(new FreeplayState());
			}
		}
	}

	var endingSong:Bool = false;
	var hits:Array<Float> = [];
	var offsetTest:Float = 0;
	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
		var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;
		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		coolText.cameras = [camHUD];
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;

		if (FlxG.save.data.accuracyMod == 1)
			totalNotesHit += wife;
		var maledicta = SONG.song.toLowerCase() == 'maledicta' || SONG.song.toLowerCase() == 'vencit';
		var daRating = daNote.rating;

		switch (daRating)
		{
			case 'shit':
				if (daNote.noteType == 3)
				{
					demonHit();
					if (health < 2)
						health -= 0.0;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0;
				}
				if (daNote.noteType == 2)
				{
					if (storyDifficulty == 3)
					{
						score = -1000;
						combo = 0;
						health -= 0.5;
						rageHit();
					}
					else
					{
						score = -1000;
						combo = 0;
						health -= 0.2;
						rageHit();
					}
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (storyDifficulty == 3 && !maledicta)
					{
						score = -1000;
						combo = 0;
						misses++;
						health -= 0.4;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					}
					else
					{
						score = -300;
						combo = 0;
						misses++;
						health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					}
				}
			case 'bad':
				if (daNote.noteType == 3)
				{
					demonHit();
					if (health < 2)
						health -= 0.0;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0;
				}
				if (daNote.noteType == 2)
				{
					if (storyDifficulty == 3)
					{
						health -= 0.12;
						rageHit();
					}
					else
					{
						health -= 0.06;
						rageHit();
					}
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (storyDifficulty == 3 && !maledicta)
					{
						daRating = 'bad';
						score = -250;
						health -= 0.2;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
					else
					{
						daRating = 'bad';
						score = 0;
						health -= 0.06;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
				}
			case 'good':
				if (daNote.noteType == 3)
				{
					demonHit();
					if (health < 2)
						health -= 0.0;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0;
				}
				if (daNote.noteType == 2)
				{
					if (storyDifficulty == 3)
					{
						daRating = 'good';
						score = 1000;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.015;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
						rageHit();
					}
					else
					{
						daRating = 'good';
						score = 500;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
						rageHit();
					}
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (storyDifficulty == 3 && !maledicta)
					{
						daRating = 'good';
						score = 400;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.015;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
					else
					{
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
				}
			case 'sick':
				if (daNote.noteType == 3)
				{
					demonHit();
					if (health < 2)
						health -= 0.0;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0;
				}
				if (daNote.noteType == 2)
				{
					if (storyDifficulty == 3)
					{
						if (health < 2)
							health += 0.05;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
						rageHit();
					}
					else
					{
						if (health < 2)
							health += 0.1;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
						rageHit();
					}
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (storyDifficulty == 3 && !maledicta)
					{
						if (health < 2)
							health += 0.05;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
					}
					else
					{
						if (health < 2)
							health += 0.1;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
					}
				}
		}

		// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if (PlayStateChangeables.botPlay && !loadRep)
				msTiming = 0;

			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0, 0, 0, "0ms");
			timeShown = 0;
			switch (daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				// Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for (i in hits)
					total += i;

				offsetTest = HelperFunctions.truncateFloat(total / hits.length, 2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if (!PlayStateChangeables.botPlay || loadRep)
				add(currentTimingShown);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if (!PlayStateChangeables.botPlay || loadRep)
				add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();

			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		#if windows
		if (luaModchart != null)
		{
			if (controls.LEFT_P)
			{
				luaModchart.executeState('keyPressed', ["left"]);
			};
			if (controls.DOWN_P)
			{
				luaModchart.executeState('keyPressed', ["down"]);
			};
			if (controls.UP_P)
			{
				luaModchart.executeState('keyPressed', ["up"]);
			};
			if (controls.RIGHT_P)
			{
				luaModchart.executeState('keyPressed', ["right"]);
			};
		};
		#end

		// Prevent player input if botplay is on
		if (PlayStateChangeables.botPlay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}

		var anas:Array<Ana> = [null, null, null, null];

		for (i in 0...pressArray.length)
			if (pressArray[i])
				anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
		{
			// PRESSES, check for note hits
			if (pressArray.contains(true) && generatedMusic)
			{
				boyfriend.holdTimer = 0;

				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				var directionsAccounted:Array<Bool> = [false, false, false, false]; // we don't want to do judgments for more than one presses

				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
					{
						if (directionList.contains(daNote.noteData))
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});

				for (note in dumbNotes)
				{
					FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}

				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				if (perfectMode)
					goodNoteHit(possibleNotes[0]);
				else if (possibleNotes.length > 0)
				{
					if (!FlxG.save.data.ghost)
					{
						for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								noteMiss(shit, null);
						}
					}
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData])
						{
							if (mashViolations != 0)
								mashViolations--;
							scoreTxt.color = FlxColor.WHITE;
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							anas[coolNote.noteData].hit = true;
							anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
							anas[coolNote.noteData].nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];

							goodNoteHit(coolNote);
						}
					}
				}
				else if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit, null);
				}
			}

			if (!loadRep)
				for (i in anas)
					if (i != null)
						replayAna.anaArray.push(i); // put em all there
		}
		notes.forEachAlive(function(daNote:Note)
		{
			if (PlayStateChangeables.useDownscroll && daNote.y > strumLine.y || !PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if (PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress || PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
				{
					if (loadRep)
					{
						// trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
						var n = findByTime(daNote.strumTime);
						trace(n);
						if (n != null)
						{
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
					}
					else
					{
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing')
				&& !boyfriend.animation.curAnim.name.endsWith('miss')
				&& PlayState.SONG.song.toLowerCase() == 'vencit'
				&& curStep >= 567
				&& SONG.player1 == 'vencitbf')
			{
				boyfriend.playAnim('scaredidle');
			}
			else if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	public function findByTime(time:Float):Array<Dynamic>
	{
		for (i in rep.replay.songNotes)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (i[0] == time)
				return i;
		}
		return null;
	}

	public function findByTimeIndex(time:Float):Int
	{
		for (i in 0...rep.replay.songNotes.length)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (rep.replay.songNotes[i][0] == time)
				return i;
		}
		return -1;
	}

	public var fuckingVolume:Float = 1;
	public var useVideo = false;

	public var playingDathing = false;
	public var videoSprite:FlxSprite;

	public function focusOut()
	{
		if (paused)
			return;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}

		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}

	public function focusIn()
	{
		// nada
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([
						daNote.strumTime,
						0,
						direction,
						166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}
			}
			else if (!loadRep)
			{
				saveNotes.push([
					Conductor.songPosition,
					0,
					direction,
					166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
				]);
				saveJudge.push("miss");
			}

			// var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			// var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			function ErraticMiss()
			{
				switch (direction)
				{
					case 0:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singLEFTmiss', true);
						}

					case 1:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singDOWNmiss', true);
						}

					case 2:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singUPmiss', true);
						}

					case 3:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singRIGHTmiss', true);
						}
				}
			}

			function BoyfriendMiss()
			{
				switch (direction)
				{
					case 0:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							gf.playAnim('singLEFTmiss', true);
						}

					case 1:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							gf.playAnim('singDOWNmiss', true);
						}

					case 2:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							gf.playAnim('singUPmiss', true);
						}

					case 3:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							gf.playAnim('singRIGHTmiss', true);
						}
				}
			}

			function DuetMiss()
			{
				switch (direction)
				{
					case 0:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singLEFTmiss', true);
							gf.playAnim('singLEFTmiss', true);
						}

					case 1:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singDOWNmiss', true);
							gf.playAnim('singDOWNmiss', true);
						}

					case 2:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singUPmiss', true);
							gf.playAnim('singUPmiss', true);
						}

					case 3:
						if (daNote.noteType == 3)
						{
							trace("uglyyybiatch");
						}
						else
						{
							boyfriend.playAnim('singRIGHTmiss', true);
							gf.playAnim('singRIGHTmiss', true);
						}
				}
			}

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			if (daNote.noteType == 3)
			{
				trace("uglyyybiatch");
			}
			else
			{
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			}

			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			switch (SONG.song.toLowerCase())
			{
				case 'maledicta':
					if (curStep <= 447 || curStep >= 666 && curStep <= 767 || curStep >= 832 && curStep <= 911 || curStep >= 935 && curStep <= 943
						|| curStep >= 960 && curStep <= 1151 || curStep >= 1216 && curStep <= 1311 || curStep >= 1471 && curStep <= 1568 || curStep >= 1631
						&& curStep <= 1696 || curStep >= 2496 && curStep <= 2560 || curStep >= 3183 && curStep <= 3216 || curStep >= 3248 && curStep <= 3280)
					{
						ErraticMiss();
					}
					else if (curStep >= 447 && curStep <= 480 || curStep >= 767 && curStep <= 832 || curStep >= 911 && curStep <= 935 || curStep >= 1151
						&& curStep <= 1216 || curStep >= 1311 && curStep <= 1408 || curStep >= 1568 && curStep <= 1631 || curStep >= 3216 && curStep <= 3248
						|| curStep >= 3280 && curStep <= 3312)
					{
						BoyfriendMiss();
					}
					else if (curStep >= 480 && curStep <= 666 || curStep >= 943 && curStep <= 960 || curStep >= 1696 && curStep <= 2496 || curStep >= 2560
						&& curStep <= 3183 || curStep >= 3312 && curStep <= 4000)
					{
						DuetMiss();
					}
					else if (curStep >= 1407 && curStep <= 1440)
					{
						switch (direction)
						{
							case 0:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singLEFTmiss', true);
									gf.playAnim('singUPmiss', true);
								}

							case 1:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singDOWNmiss', true);
									gf.playAnim('singUPmiss', true);
								}

							case 2:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singUPmiss', true);
									gf.playAnim('singUPmiss', true);
								}

							case 3:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singRIGHTmiss', true);
									gf.playAnim('singUPmiss', true);
								}
						}
					}
					else if (curStep >= 1440 && curStep <= 1471)
					{
						switch (direction)
						{
							case 0:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singLEFTmiss', true);
									gf.playAnim('singDOWNmiss', true);
									FlxG.camera.shake(0.025);
								}

							case 1:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singDOWNmiss', true);
									gf.playAnim('singDOWNmiss', true);
									FlxG.camera.shake(0.025);
								}

							case 2:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singUPmiss', true);
									gf.playAnim('singDOWNmiss', true);
									FlxG.camera.shake(0.025);
								}

							case 3:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singRIGHTmiss', true);
									gf.playAnim('singDOWNmiss', true);
									FlxG.camera.shake(0.025);
								}
						}
					}
					else
						switch (direction)
						{
							case 0:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singLEFTmiss', true);
								}

							case 1:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singDOWNmiss', true);
								}

							case 2:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singUPmiss', true);
								}

							case 3:
								if (daNote.noteType == 3)
								{
									trace("uglyyybiatch");
								}
								else
								{
									boyfriend.playAnim('singRIGHTmiss', true);
								}
						}
				case 'gemlighten':
					switch (direction)
					{
						case 0:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else if (daNote.noteType == 2)
							{
								boyfriend.playAnim('gethit', true);
								dad.playAnim('shoots', true);
							}
							else
							{
								boyfriend.playAnim('singLEFTmiss', true);
							}

						case 1:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else if (daNote.noteType == 2)
							{
								boyfriend.playAnim('gethit', true);
								dad.playAnim('shoots', true);
							}
							else
							{
								boyfriend.playAnim('singDOWNmiss', true);
							}

						case 2:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else if (daNote.noteType == 2)
							{
								boyfriend.playAnim('gethit', true);
								dad.playAnim('shoots', true);
							}
							else
							{
								boyfriend.playAnim('singUPmiss', true);
							}

						case 3:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else if (daNote.noteType == 2)
							{
								boyfriend.playAnim('gethit', true);
								dad.playAnim('shoots', true);
							}
							else
							{
								boyfriend.playAnim('singRIGHTmiss', true);
							}
					}
				default:
					switch (direction)
					{
						case 0:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else
							{
								boyfriend.playAnim('singLEFTmiss', true);
							}

						case 1:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else
							{
								boyfriend.playAnim('singDOWNmiss', true);
							}

						case 2:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else
							{
								boyfriend.playAnim('singUPmiss', true);
							}

						case 3:
							if (daNote.noteType == 3)
							{
								trace("uglyyybiatch");
							}
							else
							{
								boyfriend.playAnim('singRIGHTmiss', true);
							}
					}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;

			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	 */
	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;
	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
	{
		var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
		}*/

		if (controlArray[note.noteData])
		{
			goodNoteHit(note, (mashing > getKeyPresses(note)));

			/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false); */
		}
	}

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (mashing != 0)
			mashing = 0;

		var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

		if (loadRep)
		{
			noteDiff = findByTime(note.strumTime)[3];
			note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
		}
		else
			note.rating = Ratings.CalculateRating(noteDiff);

		if (note.rating == "miss")
			return;

		// add newest note to front of notesHitArray
		// the oldest notes are at the end and are removed first
		if (!note.isSustainNote)
			notesHitArray.unshift(Date.now());

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		function ErraticSings()
		{
			switch (note.noteData)
			{
				case 2:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singUPmiss', true);
					}
					else
					{
						boyfriend.playAnim('singUP', true);
						FlxG.camera.shake(0.025);
					}

				case 3:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singRIGHTmiss', true);
					}
					else
					{
						boyfriend.playAnim('singRIGHT', true);
						FlxG.camera.shake(0.025);
					}
				case 1:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singDOWNmiss', true);
					}
					else
					{
						boyfriend.playAnim('singDOWN', true);
						FlxG.camera.shake(0.025);
					}
				case 0:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singLEFTmiss', true);
					}
					else
					{
						boyfriend.playAnim('singLEFT', true);
						FlxG.camera.shake(0.025);
					}
			}
		}

		function BoyfriendSings()
		{
			switch (note.noteData)
			{
				case 2:
					if (note.noteType == 3)
					{
						gf.playAnim('singUPmiss', true);
					}
					else
					{
						gf.playAnim('singUP', true);
					}

				case 3:
					if (note.noteType == 3)
					{
						gf.playAnim('singRIGHTmiss', true);
					}
					else
					{
						gf.playAnim('singRIGHT', true);
					}
				case 1:
					if (note.noteType == 3)
					{
						gf.playAnim('singDOWNmiss', true);
					}
					else
					{
						gf.playAnim('singDOWN', true);
					}
				case 0:
					if (note.noteType == 3)
					{
						gf.playAnim('singLEFTmiss', true);
					}
					else
					{
						gf.playAnim('singLEFT', true);
					}
			}
		}

		function Duet()
		{
			switch (note.noteData)
			{
				case 2:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singUPmiss', true);
						gf.playAnim('singUPmiss', true);
					}
					else
					{
						boyfriend.playAnim('singUP', true);
						gf.playAnim('singUP', true);
						FlxG.camera.shake(0.025);
					}

				case 3:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singRIGHTmiss', true);
						gf.playAnim('singRIGHTmiss', true);
					}
					else
					{
						boyfriend.playAnim('singRIGHT', true);
						gf.playAnim('singRIGHT', true);
						FlxG.camera.shake(0.025);
					}
				case 1:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singDOWNmiss', true);
						gf.playAnim('singDOWNmiss', true);
					}
					else
					{
						boyfriend.playAnim('singDOWN', true);
						gf.playAnim('singDOWN', true);
						FlxG.camera.shake(0.025);
					}
				case 0:
					if (note.noteType == 3)
					{
						boyfriend.playAnim('singLEFTmiss', true);
						gf.playAnim('singLEFTmiss', true);
					}
					else
					{
						boyfriend.playAnim('singLEFT', true);
						gf.playAnim('singLEFT', true);
						FlxG.camera.shake(0.025);
					}
			}
		}

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
			}
			else
				totalNotesHit += 1;

			switch (SONG.song.toLowerCase())
			{
				case 'vencit':
					switch (note.noteData)
					{
						case 2:
							if (curStep >= 567 && SONG.player1 == 'vencitbf')
							{
								boyfriend.playAnim('singUPscared', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singUPmiss', true);
							}
							else
							{
								boyfriend.playAnim('singUP', true);
							}

						case 3:
							if (curStep >= 567 && SONG.player1 == 'vencitbf')
							{
								boyfriend.playAnim('singRIGHTscared', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singRIGHTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singRIGHT', true);
							}
						case 1:
							if (curStep >= 567 && SONG.player1 == 'vencitbf')
							{
								boyfriend.playAnim('singDOWNscared', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singDOWNmiss', true);
							}
							else
							{
								boyfriend.playAnim('singDOWN', true);
							}
						case 0:
							if (curStep >= 567 && SONG.player1 == 'vencitbf')
							{
								boyfriend.playAnim('singLEFTscared', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singLEFTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singLEFT', true);
							}
					}
				case 'maledicta':
					if (curStep <= 447 || curStep >= 666 && curStep <= 767 || curStep >= 832 && curStep <= 911 || curStep >= 935 && curStep <= 943
						|| curStep >= 960 && curStep <= 1151 || curStep >= 1216 && curStep <= 1311 || curStep >= 1471 && curStep <= 1568 || curStep >= 1631
						&& curStep <= 1696 || curStep >= 2496 && curStep <= 2560 || curStep >= 3183 && curStep <= 3216 || curStep >= 3248 && curStep <= 3280)
					{
						ErraticSings();
					}
					else if (curStep >= 447 && curStep <= 480 || curStep >= 767 && curStep <= 832 || curStep >= 911 && curStep <= 935 || curStep >= 1151
						&& curStep <= 1216 || curStep >= 1311 && curStep <= 1406 || curStep >= 1568 && curStep <= 1631 || curStep >= 3216 && curStep <= 3248
						|| curStep >= 3280 && curStep <= 3312)
					{
						BoyfriendSings();
					}
					else if (curStep >= 480 && curStep <= 666 || curStep >= 943 && curStep <= 960 || curStep >= 1696 && curStep <= 2496 || curStep >= 2560
						&& curStep <= 3183 || curStep >= 3312 && curStep <= 4000)
					{
						Duet();
					}
					else if (curStep >= 1407 && curStep <= 1440)
					{
						switch (note.noteData)
						{
							case 2:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singUPmiss', true);
									gf.playAnim('singUPmiss', true);
								}
								else
								{
									boyfriend.playAnim('singUP', true);
									gf.playAnim('singUP', true);
									FlxG.camera.shake(0.025);
								}

							case 3:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singRIGHTmiss', true);
									gf.playAnim('singUPmiss', true);
								}
								else
								{
									boyfriend.playAnim('singRIGHT', true);
									gf.playAnim('singUP', true);
									FlxG.camera.shake(0.025);
								}
							case 1:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singDOWNmiss', true);
									gf.playAnim('singUPmiss', true);
								}
								else
								{
									boyfriend.playAnim('singDOWN', true);
									gf.playAnim('singUP', true);
									FlxG.camera.shake(0.025);
								}
							case 0:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singLEFTmiss', true);
									gf.playAnim('singUPmiss', true);
								}
								else
								{
									boyfriend.playAnim('singLEFT', true);
									gf.playAnim('singUP', true);
									FlxG.camera.shake(0.025);
								}
						}
					}
					else if (curStep >= 1440 && curStep <= 1471)
					{
						switch (note.noteData)
						{
							case 2:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singUPmiss', true);
									gf.playAnim('singDOWNmiss', true);
								}
								else
								{
									boyfriend.playAnim('singUP', true);
									gf.playAnim('singDOWN', true);
									FlxG.camera.shake(0.025);
								}

							case 3:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singRIGHTmiss', true);
									gf.playAnim('singDOWNmiss', true);
								}
								else
								{
									boyfriend.playAnim('singRIGHT', true);
									gf.playAnim('singDOWN', true);
									FlxG.camera.shake(0.025);
								}
							case 1:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singDOWNmiss', true);
									gf.playAnim('singDOWNmiss', true);
								}
								else
								{
									boyfriend.playAnim('singDOWN', true);
									gf.playAnim('singDOWN', true);
									FlxG.camera.shake(0.025);
								}
							case 0:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singLEFTmiss', true);
									gf.playAnim('singDOWNmiss', true);
								}
								else
								{
									boyfriend.playAnim('singLEFT', true);
									gf.playAnim('singDOWN', true);
									FlxG.camera.shake(0.025);
								}
						}
					}
					else
					{
						switch (note.noteData)
						{
							case 2:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singUPmiss', true);
								}
								else
								{
									boyfriend.playAnim('singUP', true);
								}

							case 3:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singRIGHTmiss', true);
								}
								else
								{
									boyfriend.playAnim('singRIGHT', true);
								}
							case 1:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singDOWNmiss', true);
								}
								else
								{
									boyfriend.playAnim('singDOWN', true);
								}
							case 0:
								if (note.noteType == 3)
								{
									boyfriend.playAnim('singLEFTmiss', true);
								}
								else
								{
									boyfriend.playAnim('singLEFT', true);
								}
						}
					}
				case 'gemlighten':
					switch (note.noteData)
					{
						case 2:
							if (note.noteType == 2)
							{
								boyfriend.playAnim('dodge', true);
								dad.playAnim('shoots', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singUPmiss', true);
							}
							else
							{
								boyfriend.playAnim('singUP', true);
							}

						case 3:
							if (note.noteType == 2)
							{
								boyfriend.playAnim('dodge', true);
								dad.playAnim('shoots', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singRIGHTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singRIGHT', true);
							}
						case 1:
							if (note.noteType == 2)
							{
								boyfriend.playAnim('dodge', true);
								dad.playAnim('shoots', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singDOWNmiss', true);
							}
							else
							{
								boyfriend.playAnim('singDOWN', true);
							}
						case 0:
							if (note.noteType == 2)
							{
								boyfriend.playAnim('dodge', true);
								dad.playAnim('shoots', true);
							}
							else if (note.noteType == 3)
							{
								boyfriend.playAnim('singLEFTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singLEFT', true);
							}
					}
				default:
					switch (note.noteData)
					{
						case 2:
							if (note.noteType == 3)
							{
								boyfriend.playAnim('singUPmiss', true);
							}
							else
							{
								boyfriend.playAnim('singUP', true);
							}

						case 3:
							if (note.noteType == 3)
							{
								boyfriend.playAnim('singRIGHTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singRIGHT', true);
							}
						case 1:
							if (note.noteType == 3)
							{
								boyfriend.playAnim('singDOWNmiss', true);
							}
							else
							{
								boyfriend.playAnim('singDOWN', true);
							}
						case 0:
							if (note.noteType == 3)
							{
								boyfriend.playAnim('singLEFTmiss', true);
							}
							else
							{
								boyfriend.playAnim('singLEFT', true);
							}
					}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
			#end

			if (!loadRep && note.mustPress)
			{
				var array = [note.strumTime, note.sustainLength, note.noteData, noteDiff];
				if (note.isSustainNote)
					array[1] = -1;
				saveNotes.push(array);
				saveJudge.push(note.rating);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (FlxG.save.data.distractions)
		{
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.distractions)
		{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	function lightningStrikeShit():Void
	{
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		});

		lightning.animation.play('strike');
		FlxG.camera.flash(FlxColor.WHITE, 0.5);

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep', curStep);
			luaModchart.executeState('stepHit', [curStep]);
		}
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"Acc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			songLength
			- Conductor.songPosition);
		#end
		if (curStage == 'disrepaircircus' && SONG.song.toLowerCase() == 'ringmaster')
			switch (curStep)
			{
				case 253:
					FlxTween.tween(camHUD, {alpha: 0}, 3.5);
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + .5}, 3.5);
				case 295:
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0);
					FlxG.camera.flash(FlxColor.BLACK, 15);
					enough.play(true);
					notlights.visible = false;
					notlight.visible = false;
				case 320:
					FlxTween.tween(camHUD, {alpha: 1}, 8);
				case 327:
					stompAudience.x = ringmasterAudience.x;
					stompAudience.y = ringmasterAudience.y;
					FlxTween.tween(ringmasterAudience, {alpha: 0}, 0.1);
				case 1712:
					FlxTween.tween(stompAudience, {alpha: 0}, 0.1);
					FlxTween.tween(ringmasterAudience, {alpha: 1}, 0.1);
			}
		if (curStage == 'disrepaircircus' && SONG.song.toLowerCase() == 'gemlighten')
			switch (curStep)
			{
				case 1:
					SONG.noteStyle = 'gemlight';
					removeStatics();
					generateStaticArrows(0, false);
					generateStaticArrows(1, false);
				case 253:
					FlxTween.tween(camHUD, {alpha: 0}, 3.5);
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + .5}, 3.5);
				case 295:
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0);
					dad.playAnim('gunsout', true);
				case 320:
					FlxTween.tween(camHUD, {alpha: 1}, 0.5);
				case 327:
					stompAudience.x = ringmasterAudience.x;
					stompAudience.y = ringmasterAudience.y;
					FlxTween.tween(ringmasterAudience, {alpha: 0}, 0.1);
				case 1712:
					FlxTween.tween(stompAudience, {alpha: 0}, 0.1);
					FlxTween.tween(ringmasterAudience, {alpha: 1}, 0.1);
			}
		if (SONG.song.toLowerCase() == 'vencit')
			switch (curStep)
			{
				case 1:
					SONG.noteStyle = 'default';
					removeStatics();
					generateStaticArrows(0, false);
					generateStaticArrows(1, false);
				case 567:
					FlxG.camera.flash(FlxColor.RED, 0.5);
				case 832:
					FlxG.camera.flash(FlxColor.RED, 0.5);
				case 1216:
					FlxG.camera.flash(FlxColor.RED, 0.5);
				case 2113:
					FlxG.camera.flash(FlxColor.RED, 0.5);
				case 2444:
					remove(dad);
					dad = new Character(-100, 260, 'erraticspeaks');
					add(dad);
				case 2496:
					FlxG.camera.flash(FlxColor.RED, 0.5);
					remove(dad);
					dad = new Character(-100, 260, 'erraticpissed');
					add(dad);
					SONG.noteStyle = 'shattered';
					removeStatics();
					generateStaticArrows(0, false);
					generateStaticArrows(1, false);
				case 3536:
					FlxTween.tween(erraticRageBar, {color: FlxColor.BLACK}, 4);
			}
		if (SONG.song.toLowerCase() == 'vengeance')
			switch (curStep)
			{
				case 608:
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + .5}, 1.5);
					FlxTween.tween(camHUD, {alpha: 0}, 1.5);
				case 624:
					remove(dad);
					dad = new Character(100, 400, 'brokenerraticscream');
					FlxG.camera.shake(0.025, 1);
					add(dad);
				case 632:
					lightningStrikeShit();
					FlxG.camera.flash(FlxColor.WHITE, 0.5);
				case 639:
					remove(gf);
					remove(dad);
					dad = new Character(100, 400, 'brokenerratic');
					add(dad);
				case 640:
					FlxTween.tween(camHUD, {alpha: 1}, 1.5);
			}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat', curBeat);
			luaModchart.executeState('beatHit', [curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf')
		{
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.song.toLowerCase() == 'vencit')
			switch (storyDifficulty)
			{
				case 2:
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 141 && curBeat <= 208 && healthBar.percent > 2)
					{
						health -= 0.005;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 208 && curBeat <= 272 && healthBar.percent > 2)
					{
						health -= 0.01;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 272 && curBeat <= 304 && healthBar.percent > 2)
					{
						health -= 0.015;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 304 && curBeat <= 528 && healthBar.percent > 2)
					{
						health -= 0.02;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 528 && curBeat <= 880 && healthBar.percent > 2)
					{
						health -= 0.025;
					}
				case 3:
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 141 && curBeat <= 208 && healthBar.percent > 2)
					{
						health -= 0.01;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 208 && curBeat <= 272 && healthBar.percent > 2)
					{
						health -= 0.02;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 272 && curBeat <= 304 && healthBar.percent > 2)
					{
						health -= 0.03;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 304 && curBeat <= 528 && healthBar.percent > 2)
					{
						health -= 0.04;
					}
					if (SONG.song.toLowerCase() == 'vencit' && curBeat >= 528 && curBeat <= 880 && healthBar.percent > 2)
					{
						health -= 0.05;
					}
			}

		if (SONG.song.toLowerCase() == 'maledicta' && curStep >= 1407 && curStep <= 1439)
			gf.playAnim('singUP', true);

		if (SONG.song.toLowerCase() == 'maledicta' && curStep >= 1440 && curStep <= 1470)
			gf.playAnim('singDOWN', true);

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
			{
				if (SONG.song.toLowerCase() == 'gemlighten')
				{
					if (curStep <= 295)
						dad.playAnim('idle');
					else if (curStep > 295 && curStep <= 336)
						dad.playAnim('gunsout', true);
					else if (curStep > 336)
						dad.playAnim('gunidle');
				}
				else
					dad.dance();
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing")
			&& PlayState.SONG.song.toLowerCase() == 'vencit'
			&& curStep >= 567
			&& SONG.player1 == 'vencitbf')
		{
			boyfriend.playAnim('scaredidle');
		}
		else if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 7 && SONG.song.toLowerCase() == 'maledicta')
		{
			rage -= 0.125;
		}

		if (curBeat % 16 == 15 && SONG.song.toLowerCase() == 'back-stage' && dad.curCharacter == 'gf' && curBeat > 16)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}
		if (curStage == 'emptycircus' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if (FlxG.save.data.distractions)
			{
				lightningStrikeShit();
			}
		}

		var curLight:Int = 0;
	}
}
