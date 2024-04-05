function onStepHit()
{
    if(curStep == 384)
    {
        PlayState.boyfriendCameraOffset = [-100, 0];
        PlayState.opponentCameraOffset = [100, 0];
        FlxTween.tween(Main.fpsVar, {alpha: 0.6}, 1, {ease: FlxEase.circInOut});
        fadeItems(1, 0, 0.1);
    }
    if(curStep == 496)
    {
        FlxTween.tween(Main.fpsVar, {alpha: 1}, 1, {ease: FlxEase.circInOut});
        fadeItems(1, 1, 0.1);
    }
    if(curStep == 512)
    {
        PlayState.boyfriendCameraOffset = [0, 0];
        PlayState.opponentCameraOffset = [0, 0];
    }
}

function onSongStart() {
    Main.fpsVar.alpha = 1;
}

function fadeItems(lol, huh, duration)
{
    if(lol == 1) {
        FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
    }
    if(lol == 2) {
        FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
    }
    if(lol == 3) {
        FlxTween.tween(PlayState.healthBar, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.healthBarBG, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.healthBarBG2, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.iconP1, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.iconP2, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
    }
    if(lol == 4) {
        FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
        FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.expoInOut});
    }
}