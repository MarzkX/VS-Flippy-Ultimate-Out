function onStepHit()
{
    if (curStep == 304) {
        FlxTween.tween(PlayState, {songLength: FlxG.sound.music.length}, 2, {ease: FlxEase.cubeInOut});
    }
}