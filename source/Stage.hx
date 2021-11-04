package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;

class Stage
{
    public var curStage:String = '';
    public var camZoom:Float; // The zoom of the camera to have at the start of the game
    public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
    public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
    public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
    // Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
    public var swagBacks:Map<String, Dynamic> = []; // Store BGs here to use them later in PlayState / with slowBacks / or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game)
    public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; // Store Groups
    public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in PlayState)
    public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment)
    public var slowBacks:Map<Int, Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!

	// All of the above must be set or used in your stage case code block!!

    public function new(daStage:String)
    {
        this.curStage = daStage;
        camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
		if (PlayStateChangeables.Optimize) return;

        switch(daStage)
        {
            case 'celeste':
				{
					camZoom = 0.8;
					var scale = 1.3;
					var posX = -286;
					var posY = -165;
					curStage = 'celeste';
					/*

					var halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['halloweenBG'] = halloweenBG;
					toAdd.push(halloweenBG);*/

					var sky:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage/celestesky', 'celeste'));
					sky.setGraphicSize(Std.int(sky.width * scale));
					sky.antialiasing = FlxG.save.data.antialiasing;
					sky.scrollFactor.set(0.1, 0.1);
					sky.active = false;
					swagBacks['sky'] = sky;
					toAdd.push(sky);

					var bridge:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage/celestebridge', 'celeste'));
					bridge.setGraphicSize(Std.int(bridge.width * 1));
					bridge.antialiasing = FlxG.save.data.antialiasing;
					bridge.scrollFactor.set(0.3, 0.3);
					bridge.active = false;
					swagBacks['bridge'] = bridge;
					toAdd.push(bridge);

					var city:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage/celestecity', 'celeste'));
					city.setGraphicSize(Std.int(city.width * 1));
					city.antialiasing = FlxG.save.data.antialiasing;
					city.scrollFactor.set(0.35, 0.35);
					city.active = false;
					swagBacks['city'] = city;
					toAdd.push(city);

					var trees:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage/celestetrees', 'celeste'));
					trees.setGraphicSize(Std.int(trees.width * scale));
					trees.antialiasing = FlxG.save.data.antialiasing;
					trees.scrollFactor.set(0.85, 0.9);
					trees.active = false;
					swagBacks['trees'] = trees;
					toAdd.push(trees);

					var floorback:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage/celestefloorback', 'celeste'));
					floorback.setGraphicSize(Std.int(floorback.width * scale));
					floorback.antialiasing = FlxG.save.data.antialiasing;
					floorback.scrollFactor.set(0.85, 0.9);
					floorback.active = false;
					swagBacks['floorback'] = floorback;
					toAdd.push(floorback);

					var floor:FlxSprite = new FlxSprite(posX + 20, posY).loadGraphic(Paths.image('stage/celestefloor', 'celeste'));
					floor.setGraphicSize(Std.int(floor.width * scale));
					floor.antialiasing = FlxG.save.data.antialiasing;
					floor.scrollFactor.set(0.9, 0.9);
					floor.active = false;
					swagBacks['floor'] = floor;
					toAdd.push(floor);

					var grave:FlxSprite = new FlxSprite(posX - 10, posY).loadGraphic(Paths.image('stage/celestegrave', 'celeste'));
					grave.setGraphicSize(Std.int(floor.width * scale));
					grave.antialiasing = FlxG.save.data.antialiasing;
					grave.scrollFactor.set(1, 1);
					grave.active = false;
					swagBacks['grave'] = grave;
					toAdd.push(grave);


				}

			case 'celestedream':
				{
					camZoom = 0.8;
					var scale = 1.3;
					var posX = -286;
					var posY = -165;
					curStage = 'celestedream';

					var sky:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stagedream/dreamsky', 'celeste'));
					sky.setGraphicSize(Std.int(sky.width * scale));
					sky.antialiasing = FlxG.save.data.antialiasing;
					sky.scrollFactor.set(0.1, 0.1);
					sky.active = false;
					swagBacks['sky'] = sky;
					toAdd.push(sky);

					var stars:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stagedream/dreamstars', 'celeste'));
					stars.setGraphicSize(Std.int(stars.width * scale));
					stars.antialiasing = FlxG.save.data.antialiasing;
					stars.scrollFactor.set(0.1, 0.1);
					stars.active = false;
					swagBacks['stars'] = stars;
					toAdd.push(stars);

					var bridge:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stagedream/dreambridge', 'celeste'));
					bridge.setGraphicSize(Std.int(bridge.width * 1));
					bridge.antialiasing = FlxG.save.data.antialiasing;
					bridge.scrollFactor.set(0.3, 0.3);
					bridge.active = false;
					swagBacks['bridge'] = bridge;
					toAdd.push(bridge);

					var city:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stagedream/dreamcity', 'celeste'));
					city.setGraphicSize(Std.int(city.width * 1));
					city.antialiasing = FlxG.save.data.antialiasing;
					city.scrollFactor.set(0.35, 0.35);
					city.active = false;
					swagBacks['city'] = city;
					toAdd.push(city);

					var trees:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stagedream/dreamtrees', 'celeste'));
					trees.setGraphicSize(Std.int(trees.width * scale));
					trees.antialiasing = FlxG.save.data.antialiasing;
					trees.scrollFactor.set(0.85, 0.9);
					trees.active = false;
					swagBacks['trees'] = trees;
					toAdd.push(trees);

					var floor:FlxSprite = new FlxSprite(posX + 20, posY).loadGraphic(Paths.image('stagedream/dreamfloor', 'celeste'));
					floor.setGraphicSize(Std.int(floor.width * scale));
					floor.antialiasing = FlxG.save.data.antialiasing;
					floor.scrollFactor.set(0.9, 0.9);
					floor.active = false;
					swagBacks['floor'] = floor;
					toAdd.push(floor);

					var grave:FlxSprite = new FlxSprite(posX - 10, posY).loadGraphic(Paths.image('stagedream/dreamgrave', 'celeste'));
					grave.setGraphicSize(Std.int(floor.width * scale));
					grave.antialiasing = FlxG.save.data.antialiasing;
					grave.scrollFactor.set(1, 1);
					grave.active = false;
					swagBacks['grave'] = grave;
					toAdd.push(grave);


				}
			case 'forsaken':
				{
					camZoom = 0.8;
					var scale = 1.3;
					var posX = -286;
					var posY = -165;
					curStage = 'forsaken';

					var sky:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage2/reflectionsky', 'celeste'));
					sky.setGraphicSize(Std.int(sky.width * scale));
					sky.antialiasing = FlxG.save.data.antialiasing;
					sky.scrollFactor.set(0.1, 0.1);
					sky.active = false;
					swagBacks['sky'] = sky;
					toAdd.push(sky);

					var stars:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage2/reflectionstars', 'celeste'));
					stars.setGraphicSize(Std.int(sky.width * scale));
					stars.antialiasing = FlxG.save.data.antialiasing;
					stars.scrollFactor.set(0.1, 0.1);
					stars.active = false;
					swagBacks['stars'] = stars;
					toAdd.push(stars);

					var inside:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage2/reflectioninside', 'celeste'));
					inside.setGraphicSize(Std.int(inside.width * scale));
					inside.antialiasing = FlxG.save.data.antialiasing;
					inside.scrollFactor.set(0.85, 0.9);
					inside.active = false;
					swagBacks['inside'] = inside;
					toAdd.push(inside);

					var ground:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage2/reflectionground', 'celeste'));
					ground.setGraphicSize(Std.int(ground.width * scale));
					ground.antialiasing = FlxG.save.data.antialiasing;
					ground.scrollFactor.set(0.9, 0.9);
					ground.active = false;
					swagBacks['ground'] = ground;
					toAdd.push(ground);

					var foreground:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage2/reflectionforeground', 'celeste'));
					foreground.setGraphicSize(Std.int(foreground.width * scale));
					foreground.antialiasing = FlxG.save.data.antialiasing;
					foreground.scrollFactor.set(1, 1);
					foreground.active = false;
					swagBacks['foreground'] = foreground;
					layInFront[2].push(foreground);
				}
			
			case 'reflection':
				{
					camZoom = 0.65;
					var scale = 1.3;
					var posX = -286;
					var posY = -165;
					curStage = 'reflection';

					var sky:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage3/forsakensky', 'celeste'));
					sky.setGraphicSize(Std.int(sky.width * scale));
					sky.antialiasing = FlxG.save.data.antialiasing;
					sky.scrollFactor.set(0.1, 0.1);
					sky.active = false;
					swagBacks['sky'] = sky;
					toAdd.push(sky);

					var bridge:FlxSprite = new FlxSprite(posX, posY - 50).loadGraphic(Paths.image('stage3/forsakenbridge', 'celeste'));
					bridge.setGraphicSize(Std.int(bridge.width * scale));
					bridge.antialiasing = FlxG.save.data.antialiasing;
					bridge.scrollFactor.set(0.3, 0.3);
					bridge.active = false;
					swagBacks['bridge'] = bridge;
					toAdd.push(bridge);

					var mountains:FlxSprite = new FlxSprite(posX, posY - 50).loadGraphic(Paths.image('stage3/forsakenmountains', 'celeste'));
					mountains.setGraphicSize(Std.int(mountains.width * scale));
					mountains.antialiasing = FlxG.save.data.antialiasing;
					mountains.scrollFactor.set(0.3, 0.3);
					mountains.active = false;
					swagBacks['mountains'] = mountains;
					toAdd.push(mountains);

					var ground:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage3/forsakenfloor', 'celeste'));
					ground.setGraphicSize(Std.int(ground.width * scale));
					ground.antialiasing = FlxG.save.data.antialiasing;
					ground.scrollFactor.set(0.9, 0.9);
					ground.active = false;
					swagBacks['ground'] = ground;
					toAdd.push(ground);

					var grave:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage3/forsakengravestone', 'celeste'));
					grave.setGraphicSize(Std.int(grave.width * scale));
					grave.antialiasing = FlxG.save.data.antialiasing;
					grave.scrollFactor.set(0.85, 0.9);
					grave.active = false;
					swagBacks['grave'] = grave;
					toAdd.push(grave);

				}

			case 'golden':
				{
					camZoom = 0.8;
					var scale = 1.3;
					var posX = -286;
					var posY = -165;
					curStage = 'golden';

					var sky:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage4/GOLDENsky', 'celeste'));
					sky.setGraphicSize(Std.int(sky.width * scale));
					sky.antialiasing = FlxG.save.data.antialiasing;
					sky.scrollFactor.set(0.1, 0.1);
					sky.active = false;
					swagBacks['sky'] = sky;
					toAdd.push(sky);

					var moss:FlxSprite = new FlxSprite(posX, posY - 50).loadGraphic(Paths.image('stage4/GOLDENmossidk', 'celeste'));
					moss.setGraphicSize(Std.int(moss.width * scale));
					moss.antialiasing = FlxG.save.data.antialiasing;
					moss.scrollFactor.set(0.5, 0.5);
					moss.active = false;
					swagBacks['moss'] = moss;
					toAdd.push(moss);

					var backspike:FlxSprite = new FlxSprite(posX, posY - 50).loadGraphic(Paths.image('stage4/GOLDENbackspikes', 'celeste'));
					backspike.setGraphicSize(Std.int(backspike.width * scale));
					backspike.antialiasing = FlxG.save.data.antialiasing;
					backspike.scrollFactor.set(0.7, 0.7);
					backspike.active = false;
					swagBacks['backspike'] = backspike;
					toAdd.push(backspike);

					var pillars:FlxSprite = new FlxSprite(posX, posY - 50).loadGraphic(Paths.image('stage4/GOLDENpillars', 'celeste'));
					pillars.setGraphicSize(Std.int(pillars.width * scale));
					pillars.antialiasing = FlxG.save.data.antialiasing;
					pillars.scrollFactor.set(0.7, 0.7);
					pillars.active = false;
					swagBacks['pillars'] = pillars;
					toAdd.push(pillars);

					var ground:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage4/GOLDENground', 'celeste'));
					ground.setGraphicSize(Std.int(ground.width * scale));
					ground.antialiasing = FlxG.save.data.antialiasing;
					ground.scrollFactor.set(0.9, 0.9);
					ground.active = false;
					swagBacks['ground'] = ground;
					toAdd.push(ground);

					var frontspikes:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stage4/GOLDENforegroundspikes', 'celeste'));
					frontspikes.setGraphicSize(Std.int(frontspikes.width * scale));
					frontspikes.antialiasing = FlxG.save.data.antialiasing;
					frontspikes.scrollFactor.set(.9, .9);
					frontspikes.active = false;
					swagBacks['frontspikes'] = frontspikes;
					layInFront[2].push(frontspikes);

				}
			
			default:
				{
					camZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = FlxG.save.data.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					swagBacks['stageCurtains'] = stageCurtains;
					toAdd.push(stageCurtains);
				}
        }
    }
}