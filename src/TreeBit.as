package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import com.gskinner.utils.Rnd;
	
	public class TreeBit extends FlxSprite
	{
		public var weight:Number = 0; // this is how much this part of the tree 'weighs'. The heavier it is, the more wind force it takes before it should move...
		private var init:FlxPoint;
		public function TreeBit(X:Number, Y:Number, w:int):void 
		{
			super(X, Y, null);
			createGraphic(1, 1,0xff000000, false, null);
			width = 1;
			height = 1;
			weight = w;
			reset(X, Y);
		}
		
		public function push(Force:Number):void
		{
			// take the amount of force being applied, subtact the weight of this bit (+/- a random amount), the remainder is how much it moves.
			var m:Number = Math.abs(Force) - weight;
			var dir:int = Force / Math.abs(Force);
			// theres a change the branch will move, and if it doesn't it goes back to where it started
			if (Rnd.boolean(Rnd.float(0.1, 0.3)) && m > 0)
				x = init.x +(dir * Math.ceil(m/2));
			else
				snapback();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X, Y);
			init = new FlxPoint(X, Y);
			fixed = false;
			moves = true;
			solid  = true;
			alpha = 1;
		}
		
		public function snapback():void
		{
			x = init.x;
			y = init.y;
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}