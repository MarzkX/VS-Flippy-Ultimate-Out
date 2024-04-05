function onStepHit()
{
    switch(curStep)
    {
        case 64:
            fadeDadStrum(0, 1);
            fadeBfStrum(0, 1);
            fadeItems(3, 0, 1);
        case 288:
            fadeDadStrum(1, 1);
            fadeBfStrum(1, 1);
            fadeItems(3, 1, 1);
        case 576:
            fadeItems(1, 0, 1);
        case 800:
            fadeItems(1, 1, 1);
        case 1660:
            fadeItems(3, 0, 1);
        case 1840:
            fadeItems(3, 1, 1);
        case 2752:
            fadeDadStrum(0, 1);
            fadeBfStrum(0, 1);
            fadeItems(3, 0, 1);
        case 2864:
            fadeDadStrum(1, 1.7);
        case 2992:
            fadeBfStrum(1, 1.7);
        case 3008:
            fadeItems(3, 1, 1);
        case 3520:
            fadeItems(1, 0, 1);
        case 3632:
            fadeItems(1, 1, 1.5);
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

function fadeItems(lol, alph, duration)
{
    if(lol == 1) {
        FlxTween.tween(PlayState.scoreTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.sicksTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.goodsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.badsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.shitsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.missesTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeBarBG, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeBar, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
    }
    if(lol == 2) {
        FlxTween.tween(PlayState.scoreTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.sicksTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.goodsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.badsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.shitsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.missesTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
    }
    if(lol == 3) {
        FlxTween.tween(PlayState.healthBar, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.healthBarBG, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.healthBarBG2, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.iconP1, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.iconP2, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.scoreTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.sicksTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.goodsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.badsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.shitsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.missesTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeBarBG, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeBar, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
    }
    if(lol == 4) {
        FlxTween.tween(PlayState.timeBarBG, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeBar, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.timeTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
    }
    if(lol == 5) {
        FlxTween.tween(PlayState.healthBar, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.healthBarBG, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.healthBarBG2, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.iconP1, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.iconP2, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.scoreTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.sicksTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.goodsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.badsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.shitsTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
        FlxTween.tween(PlayState.missesTxt, {alpha: alph}, duration, {ease: FlxEase.linear});
    }
}