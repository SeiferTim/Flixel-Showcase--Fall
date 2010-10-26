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
		[Embed(source = 'back.png')] private var ImgBack:Class;
		[Embed(source = 'mist.png')] private var ImgMist:Class;
		private var sky:FlxSprite; // our background sky
		private var ground:FlxSprite; // our ground object
		public static var wind:Number = 0.0; // direction and force of the wind
		private var mist:FlxSprite; 
		private var treegrp:FlxGroup; // all of our tree pixels...
		public static var leafgrp:FlxGroup; // all of our leaves in a group
		private var timer:Number = 0;
		private var goal:Number = 0;
		private var mistDir:int = -1;
		private var wispBackGrp:FlxGroup;
		private var wispFrontGrp:FlxGroup;
		private var ghostgrp:FlxGroup;
		
		public function PlayState() 
		{
			// the background graphic
			sky = add(new FlxSprite(0, 0, null).loadGraphic(ImgBack, false, false, FlxG.width, FlxG.height, true)) as FlxSprite;
			// our different layers
			wispBackGrp = add(new FlxGroup()) as FlxGroup;
			ghostgrp = add(new FlxGroup()) as FlxGroup;
			treegrp = add(new FlxGroup()) as FlxGroup;
			leafgrp = add(new FlxGroup()) as FlxGroup;
			wispFrontGrp = add(new FlxGroup()) as FlxGroup;
			// build the tree!
			BuildTree();
			BuildLeaves();
			// this is the mist graphic that goes on top of everything else.
			mist = add(new FlxSprite( -250 + (FlxG.width / 2), FlxG.height-45, null).loadGraphic(ImgMist, false, false, 500, FlxG.height, true)) as FlxSprite;
			mist.moves = true;
			mist.solid = false;
			mist.alpha = 0.44;
			// the ground sprite
			ground = add(new FlxSprite( -50, FlxG.height - 5, null).createGraphic(FlxG.width + 50, 20, 0xff000000, true, "ground")) as FlxSprite;
			ground.fixed = true;  // set it to fixed, not moves, and solid for collision.
			ground.moves = false;
			ground.solid = true;
			
			//lets seed the ground with some leaves already:
			var tL:LeafBit;
			for (var tY:int = FlxG.height -6; tY > FlxG.height - 8; tY--)
			{
				for (var tX:int = -50; tX <= FlxG.width+50; tX++)
				{
					if (Rnd.boolean(0.5))
					{
						tL = leafgrp.add(new LeafBit(tX, tY, Rnd.integer(1, 2)) as LeafBit) as LeafBit;
						tL.solid = true;
						tL.falling = true;
						tL.landed = false;
					}
				}
			}
			
			// set the wind's speed and goal
			wind = Rnd.float( -10, 10);
			goal = Rnd.float( -10, 10);
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
				wind += Rnd.float(0.1, 0.3) * (goal/Math.abs(goal));
				timer = 0.2;
				// push each branch
				var t:TreeBit;
				for each (t in treegrp.members)
					t.push(wind);
				//push each leaf
				var l:LeafBit;
				for each (l in leafgrp.members)
					l.push(wind);
			}
			else
				timer -= FlxG.elapsed;
				
			// here's some logic to get the mist moving and to stay in the bounds.
			if (Math.abs(wind) >= Math.abs(goal))
				goal = Rnd.float( -10, 10);
			mist.velocity.x = wind;
			if (mist.x < -500 + FlxG.width) mist.x = -500 + FlxG.width;
			else if (mist.x > 0) mist.x = 0;
			
			// collide leaves with other leaves and the ground
			leafgrp.collide(leafgrp);
			ground.collide(leafgrp);
			
			//randomly add new leaves from off the screen...
			if (Rnd.boolean(0.01))
				SpawnLeaf();
			// random wisps
			if (Rnd.boolean(0.01))
				SpawnBackWisp();
			if (Rnd.boolean(0.005))
				SpawnFrontWisp();
			// random ghosts
			if (Rnd.boolean(0.001))
				SpawnGhost();
			
			super.update();
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
			var g:Ghost;
			g = ghostgrp.getFirstAvail() as Ghost;
			if (g == null)
				ghostgrp.add(new Ghost(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4))) as Ghost;
			else
				g.reset(Rnd.integer(2, FlxG.width - 7), Rnd.integer(FlxG.height + 2, FlxG.height - 4));
		}
		
		private function SpawnLeaf():void
		{
			// spawn a random leaf off the screen.
			var tL:LeafBit;
			tL = leafgrp.getFirstAvail() as LeafBit;
			var pos:FlxPoint = new FlxPoint(0,0);
			if (wind > 0)
			{
				pos.x = -1;
				pos.y = Rnd.integer( -FlxG.width, FlxG.width - 6);
			}
			else if (wind < 0)
			{
				pos.x = FlxG.width + 1;
				pos.y = Rnd.integer( -FlxG.width, FlxG.width - 6);
			}
			else
			{
				if (Rnd.boolean())
				{
					pos.x = -1;
					pos.y = Rnd.integer( -FlxG.width, FlxG.width - 6);
				}
				else
				{
					pos.x = FlxG.width + 1;
					pos.y = Rnd.integer( -FlxG.width, FlxG.width - 6);
				}
			}
			if (tL != null)
				tL.reset(pos.x,pos.y);
			else
				tL = leafgrp.add(new LeafBit(pos.x, pos.y, Rnd.integer(1, 2))) as LeafBit;
			tL.solid = true;
			tL.falling = true;
			tL.landed = false;
		}
	}

}