function opponentNoteHit()
{
    if(ClientPrefs.mechanics) {
        PlayState.oppoMissHealth = true;
        PlayState.healthOppo = 0.2;
        PlayState.oppoHMiss = -0.035;
    }
}

function onStepHit()
{
    switch(curStep)
    {
        case 128:
            fadeDadStrum(0, 1);
            fadeBfStrum(0, 1);
            fadeItems(3, 0, 1);
        case 384:
            fadeDadStrum(0.9, 1);
            fadeBfStrum(0.9, 1);
            fadeItems(3, 1, 1);
        case 896:
            fadeItems(1, 0, 1);
        case 1152:
            fadeItems(1, 1, 1);
        case 1664:
            fadeItems(2, 0, 1);
        case 1920:
            fadeItems(2, 1, 1);
        case 2464:
            fadeDadStrum(0, 1);
            fadeBfStrum(0, 1);
            fadeItems(5, 0, 1);
        case 2560:
            fadeDadStrum(1, 1);
            fadeBfStrum(1, 1);
            fadeItems(5, 1, 0.1);
        case 3072:
            fadeItems(1, 0, 1);
        case 3584:
            fadeItems(3, 0, 1);
        case 3968:
            fadeDadStrum(0, 1);
            fadeBfStrum(0, 1);
    }
}

//I knwo, this a wednes infidelt refermdsf

function fadeDadStrum(alph, time)
{
	PlayState.opponentStrums.forEach(function(spr)
	{
		FlxTween.tween(spr, {alpha: alph}, time);
	});
}

function fadeBfStrum(alph, time)
{
	PlayState.playerStrums.forEach(function(spr)
	{
		FlxTween.tween(spr, {alpha: alph}, time);
	});
}

function fadeItems(lol, huh, duration)
{
    if(!ClientPrefs.hideHud) 
    {
        if(lol == 1) {
            FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
        }
        if(lol == 2) {
            FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
        }
        if(lol == 3) {
            FlxTween.tween(PlayState.healthBar, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.healthBarBG, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.healthBarBG2, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.iconP1, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.iconP2, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
        }
        if(lol == 4) {
            FlxTween.tween(PlayState.timeBarBG, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeBar, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.timeTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
        }
        if(lol == 5) {
            FlxTween.tween(PlayState.healthBar, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.healthBarBG, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.healthBarBG2, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.iconP1, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.iconP2, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.scoreTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.sicksTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.goodsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.badsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.shitsTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.missesTxt, {alpha: huh}, duration, {ease: FlxEase.linear});
        }
    }
}