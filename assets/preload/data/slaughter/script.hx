var curSection = 0;
var stepDev = 0;

function onStepHit()
{
    if (curStep % 16 == 0)
	{
		curSection = Math.floor(curStep / 16);
	}

	stepDev = Math.floor(curStep % 16) + 1;

    if (curSection >= 32 && curSection <= 47 || curSection >= 96 && curSection <= 110 || curSection >= 127 && curSection <= 159)
	{
		if (curStep % 8 == 0)
			addCamZoom(0.015, 0.03);
	}
    if (curSection >= 48 && curSection <= 63 || curSection >= 88 && curSection <= 95 || curSection >= 112 && curSection <= 127)
    {
        if (curStep % 16 == 0)
            addCamZoom(0.015, 0.03);
    }
}

function addCamZoom(game, hud)
{
	PlayState.camGame.zoom += game;
	PlayState.camHUD.zoom += hud;
}