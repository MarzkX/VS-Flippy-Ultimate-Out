function opponentNoteHit()
{
    if(ClientPrefs.shaking) {
        FlxG.camera.shake(0.0015, 0.2);
        PlayState.camHUD.shake(0.001, 0.2);
    }
}