package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import com.gskinner.utils.Rnd;
	 
	public class PlayState extends FlxState
	{
		private const versionNo:String = "2.0";
		public static var CRAZY_MODE:Boolean = false;
		public static const WIND_MAX:Number = 10;
		public static const CRAZY_WIND_MAX:Number = 15;
		
		[Embed(source = 'back.png')] private var ImgBack:Class;
		[Embed(source = 'mist.png')] private var ImgMist:Class;
		[Embed(source = 'crazy.png')] private var ImgCrazy:Class;
		
		private var sky:FlxSprite; // our background sky
		private var ground:FlxSprite; // our ground object
		public static var wind:Number = 0.0; // direction and force of the wind
		private var mist:FlxSprite; 
		private var crazy:FlxSprite;
		private var treegrp:FlxGroup; // all of our tree pixels...
		public static var leafgrp:FlxGroup; // all of our leaves in a group
		private var timer:Number = 0;
		private var goal:Number = 0;
		private var mistDir:int = -1;
		private var wispBackGrp:FlxGroup;
		private var wispFrontGrp:FlxGroup;
		private var ghostgrp:FlxGroup;
		private var ghostgrpFront:FlxGroup;
		public static var checkgrp:FlxGroup;
		private var jackgrp:FlxGroup;
		
		
		
		public function PlayState() 
		{
			// the background graphic
			sky = add(new FlxSprite(0, 0, null).loadGraphic(ImgBack, false, false, FlxG.width, FlxG.height, true)) as FlxSprite;
			// our different layers
			wispBackGrp = add(new FlxGroup()) as FlxGroup;
			ghostgrp = add(new FlxGroup()) as FlxGroup;
			treegrp = add(new FlxGroup()) as FlxGroup;
			jackgrp = add(new FlxGroup()) as FlxGroup;
			leafgrp = add(new FlxGroup()) as FlxGroup;
			wispFrontGrp = add(new FlxGroup()) as FlxGroup;
			checkgrp = add(new FlxGroup()) as FlxGroup;
			// build the tree!
			BuildTree();
			BuildLeaves();
			// this is the mist graphic that goes on top of everything else.
			ghostgrpFront = add(new FlxGroup()) as FlxGroup;
			
			crazy = add(new FlxSprite(0, 6, null).loadGraphic( ImgCrazy, false, false, FlxG.width, FlxG.height, true)) as FlxSprite;
			crazy.alpha = 0;
			crazy.blend = "screen";
			//crazy.visible = false;
			
			mist = add(new FlxSprite( -250 + (FlxG.width / 2), FlxG.height-45, null).loadGraphic(ImgMist, false, false, 500, FlxG.height, true)) as FlxSprite;
			mist.moves = true;
			mist.solid = false;
			mist.alpha = 0.88;
			mist.blend = "overlay";
			// the ground sprite
			ground = add(new FlxSprite( -50, FlxG.height - 5, null).createGraphic(FlxG.width + 50, 20, 0xff000000, true, "ground")) as FlxSprite;
			ground.fixed = true;  // set it to fixed, not moves, and solid for collision.
			ground.moves = false;
			ground.solid = true;
			
			//lets seed the ground with some leaves already:
			var tL:LeafBit;
			var tY:int;
			var tX:int;
			
			for (tY = FlxG.height -6; tY > FlxG.height - 9; tY--)
			{
				for (tX = -50; tX <= FlxG.width+50; tX++)
				{
					if (Rnd.boolean(0.8))
					{
						tL = leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1, 2)) as LeafBit) as LeafBit;
						tL.solid = true;
						tL.falling = true;
						tL.landed = false;
					}
				}
			}
			
			// set the wind's speed and goal
			
			wind = Rnd.float( -WIND_MAX, WIND_MAX);
			goal = Rnd.float( -WIND_MAX, WIND_MAX);
			FlxG.log("v" + versionNo );
			FlxG.log("IT'S A SECRET TO EVERYBODY.");
			FlxG.log("PRESS '1' FOR NIGHTMARE MODE!");
		}
				
		private function BuildTree():void
		{
			//build our tree - this gets a bit complicated...
			// start at the bottom
			for (var tY:int = FlxG.height - 6; tY > FlxG.height - 25; tY--)
			{
				
				for (var tX:int = (FlxG.width/2) - 2; tX <= (FlxG.width/2) + 2; tX++)
				{
					treegrp.add(new TreeBit(tX, tY,50) as TreeBit);
				}
			}
			
			// bottom block of branches
			for (tY = FlxG.height -20; tY > FlxG.height - 25; tY--)
			{
				for (tX = (FlxG.width / 2) -10; tX <= (FlxG.width / 2) + 10; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.2, 0.4)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(4,6)) as TreeBit);
					}
				}
			}
			
			//make the central mass of branches
			for (tY = FlxG.height - 25; tY > FlxG.height - 36; tY--)
			{
				for (tX = (FlxG.width / 2) - 6; tX <= (FlxG.width / 2) + 6; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.5, 0.7)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(6,8)) as TreeBit);
					}
				}
			}
			
			//make the left-side mass of branches
			for (tY = FlxG.height - 23; tY > FlxG.height - 36; tY--)
			{
				for (tX = (FlxG.width / 2) - 18; tX <= (FlxG.width / 2) - 6; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.1, 0.4)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(4,6)) as TreeBit);
					}
				}
			}
			
			//make the right-side mass of branches
			for (tY = FlxG.height - 23; tY > FlxG.height - 36; tY--)
			{
				for (tX = (FlxG.width / 2) + 6; tX <= (FlxG.width / 2) + 18; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.1, 0.4)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(4,6)) as TreeBit);
					}
				}
			}
			
			//make the upper middle mass of branches
			for (tY = FlxG.height - 36; tY > FlxG.height - 47; tY--)
			{
				for (tX = (FlxG.width / 2) - 14; tX <= (FlxG.width / 2) + 14; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.2, 0.6)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(3,5)) as TreeBit);
					}
				}
			}
			
			// make the top branches
			for (tY = FlxG.height - 47; tY > FlxG.height - 52; tY--)
			{
				for (tX = (FlxG.width / 2) - 8; tX <= (FlxG.width / 2) + 8; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.1, 0.3)))
					{
						treegrp.add(new TreeBit(tX, tY, Rnd.integer(2,4)) as TreeBit);
					}
				}
			}
		}
		
		private function BuildLeaves():void
		{
			// bottom block of branches
			for (var tY:int = FlxG.height -18; tY > FlxG.height - 25; tY--)
			{
				for (var tX:int = (FlxG.width / 2) - 12; tX <= (FlxG.width / 2) + 12; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.3, 0.5)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
			
			//make the central mass of branches
			for (tY = FlxG.height - 25; tY > FlxG.height - 36; tY--)
			{
				for (tX = (FlxG.width / 2) - 6; tX <= (FlxG.width / 2) + 6; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.6, 0.8)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
			
			//make the left-side mass of branches
			for (tY = FlxG.height - 21; tY > FlxG.height - 38; tY--)
			{
				for (tX = (FlxG.width / 2) - 20; tX <= (FlxG.width / 2) - 6; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.2, 0.5)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
			
			//make the right-side mass of branches
			for (tY = FlxG.height - 21; tY > FlxG.height - 38; tY--)
			{
				for (tX = (FlxG.width / 2) + 6; tX <= (FlxG.width / 2) + 20; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.2, 0.5)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
			
			//make the upper middle mass of branches
			for (tY = FlxG.height - 36; tY > FlxG.height - 47; tY--)
			{
				for (tX = (FlxG.width / 2) - 16; tX <= (FlxG.width / 2) + 16; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.3, 0.7)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
			
			// make the top branches
			for (tY = FlxG.height - 47; tY > FlxG.height - 54; tY--)
			{
				for (tX = (FlxG.width / 2) - 10; tX <= (FlxG.width / 2) + 10; tX++)
				{
					if (Rnd.boolean(Rnd.float(0.2, 0.4)))
					{
						leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1,2)) as LeafBit);
					}
				}
			}
		}
		
		override public function update():void
		{
			if (timer <= 0)
			{
				// move the wind's strength
				wind += Rnd.float(1, 3) * (goal/Math.abs(goal));
				timer = 0.2;
				// push each branch
				var t:TreeBit;
				for each (t in treegrp.members)
					t.push(wind);
				//push each leaf
				var l:LeafBit;
				for each (l in leafgrp.members)
					l.push(wind);
				if (CRAZY_MODE && crazy.alpha < 0.66)
					crazy.alpha += 0.11;
				else if (!CRAZY_MODE && crazy.alpha > 0)
					crazy.alpha -= 0.11;
			}
			else
				timer -= FlxG.elapsed;
				
			// here's some logic to get the mist moving and to stay in the bounds.
			if (Math.abs(wind) >= Math.abs(goal))
			{
				if (CRAZY_MODE)
					goal = Rnd.float( -CRAZY_WIND_MAX,CRAZY_WIND_MAX);
				else
					goal = Rnd.float( -WIND_MAX, WIND_MAX);
			}
			mist.velocity.x = wind;
			if (mist.x < -500 + FlxG.width) mist.x = -500 + FlxG.width;
			else if (mist.x > 0) mist.x = 0;
			
			// collide leaves with other leaves and the ground
			leafgrp.collide(leafgrp);
			ground.collide(leafgrp);
			ground.collide(jackgrp);
			FlxU.overlap(jackgrp, leafgrp, LeafSplat);
			
			//randomly add new leaves from off the screen...
			if (Rnd.boolean(0.025) || (CRAZY_MODE && Rnd.boolean(0.5)))
				SpawnLeaf();
			// random wisps
			if (Rnd.boolean(0.05)|| (CRAZY_MODE && Rnd.boolean(0.1)))
				SpawnBackWisp();
			if (Rnd.boolean(0.005)|| (CRAZY_MODE && Rnd.boolean(0.01)))
				SpawnFrontWisp();
			// random ghosts
			if (Rnd.boolean(0.001) || (CRAZY_MODE && Rnd.boolean(0.2)))
				SpawnGhost();
			if (CRAZY_MODE && Rnd.boolean(0.005))
				SpawnJack();
			if (FlxG.keys.justPressed("ONE"))
				CRAZY_MODE = !CRAZY_MODE;
			super.update();
		}
		
		private function LeafSplat(j:Jack, l:LeafBit):void
		{
			if (l.landed)
			{
				l.acceleration.y = l.weight*10;
				l.velocity.y = -(10 / l.weight) * Rnd.float(0.8, 1.2);
				l.velocity.x = Rnd.float( -50, 50);
				l.falling = true;
				l.landed = false;
			}
		}
		
		private function SpawnBackWisp():void
		{
			// spawn a random wisp off the screen.
			var tW:WispBit;
			tW = wispBackGrp.getFirstAvail() as WispBit;
			if (tW == null)
			{
				if (wind < 0)
					tW = wispBackGrp.add(new WispBit(FlxG.width + 1, Rnd.integer( -1, FlxG.height - 4))) as WispBit;
				else if (wind > 0)
					tW = wispBackGrp.add(new WispBit(-1, Rnd.integer( -1, FlxG.height - 4))) as WispBit;
			}
			else
				tW.reset(FlxG.width + 1, Rnd.integer( -1, FlxG.height - 4));
		}
		private function SpawnFrontWisp():void
		{
			// spawn a random wisp off the screen in the foreground.
			var tW:WispBit;
			tW = wispFrontGrp.getFirstAvail() as WispBit;
			if (tW == null)
			{
				if (wind < 0)
					tW = wispFrontGrp.add(new WispBit(FlxG.width + 1, Rnd.integer( -1, FlxG.height - 4))) as WispBit;
				else if (wind > 0)
					tW = wispFrontGrp.add(new WispBit(-1, Rnd.integer( -1, FlxG.height - 4))) as WispBit;
			}
			else
				tW.reset(FlxG.width + 1, Rnd.integer( -1, FlxG.height - 4));
			
		}
		
		private function SpawnGhost():void
		{
			// spawn a random ghost
			if (Rnd.boolean(0.2))
			{
				if (!ghostgrp.resetFirstAvail(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4)))
					ghostgrp.add(new Ghost(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4))) as Ghost;
			}
			else
			{
				if (!ghostgrpFront.resetFirstAvail(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4)))
					ghostgrpFront.add(new Ghost(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4))) as Ghost;
			}
		}
		
		private function SpawnLeaf():void
		{
			// spawn a random leaf off the screen.
			var tL:LeafBit;
			tL = leafgrp.getFirstAvail() as LeafBit;
			var pos:FlxPoint = new FlxPoint(0,0);
			if (wind > 0)
				pos.x = -1;
			else if (wind < 0)
				pos.x = FlxG.width + 1;
			else
			{
				if (Rnd.boolean())
					pos.x = -1;
				else
					pos.x = FlxG.width + 1;
			}
			pos.y = Rnd.integer( 0, FlxG.height)-16;
			if (tL != null)
				tL.reset(pos.x,pos.y);
			else
				tL = leafgrp.add(new LeafBit(pos.x, pos.y, Rnd.integer(1, 2))) as LeafBit;
			tL.solid = true;
			tL.falling = true;
			tL.landed = false;
		}
		
		private function SpawnJack():void
		{
			var pos:FlxPoint = new FlxPoint(0,0);
			if (wind > 0)
				pos.x = -1;
			else if (wind < 0)
				pos.x = FlxG.width + 1;
			else
			{
				if (Rnd.boolean())
					pos.x = -1;
				else
					pos.x = FlxG.width + 1;
			}
			pos.y = Rnd.integer( 0, FlxG.height) - 16;
			if (!jackgrp.resetFirstAvail(pos.x, pos.y))
				jackgrp.add(new Jack(pos.x, pos.y)) as Jack;
			
		}
	}

}