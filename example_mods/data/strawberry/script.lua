local allowCountdown = false;
local idk = false;
local left = {'MA', 'NONE', 'NONE', 'NONE', 'NONE', 'MA', 'NONE', 'NONE'};
local right = {'NONE', 'A', 'B', 'C', 'D', 'NONE', 'D', 'D',};

function onCreate()
	makeLuaSprite('no', 'celeste/void2', 0, 0);
	setObjectCamera('no', 'camHud');
	scaleObject('no', 1280/200, 720/200);
	addLuaSprite('no', true);

	makeLuaSprite('void2', 'celeste/void2', 0, 0);
	setObjectCamera('void2', 'camHud');
	scaleObject('void2', 1280/200, 720/200);
end

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.1);
		allowCountdown = true;
		return Function_Stop;
	end
	if seenCutscene then
		doTweenAlpha('no', 'no', 0, 1, 'linear');
	end
	if idk == true then
		removeLuaSprite('portraits', true);
		removeLuaSprite('portraits2', true);
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then 
		startDialogue('dialogueStrawberry','madeline_ambience_loop');
		makeAnimatedLuaSprite('portraits', 'celeste/portraits', 215, 85);
		addAnimationByPrefix('portraits', 'MA', 'MA', 24, false);
		addAnimationByPrefix('portraits', 'MB', 'MB', 24, false);
		addAnimationByPrefix('portraits', 'MC', 'MC', 24, false);
		addAnimationByPrefix('portraits', 'MD', 'MD', 24, false);
		addAnimationByPrefix('portraits', 'NONE', 'none', 24, false);
		setObjectCamera('portraits', 'camHud');
		scaleObject('portraits', 0.65, 0.65);
		addLuaSprite('portraits', true);

		makeAnimatedLuaSprite('portraits2', 'celeste/portraits', 1015, 85);
		addAnimationByPrefix('portraits2', 'NONE', 'none', 24, false);
		addAnimationByPrefix('portraits2', 'A', 'BFA', 24, false);
		addAnimationByPrefix('portraits2', 'B', 'BFB', 24, false);
		addAnimationByPrefix('portraits2', 'C', 'BFC', 24, false);
		addAnimationByPrefix('portraits2', 'D', 'BFD', 24, false);
		setObjectCamera('portraits2', 'camHud');
		scaleObject('portraits2', 0.65, 0.65);
		addLuaSprite('portraits2', true);

		objectPlayAnimation('portraits', 'NONE', true);
		objectPlayAnimation('portraits2', 'A', true);
	end
end

function onNextDialogue(line)
	doTweenAlpha('no', 'no', 0, 1, 'linear');
	idk = true;
	objectPlayAnimation('portraits', left[line], true);
	objectPlayAnimation('portraits2', right[line], true);
end