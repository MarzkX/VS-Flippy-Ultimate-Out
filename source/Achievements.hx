import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import GameJolt;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement, GJ ID
		["THX For Playing!",	"Thanks for download and play this mod!",	'thanks',		true,    207407, '#A76B43'],
        ["Guerrilla's",                 "Play any \"-Guerrilla\" song.",        'guerrilla',            false,   207394, '#9FD6E7'],
		["RUMBLING!!",			"Unlock a Secret Song.",	        'rumb',			true,    207395,  '#A7E2A1'],
		["Two Trucks having ...",       "Unlock a Funny Song.",                'funni',                true,    207396,  '#A7E2A1'],
		["Fallen Soldier...",		"Beat Main Week with no Misses.",	'week1_nomiss',		false,   207390,  '#FFC400'],
		["I'll kill you anyway.",	"Beat Alt Week with no Misses.",	'week2_nomiss',		false,   207391,  '#FFC400'],
		["MINUS!",			"Beat Bonus Week with no Misses.",      'week3_nomiss',		false,   207393,  '#FFC400'],
		["Good Job!",			"Beat any Song with 100% Accuracy.",    'perfect',		false,   207413,  '#FFC400'],
		["Killed Madness...",		"Beat a \"Overkill\" on Expert.",	'overkill_expert',	false,   207410,  '#FF0000']
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		//FlxG.sound.play(Paths.sound('unlock'), 0.7);

		var ID:Int = 0;

		for (i in 0...achievementsStuff.length)
		{
			if (achievementsStuff[i][2] == name)
			{
				ID = i;
			}
		}
		
		if(FlxG.save.data != null) {
			if(!GameJoltAPI.checkTrophy(achievementsStuff[ID][4]))
			{
				GameJoltAPI.getTrophy(achievementsStuff[ID][4]);
				ClientPrefs.trophiesAchieved++;
				Main.gjToastManager.createToast("awards/" + achievementsStuff[ID][2], achievementsStuff[ID][0], achievementsStuff[ID][1], true, achievementsStuff[ID][5]);
				FlxG.save.flush();
			}
		}
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
		}
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image(name, 'achievements'));
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		/*add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);
*/
		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}