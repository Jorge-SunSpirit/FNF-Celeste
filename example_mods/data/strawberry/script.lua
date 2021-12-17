local allowCountdown = false

function onCreate()
	--makeLuaSprite('no', 'celeste/void2', 0, 0);
	--setObjectCamera('no', 'camHud');
	--scaleObject('no', 1280/200, 720/200);
	--addLuaSprite('no', true);
	--debugPrint('hola');
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
	end
end