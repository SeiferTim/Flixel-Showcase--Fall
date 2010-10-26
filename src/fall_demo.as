package
{
	import org.flixel.FlxGame;

	[SWF(width="320", height="240", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class fall_demo extends FlxGame
	{
		public function fall_demo()
		{
			super(80,60,PlayState,4);
		}
	}
}