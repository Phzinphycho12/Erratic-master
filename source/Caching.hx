package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Exception;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var text:FlxText;
	var loadingScreen:FlxSprite;
	var loading:FlxSprite;

	override function create()
	{
		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300, 0, "Welcome to the Circus!");
		text.size = 34;
		text.alignment = FlxTextAlign.CENTER;
		text.alpha = 0;
		text.color = FlxColor.RED;

		loadingScreen = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('loadingscreen/Loading Screen'));
		loadingScreen.screenCenter();
		text.x -= 170;
		loadingScreen.setGraphicSize(Std.int(loadingScreen.width * 0.7));

		loading = new FlxSprite(FlxG.width, FlxG.height);
		loading.frames = Paths.getSparrowAtlas('loadingscreen/Loading');
		loading.screenCenter();
		loading.animation.addByPrefix('idle', 'Loading CQSUXDICK', 24, true);
		loading.animation.play('idle');
		loading.x = -10;
		loading.y = -50;
		loading.alpha = 0;
		loadingScreen.alpha = 0;

		add(loadingScreen);
		add(loading);
		add(text);

		trace('starting caching..');

		sys.thread.Thread.create(() ->
		{
			cache();
		});

		super.create();
	}

	var calledDone = false;

	override function update(elapsed)
	{
		if (toBeDone != 0 && done != toBeDone)
		{
			var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100, 2) / 100;
			loadingScreen.alpha = alpha;
			loading.alpha = alpha;
			text.alpha = 0;
			text.x = -10;
			text.text = "Welcome to the Circus! (" + done + "/" + toBeDone + ")";
		}

		super.update(elapsed);
	}

	function cache()
	{
		var images = [];
		var music = [];

		trace("caching images...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}

		toBeDone = Lambda.count(images) + Lambda.count(music);

		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png", "");
			FlxG.bitmap.add(Paths.image("characters/" + replaced, "shared"));
			trace("cached " + replaced);
			done++;
		}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}

		trace("Finished caching...");

		FlxG.switchState(new TitleState());
	}
}
