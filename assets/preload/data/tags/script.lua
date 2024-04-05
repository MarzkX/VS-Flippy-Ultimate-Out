function onSongStart()
   setProperty('songLength', 15 * 1000)
end

function onStepHit()
   if curStep == 108 then
      runHaxeCode([[
         FlxTween.tween(game, {songLength: FlxG.sound.music.length}, 2, {ease: FlxEase.cubeInOut});
      ]])
   end
end