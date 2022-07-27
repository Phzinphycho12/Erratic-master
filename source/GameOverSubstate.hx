package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'erratic_md':
				daStage = 'finalhell';
				daBf = 'erratic_md-dead';
			case 'rockstarerratic':
				daBf = 'rockstarerratic-dead';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		if (daBf == 'erratic_md-dead')
			bf.screenCenter();
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		if (daBf == 'erratic_md-dead')
		{
			FlxG.sound.play(Paths.sound('erratic_loss_sfx'));
			FlxG.camera.zoom = 2;
		}
		else if (daBf == 'rockstarerratic-dead')
		{
			FlxG.sound.play(Paths.sound('rerratic_loss_sfx'));
		}
		else
		{
			FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		}

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}
          #if android
      addVirtualPad(NONE, A_B);
      #end
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && PlayState.storyWeek == 0)
		{
			FlxG.sound.playMusic(Paths.music('gameOver'));
		}
		else if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && PlayState.storyWeek == 1)
		{
			FlxG.sound.playMusic(Paths.music('gameOverWeek2'));
		}
		else if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && PlayState.storyWeek >= 2)
		{
			FlxG.sound.playMusic(Paths.music('gameOver'));
		}
		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			if (PlayState.storyWeek == 0 || PlayState.storyWeek >= 2)
				FlxG.sound.play(Paths.music('gameOverEnd'));
			else if (PlayState.storyWeek == 1)
				FlxG.sound.play(Paths.music('gameOverEndWeek2'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
