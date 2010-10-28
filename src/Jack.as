package 
{
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import com.gskinner.utils.Rnd;
	/**
	 * ...
	 * @author 
	 */
	public class Jack extends FlxSprite
	{
		[Embed(source = 'jack.png')] private var ImgJack:Class;
		public function Jack(X:Number, Y:Number):void
		{
			super(X, Y);
			loadGraphic(ImgJack, false, false, 9, 10);
			reset(X, Y);
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X, Y);
			acceleration.y = 80;
			if (x < 0)
				velocity.x = Rnd.float(20, 60);
			else
				velocity.x = - Rnd.float(20, 60);
		}
		
		override public function update():void
		{
			if (dead || !exists) return;
			if (y > FlxG.height) kill();
			super.update();
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			
			super.hitBottom(Contact, 0);
			velocity.y = -40;
		}
		
	}

}