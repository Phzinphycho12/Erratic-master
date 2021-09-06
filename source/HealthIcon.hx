package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('vencitbf', [0, 1], 0, false, isPlayer);
		animation.add('erratic', [4, 5], 0, false, isPlayer);
		animation.add('erraticmad', [10, 11], 0, false, isPlayer);
		animation.add('erraticpissed', [6, 7], 0, false, isPlayer);
		animation.add('gooderratic', [2, 3], 0, false, isPlayer);
		animation.add('brokenerratic', [2, 3], 0, false, isPlayer);
		animation.add('brokenerratic2', [8, 9], 0, false, isPlayer);
		animation.add('erratic_md', [17, 18], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
