package 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import com.gskinner.utils.Rnd;
	
	public class WispBit extends FlxSprite
	{
		
		private var lastdir:Number = 0; // this is to rememer which way we were blowing. If the wind changes too much, we'll die.
		private var fading:Boolean = false;
		
		public function WispBit(X:int, Y:int):void
		{
			super(X, Y, null);
			createGraphic(1, 1, 0xffffffff);
			width = 1;
			height = 1;
			reset(X, Y);
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X, Y);
			alpha = Rnd.float(0.1, 0.6);
			lastdir = PlayState.wind;
			fading = false;
		}
		
		override public function update():void
		{
			if (dead || !exists) return;
			if (fading)
			{
				// if we're fading out, decrease our opacity each tick and then kill us for real when it's 0.
				if (alpha <= 0)
				{
					dead = true;
					exists = false;
				}
				else
					alpha -= 0.2;
			}
			else if (Math.abs(PlayState.wind) < 3) kill(); // if the wind stops or slows down too much, we just die right away.
			else if (lastdir < 0) // if we were going one way and then the wind suddenly reversed on us, we die.
			{
				if (x < 0) kill();
				if (PlayState.wind >= 0) kill();
			}
			else if (lastdir > 0)
			{
				if (x > FlxG.width) kill();
				if (PlayState.wind <= 0) kill();
			}
			// our speed and direction is randomly based on the wind.
			velocity.x = (PlayState.wind * 20) * Rnd.float(0.75, 1.25);
			velocity.y += (PlayState.wind * 0.05) * Rnd.float(-0.25, 0.25);
			lastdir = PlayState.wind;
			super.update();
		}
		
		override public function kill():void
		{
			// if we get killed, we really just want to fade out.
			fading = true;
		}
	}

}