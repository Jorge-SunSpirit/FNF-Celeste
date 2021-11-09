package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	// Wether you have to beat the previous week for playing this one
	// Not recommended, as people usually download your mod for, you know,
	// playing just the modded week then delete it.
	// defaults to True
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;
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

	override function create()
	{
		#if MODS_ALLOWED
		Paths.destroyLoadedImages();
		#end
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

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

		for (i in 0...WeekData.weeksList.length)
		{
			WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[i]));
		}

		leftarrow = new FlxSprite(712 - 60, 37);
		//35
		leftarrow.scale.set(0.35, 0.35);
		leftarrow.updateHitbox();
		leftarrow.frames = Paths.getSparrowAtlas('storymenu/arrows');
		leftarrow.animation.addByPrefix('idle', 'arrow 2', 24, true);
		leftarrow.animation.play('idle');
		add(leftarrow);

		rightarrow = new FlxSprite(1206 - 60, 37);
		rightarrow.scale.set(0.35, 0.35);
		rightarrow.updateHitbox();
		rightarrow.frames = Paths.getSparrowAtlas('storymenu/arrows');
		rightarrow.animation.addByPrefix('idle', 'arrow 1', 24, true);
		rightarrow.animation.play('idle');
		add(rightarrow);

		//difficultys
		easy = new FlxSprite(797, 266).loadGraphic(Paths.image('storymenu/easy'));
		add(easy);
		//default difficulty is normal so you go down more :)
		normal = new FlxSprite(932, 286).loadGraphic(Paths.image('storymenu/normalglow'));
		add(normal);
		hard = new FlxSprite(1067, 266).loadGraphic(Paths.image('storymenu/hard'));
		add(hard);

		var bullShit:Int = 0;

		trace("Line 165");

		changeWeek();
		changeDifficulty();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_UP_P)
			{
				weekordifficulty(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_DOWN_P)
			{
				weekordifficulty(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_RIGHT_P)
				switch (weekordiff)
						{
							case 0:
								FlxG.sound.play(Paths.sound('scrollMenu'));
								changeWeek(1);
							case 1:
								FlxG.sound.play(Paths.sound('scrollMenu'));
								changeDifficulty(1);
						}
			if (controls.UI_LEFT_P)
				switch (weekordiff)
						{
							case 0:
								FlxG.sound.play(Paths.sound('scrollMenu'));
								changeWeek(-1);
							case 1:
								FlxG.sound.play(Paths.sound('scrollMenu'));
								changeDifficulty(-1);
						}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(curWeek))
		{
			if (stopspamming == false)
			{
				FlxFlicker.flicker(bastard, 1, 0.06, false, false, function(flick:FlxFlicker){});
				FlxG.sound.play(Paths.sound('confirmMenu'));
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.difficultyStuff[curDifficulty][1];
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyStuff.length-1;
		if (curDifficulty >= CoolUtil.difficultyStuff.length)
			curDifficulty = 0;

		switch (curDifficulty)
		{
			case 0:
				easy.loadGraphic(Paths.image('storymenu/easyglow'));
				normal.loadGraphic(Paths.image('storymenu/normal'));
				hard.loadGraphic(Paths.image('storymenu/hard'));
				FlxTween.tween(easy,{y: 286},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
			case 1:
				easy.loadGraphic(Paths.image('storymenu/easy'));
				normal.loadGraphic(Paths.image('storymenu/normalglow'));
				hard.loadGraphic(Paths.image('storymenu/hard'));
				FlxTween.tween(easy,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 286},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
			case 2:
				easy.loadGraphic(Paths.image('storymenu/easy'));
				normal.loadGraphic(Paths.image('storymenu/normal'));
				hard.loadGraphic(Paths.image('storymenu/hardglow'));
				FlxTween.tween(easy,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(normal,{y: 266},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
				FlxTween.tween(hard,{y: 286},0.1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){}});
		}
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
		}

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= WeekData.weeksList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = WeekData.weeksList.length - 1;

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
				default:
					mountaintween = FlxTween.tween(mountain,{x: -929,y: 560},1,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
					skytween = FlxTween.tween(sky,{x: -485,y: 0},2,{ease: FlxEase.expoOut, onComplete: function(flxTween:FlxTween){}});
				}


	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var weekArray:Array<String> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).weekCharacters;

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}
	}
}
