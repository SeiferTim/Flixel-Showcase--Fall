package 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import com.gskinner.utils.Rnd;
	
	public class LeafBit extends FlxSprite
	{
		public var weight:Number = 0; // affects how much the wind moves this leaf
		private var init:FlxPoint; // the 'starting' point of the leaf to snap back to
		private var colors:Array; // array of colors
		public var falling:Boolean = false; // if the leaf is falling or not
		public var landed:Boolean = false; // if the leaf is on the ground or not
		
		public function LeafBit(X:int, Y:int, w:int) 
		{
			super(X, Y, null);
			
			colors = new Array();
			// this is an array of possibly 'fall' colors for our leaves.
			colors.push(0xffb14211);
			colors.push(0xffd9541a);
			colors.push(0xff663408);
			colors.push(0xffbc5815);
			colors.push(0xffecb338);
			colors.push(0xffbf1313);
			
			createGraphic(1, 1, colors[Rnd.integer(0, 5)], false, null);
			width = 1;
			height = 1;
			weight = w;
			reset(X, Y);
		}
		
		public function push(Force:Number):void
		{
			// take the amount of force being applied, subtact the weight of this bit (+/- a random amount), the remainder is how much it moves.
			var m:Number = Math.ceil((Math.abs(Force) - weight) / 2);
			var dir:int = Force / Math.abs(Force);
			if (landed)
			{	
				acceleration.y = weight*15;
				//if we landed, then we can only move if the wind is strong, and if we're not under another leaf
				if (x > -50 && x < FlxG.width+50)
				{
					velocity.x = ((dir * m) * Rnd.float(0.65, 0.95));
					if (m > 2)
					{
						if (Rnd.boolean(0.01))
						{
							velocity.y = -(m * Rnd.float(0.5, 0.75));
							falling = true;
							landed = false;
						}
					}
				}
			}
			else if (!falling)
			{
				//if we're not falling, the wind might push us a little bit (or not) if it pushes too hard, we might start falling.
				if (Rnd.boolean(Rnd.float(0.1, 0.3)) && m > 0)
				{
					if (m > 2)
						if (Rnd.boolean(0.01))
						{
							falling = true;
							solid = true;
						}
						else
							x = init.x + (dir * 2);
					else
						x = init.x + (dir * m);
				}
				else
					snapback();
			}
			else
			{
				// if we're falling, the velocity can randomly change, but it's based on the wind.
				acceleration.y = weight*5;
				velocity.x = ((dir * m) * Rnd.float(0.85, 1.15)) + Rnd.integer( -2, 2);
				velocity.y += ((m * 0.5) * Rnd.float(-0.15, 0.15)) * Rnd.sign(0.3);
			}
			
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X, Y);
			init = new FlxPoint(X, Y);
			fixed = false;
			moves = true;
			solid  = false;
			alpha = 1;
		}
		
		public function snapback():void
		{
			// put the leaf back where it started
			x = init.x;
			y = init.y;
		}
		
		override public function update():void
		{
			// if the leaf falls too far off the screen, we'll kill it
			if (y > FlxG.height) kill();
			super.update();
		}
		
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void
		{
			// we only want to land on top of the ground or other leaves that have landed.
			var hit:Boolean = false;
			if (Contact is LeafBit)
			{
				var f:LeafBit = Contact as LeafBit;
				if (f.landed) hit = true;
			}
			else hit = true;
			if (hit)
			{
				solid = true;
				//moves = false;
				super.hitTop(Contact, 0);
				// when we do land on something, we stop our movement and set falling to false
				velocity.x = 0;
				falling = false;
				landed = true;
				
			}
		}
		override public function hitRight(Contact:FlxObject, Velocity:Number):void
		{
			// we only want to land on top of the ground or other leaves that have landed.
			var hit:Boolean = false;
			if (Contact is LeafBit)
			{
				var f:LeafBit = Contact as LeafBit;
				if (f.landed) hit = true;
			}
			else hit = true;
			if (hit)
			{
				solid = true;
				//moves = false;
				super.hitRight(Contact, 0);
				// when we do land on something, we stop our movement and set falling to false
				velocity.x = 0;
				falling = false;
				landed = true;
				
			}
		}
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			// we only want to land on top of the ground or other leaves that have landed.
			var hit:Boolean = false;
			if (Contact is LeafBit)
			{
				var f:LeafBit = Contact as LeafBit;
				if (f.landed) hit = true;
			}
			else hit = true;
			if (hit)
			{
				solid = true;
				//moves = false;
				super.hitLeft(Contact, 0);
				// when we do land on something, we stop our movement and set falling to false
				velocity.x = 0;
				falling = false;
				landed = true;
				
			}
		}
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			// we only want to land on top of the ground or other leaves that have landed.
			var hit:Boolean = false;
			if (Contact is LeafBit)
			{
				var f:LeafBit = Contact as LeafBit;
				if (f.landed) hit = true;
			}
			else hit = true;
			if (hit)
			{
				solid = true;
				//moves = false;
				super.hitBottom(Contact, 0);
				// when we do land on something, we stop our movement and set falling to false
				velocity.x = 0;
				falling = false;
				landed = true;
				
				
			}
			
		}
		
	}

}