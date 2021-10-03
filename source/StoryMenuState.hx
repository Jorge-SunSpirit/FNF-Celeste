package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.effects.FlxFlicker;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	static function weekData():Array<Dynamic>
	{
		return [
			['Strawberry'],
			['Forsaken'],
			['Forsaken'],
			['Forsaken']
		];
	}
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [];

	var curWeek:Int = 0;
	var weekordiff:Int = 0;

	var chapterselect:FlxSprite;
	var easy:FlxSprite;
	var normal:FlxSprite;
	var hard:FlxSprite;
	var bastard:FlxSprite;
	var mountain:FlxSprite;
	var mountaintween:FlxTween;
	var sky:FlxSprite;
	var skytween:FlxTween;

	var leftarrow:FlxSprite;
	var rightarrow:FlxSprite;


	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		
		weeks.push(true);

		for(i in 0...FlxG.save.data.weekUnlocked)
			{
				weeks.push(true);
			}
		return weeks;
	}

	override function create()
	{
		weekUnlocked = unlockWeeks();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(102);
			}
		}
		persistentUpdate = persistentDraw = true;

		sky = new FlxSprite(-485, -357).loadGraphic(Paths.image('storymenu/snow'));
		add(sky);

		skytween = FlxTween.tween(sky, {x:-485, y:-357}, 0);

		mountain = new FlxSprite(-1320, -1327).loadGraphic(Paths.image('storymenu/mountain'));
		add(mountain);

		mountaintween = FlxTween.tween(mountain, {x:-1759, y:-1825}, 0);

		bastard = new FlxSprite(335, 293).loadGraphic(Paths.image('storymenu/bastard'));
		add(bastard);

		chapterselect = new FlxSprite(661, 28);
		chapterselect.frames = Paths.getSparrowAtlas('storymenu/weekstuff');
		chapterselect.animation.addByPrefix('week0', 'week0', 24);
		chapterselect.animation.addByPrefix('week1', 'week1', 24);
		chapterselect.animation.addByPrefix('week2', 'week2', 24);
		chapterselect.animation.addByPrefix('week3', 'week3', 24);
		chapterselect.animation.play('week0');
		chapterselect.updateHitbox();
		add(chapterselect);

		leftarrow = new FlxSprite(712 - 60, 37);
		//35
		leftarrow.scale.set(0.35, 0.35);
		leftarrow.updateHitbox();
		leftarrow.frames = Paths.getSparrowAtlas('storymenu/arrows');
		leftarrow.animation.addByPrefix('idle', 'arrow 1', 24, true);
		leftarrow.animation.play('idle');
		add(leftarrow);

		rightarrow = new FlxSprite(1206 - 60, 37);
		rightarrow.scale.set(0.35, 0.35);
		rightarrow.updateHitbox();
		rightarrow.frames = Paths.getSparrowAtlas('storymenu/arrows');
		rightarrow.animation.addByPrefix('idle', 'arrow 2', 24, true);
		rightarrow.animation.play('idle');
		add(rightarrow);

		//difficultys
		easy = new FlxSprite(797, 266).loadGraphic(Paths.image('storymenu/easy'));
		add(easy);
		//default difficulty is normal so you go down more :)
		normal = new FlxSprite(932, 286).loadGraphic(Paths.image('storymenu/normal'));
		add(normal);
		hard = new FlxSprite(1067, 266).loadGraphic(Paths.image('storymenu/hard'));
		add(hard);

		var bullShit:Int = 0;

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						weekordifficulty(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						weekordifficulty(1);
					}

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						switch (weekordiff)
						{
							case 0:
								changeWeek(1);
							case 1:
								changeDifficulty(1);
						}
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						switch (weekordiff)
						{
							case 0:
								changeWeek(-1);
							case 1:
								changeDifficulty(-1);
						}
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					weekordifficulty(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					weekordifficulty(1);
				}

				if (controls.RIGHT_P)
					switch (weekordiff)
						{
							case 0:
								changeWeek(1);
							case 1:
								changeDifficulty(1);
						}
				if (controls.LEFT_P)
					switch (weekordiff)
						{
							case 0:
								changeWeek(-1);
							case 1:
								changeDifficulty(-1);
						}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(bastard, 1, 0.06, false, false, function(flick:FlxFlicker){});
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.songMultiplier = 1;

			PlayState.storyDifficulty = curDifficulty;

			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.conversionChecks(Song.loadFromJson(poop, PlayState.storyPlaylist[0]));
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		switch (curDifficulty)
		{
			case 0:
				FlxTween.tween(easy,{y: 286},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
			case 1:
				FlxTween.tween(easy,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 286},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
			case 2:
				FlxTween.tween(easy,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 266},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 286},0.2,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function weekordifficulty(change:Int = 0):Void
		{
			weekordiff += change;
	
			if (weekordiff < 0)
				weekordiff = 1;
			if (weekordiff > 1)
				weekordiff = 0;

			switch (weekordiff)
				{
					case 0:
						leftarrow.y = 37;
						rightarrow.y = 37;
					case 1:
						leftarrow.y = 170;
						rightarrow.y = 170;
				}
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (weekUnlocked.length > weekData().length)
			{
				if (curWeek >= weekData().length)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = weekData().length - 1;
			}
		else
			{
				if (curWeek >= weekUnlocked.length)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = weekUnlocked.length - 1;
			}

		var bullShit:Int = 0;

		chapterselect.animation.play('week' + curWeek);

		mountaintween.cancel();
		skytween.cancel();

		switch (curWeek)
			{
				case 0:
					mountaintween = FlxTween.tween(mountain,{x: -1320,y: -1327},1,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
					skytween = FlxTween.tween(sky,{x: -485,y: -357},2,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
				case 1:
					mountaintween = FlxTween.tween(mountain,{x: -952,y: -689},1,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
					skytween = FlxTween.tween(sky,{x: -485,y: -136},2,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
				case 2:
					mountaintween = FlxTween.tween(mountain,{x: -1336,y: -730},1,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
					skytween = FlxTween.tween(sky,{x: -485,y: -106},2,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
				case 3:
					mountaintween = FlxTween.tween(mountain,{x: -929,y: 560},1,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
					skytween = FlxTween.tween(sky,{x: -485,y: 0},2,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
				}

		FlxG.sound.play(Paths.sound('scrollMenu'));

	}

	public static function unlockNextWeek(week:Int):Void
	{
		if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}
}
