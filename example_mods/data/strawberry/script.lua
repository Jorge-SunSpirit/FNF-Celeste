local allowCountdown = false

function onCreate()
	makeLuaSprite('no', 'celeste/void2', 0, 0);
	setObjectCamera('no', 'camHud');
	scaleObject('no', 1280/200, 720/200);
	addLuaSprite('no', true);
end

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.1);
		allowCountdown = true;
		return Function_Stop;
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
		setObjectCamera('portraits', 'camHud');
		scaleObject('portraits', 0.65, 0.65);
		addLuaSprite('portraits', true);
	end
end

function onNextDialogue(line)
	if line == 0 then
		objectPlayAnimation('portraits', 'MA', true);
	elseif line == 1 then
		objectPlayAnimation('portraits', 'MB', true);
	elseif line == 2 then
		objectPlayAnimation('portraits', 'MC', true);
	elseif line == 3 then
		objectPlayAnimation('portraits', 'MD', true);
		doTweenAlpha('no', 'no', 0, 1, 'linear');
	elseif line == 8 then
		removeLuaSprite('portraits', true);
	end
end
