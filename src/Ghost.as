package 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import com.gskinner.utils.Rnd;
	
	public class Ghost extends FlxGroup
	{
		
		private var ghostParts:Array; // this array will hold all of our ghost's parts
		private var fading:Boolean = false; // track if we're fading in or not
		private var timer:Number = 0;
		
		public function Ghost(X:Number, Y:Number):void 
		{
			super();
			x = X;
			y = Y;
			ghostParts = new Array();
			// our ghost is made up of smaller FlxSprites so that we have more control over alpha.
			ghostParts.push(add(new FlxSprite(x, y).createGraphic(5, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+1).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+2, y+1).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+4, y+1).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+2).createGraphic(5, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+3).createGraphic(2, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+3, y+3).createGraphic(2, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+4).createGraphic(2, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+3, y+4).createGraphic(2, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+5).createGraphic(5, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+6).createGraphic(5, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+7).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+2, y+7).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+4, y+7).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x, y+8).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x+2, y+8).createGraphic(1, 1, 0xffffffff)));
			ghostParts.push(add(new FlxSprite(x + 4, y + 8).createGraphic(1, 1, 0xffffffff)));
			
			reset(x, y);
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			
			x = X;
			y = Y;
			// set each ghost part to be almost invisible.
			for (var i:int = 0; i < ghostParts.length; i++)
			{
				switch(i)
				{
					case 0:
						ghostParts[i].x = x;
						ghostParts[i].y = y;
						break;
					case 1:
						ghostParts[i].x = x;
						ghostParts[i].y = y+1;
						break;
					case 2:
						ghostParts[i].x = x+2;
						ghostParts[i].y = y+1;
						break;
					case 3:
						ghostParts[i].x = x+4;
						ghostParts[i].y = y+1;
						break;
					case 4:
						ghostParts[i].x = x;
						ghostParts[i].y = y+2;
						break;
					case 5:
						ghostParts[i].x = x;
						ghostParts[i].y = y+3;
						break;
					case 6:
						ghostParts[i].x = x+3;
						ghostParts[i].y = y+3;
						break;
					case 7:
						ghostParts[i].x = x;
						ghostParts[i].y = y+4;
						break;
					case 8:
						ghostParts[i].x = x+3;
						ghostParts[i].y = y+4;
						break;
					case 9:
						ghostParts[i].x = x;
						ghostParts[i].y = y+5;
						break;
					case 10:
						ghostParts[i].x = x;
						ghostParts[i].y = y+6;
						break;
					case 11:
						ghostParts[i].x = x;
						ghostParts[i].y = y+7;
						break;
					case 12:
						ghostParts[i].x = x+2;
						ghostParts[i].y = y+7;
						break;
					case 13:
						ghostParts[i].x = x+4;
						ghostParts[i].y = y+7;
						break;
					case 14:
						ghostParts[i].x = x;
						ghostParts[i].y = y+8;
						break;
					case 15:
						ghostParts[i].x = x+2;
						ghostParts[i].y = y+8;
						break;
					case 16:
						ghostParts[i].x = x+4;
						ghostParts[i].y = y+8;
						break;
				}
				ghostParts[i].alpha = 0.1;
				ghostParts[i].exists = true;
				ghostParts[i].dead = false;
				ghostParts[i].blend = "overlay";
			}
			super.reset(X, Y);
			fading = false;
			timer = 0;
			velocity.y = -Rnd.float(24, 32); // set random starting y velocity
			velocity.x = Rnd.float( -20, 20);
			dead = false;
			exists = true;
		}
		
		
		
		override public function update():void
		{
			//basically, we go through each ghost part, starting with the top, and if we're fading in make it more opaque until it's full,
			// each piece after the first's alpha is based on the level right above it so we get a gradual effect of most opaque->least opaque
			// when ghost is faded in all the way, turn on 'fading' and then we reverse the process.
			if (dead || !exists) return;
			if (timer <= 0)
			{
				var gP:FlxSprite;
				var i:int;
				if (fading)
				{
					if (ghostParts[0].alpha <= 0) kill();
					else
					{
						for (i = 0; i < ghostParts.length; i++)
						{
							switch(i)
							{
								case 0:
									ghostParts[i].alpha -= 0.1;
									break;
								case 1:
								case 2:
								case 3:
									ghostParts[i].alpha = ghostParts[0].alpha -0.1;
									break;
								case 4:
									ghostParts[i].alpha = ghostParts[2].alpha -0.1;
									break;
								case 5:
								case 6:
									ghostParts[i].alpha = ghostParts[4].alpha -0.1;
									break;
								case 7:
								case 8:
									ghostParts[i].alpha = ghostParts[5].alpha -0.1;
									break;
								case 9:
									ghostParts[i].alpha = ghostParts[7].alpha -0.1;
									break;
								case 10:
									ghostParts[i].alpha = ghostParts[9].alpha -0.1;
									break;
								case 11:
								case 12:
								case 13:
									ghostParts[i].alpha = ghostParts[10].alpha -0.1;
									break;
								case 14:
								case 15:
								case 16:
									ghostParts[i].alpha = ghostParts[11].alpha -0.1;
									break;
							}
						}
					}
				}
				else
				{
					if (ghostParts[0].alpha >= 1) fading = true;
					else
					{
						for (i = 0; i < ghostParts.length; i++)
						{
							switch(i)
							{
								case 0:
									ghostParts[i].alpha += 0.15;
									break;
								case 1:
								case 2:
								case 3:
									ghostParts[i].alpha = ghostParts[0].alpha -0.1;
									break;
								case 4:
									ghostParts[i].alpha = ghostParts[2].alpha -0.1;
									break;
								case 5:
								case 6:
									ghostParts[i].alpha = ghostParts[4].alpha -0.1;
									break;
								case 7:
								case 8:
									ghostParts[i].alpha = ghostParts[5].alpha -0.1;
									break;
								case 9:
									ghostParts[i].alpha = ghostParts[7].alpha -0.1;
									break;
								case 10:
									ghostParts[i].alpha = ghostParts[9].alpha -0.1;
									break;
								case 11:
								case 12:
								case 13:
									ghostParts[i].alpha = ghostParts[10].alpha -0.1;
									break;
								case 14:
								case 15:
								case 16:
									ghostParts[i].alpha = ghostParts[11].alpha -0.1;
									break;
							}
						}
					}					
				}
				//velocity.x = Rnd.float(-2,2)/4; // we change x velocity randomly
				timer = FlxG.elapsed*3.5;
			}
			else
				timer -= FlxG.elapsed;
			super.update();
		}
		
	}

}