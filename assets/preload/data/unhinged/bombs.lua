local isFlippy = true

function onEvent(name)
   if mechanics then
	if name == "Bomb" then
		--setting
		removeLuaSprite('bomb',true);
		cancelTimer('bomb');
		playSound('beep',1,'beep');
		makeAnimatedLuaSprite('bomb','bomb',getRandomInt(50,1000),getRandomInt(50,300));
		addLuaSprite('bomb',true);
		setObjectCamera('bomb','other');
		addAnimationByPrefix('bomb','appear','bomb anim',24,false);
		objectPlayAnimation('bomb','bomb',false);
		setObjectOrder('bomb',2);

		--actually use the bomb
		runTimer('bomb',2);
	elseif name == "Burn" then
		makeAnimatedLuaSprite('bomburn','burn',getRandomInt(50,1000),-415);
		setObjectCamera('bomburn','other');
		addAnimationByPrefix('bomburn','fall','burnfall',24,false);
		setObjectOrder('bomburn',3);
		addLuaSprite('bomburn',true);
		objectPlayAnimation('bomburn','fall',false);
		scaleObject('bomburn',0.5,0.5);
		playSound('fall',1,'fall');
		runTimer('fallSpace', 1)
		runTimer('fall',1);
		end

	if name == "boomnodisarm" then
		--setting
		removeLuaSprite('bomb1',true);
		cancelTimer('bomb1');
		playSound('beep',1,'beep');
		makeAnimatedLuaSprite('bomb1','bomb',getRandomInt(50,1000),getRandomInt(50,300));
		addLuaSprite('bomb1',true);
		setObjectCamera('bomb1','other');
		addAnimationByPrefix('bomb1','appear1','bomb anim',24,false);
		objectPlayAnimation('bomb1','bomb',false);
		setObjectOrder('bomb1',2);

		--actually use the bomb
		runTimer('bomb1',2);
	elseif name == "burnnodisarm" then
		makeAnimatedLuaSprite('bomburn1','burn',getRandomInt(50,1000),-415);
		setObjectCamera('bomburn1','other');
		addAnimationByPrefix('bomburn1','fall','burnfall',24,false);
		setObjectOrder('bomburn1',3);
		addLuaSprite('bomburn1',true);
		objectPlayAnimation('bomburn1','fall',false);
		scaleObject('bomburn1',0.5,0.5);
		playSound('fall',1,'fall');
		runTimer('fall1',1);
		end
	end
end

function onTimerCompleted(name)
	if name == 'bomb1' then
		runHaxeCode([[
                   FlxTween.tween(game, {health: game.health - 0.25}, 0.15, {ease: FlxEase.circInOut});
                ]])
		removeLuaSprite('bomb1',true);
		cameraFlash('hud','FF6600',1,true);
		playSound('boom',1,'boom');
	end
        if name == 'fall1' then
		playSound('boom',1,'boom');
		cameraFlash('hud','FF0000',2,true);
		removeLuaSprite('bomburn1',true);
		setProperty('healthDrain', getProperty('healthDrain') + 0.0015);
	end
	if name == 'fallSpace' then
		playSound('boom',1,'boom');
		cameraFlash('hud','FF0000',0.5,true);
		removeLuaSprite('bomburn',true);
	end
        if name == 'fall' then
		playSound('boom',1,'boom');
		cameraFlash('hud','FF0000',2,true);
		removeLuaSprite('bomburn',true);
		setProperty('healthDrain', getProperty('healthDrain') + 0.0026);
	end
        if name == 'bomb' then
		runHaxeCode([[
                   FlxTween.tween(game, {health: game.health - 0.8}, 0.15, {ease: FlxEase.circInOut});
                ]])
		removeLuaSprite('bomb',true);
		cameraFlash('hud','FF6600',1,true);
		playSound('boom',1,'boom');
	end
end

function onCreate()
       if mechanics then
           setTextString('botplayTxt', '. . .')
           setTextColor('botplayTxt', 'FF0000')
       end
end

function onUpdate()
    if mechanics then
	if keyJustPressed('key5') and getProperty('bomb.x') ~= 'bomb.x' then
		removeLuaSprite('bomb',true);
		cancelTimer('bomb');
		stopSound('beep');
		playSound('disarmed',1,'disarmed');
		cameraFlash('hud','FFFFFF',0.2,true);
	end

	if keyJustPressed('key5') and getProperty('bomburn.x') ~= 'bomburn.x' then
		cancelTimer('fall');
	end

	if keyJustPressed('key5') and getProperty('bomb1.x') ~= 'bomb1.x' then
                playSound('cancelMenu', 0.6)
	end

	if keyJustPressed('key5') and getProperty('bomburn1.x') ~= 'bomburn1.x' then
                playSound('cancelMenu', 0.6)
	end

        if not isFlippy then
           if getProperty('health') > 2 and getProperty('health') < 1 then
              oppoMissHealth(true, 0.2, -0.023)
           elseif getProperty('health') > 1 and getProperty('health') < 0.75 then
              oppoMissHealth(true, 0.2, -0.02)
           elseif getProperty('health') > 0.75 and getProperty('health') < 0.5 then
              oppoMissHealth(true, 0.2, -0.015)
           elseif getProperty('health') > 0.5 and getProperty('health') < 0.25 then
              oppoMissHealth(true, 0.2, -0.01)
           elseif getProperty('health') > 0.25 and getProperty('health') < 0.2 then
              oppoMissHealth(true, 0.2, -0.005)
           end
        end

        if botPlay then
          function onStepHit()
           if curStep > 1 then
             runHaxeCode([[
                FlxTween.tween(game, {health: game.health + 0.2}, 1, {ease: FlxEase.circInOut});
             ]])
           end
        end
       end
   end
end

function onStepHit()
  if mechanics then
   if curStep == 316 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
   if curStep == 2143 then
      isFlippy = true
      oppoMissHealth(false, 0, 0)
   end
   if curStep == 2239 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
   if curStep == 2271 then
      isFlippy = true
      oppoMissHealth(false, 0, 0)
   end
   if curStep == 2303 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
   if curStep == 2872 then
      isFlippy = true
      oppoMissHealth(false, 0, 0)
   end
   if curStep == 3007 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
   if curStep == 3736 then
      isFlippy = true
      oppoMissHealth(false, 0, 0)
   end
   if curStep == 3775 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
   if curStep == 3869 then
      isFlippy = true
      oppoMissHealth(false, 0, 0)
   end
   if curStep == 3903 then
      isFlippy = false
      oppoMissHealth(true, 0.2, -0.02)
   end
  end
end