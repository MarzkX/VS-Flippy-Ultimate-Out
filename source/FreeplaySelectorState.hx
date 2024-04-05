package;

import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import haxe.Json;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.graphics.FlxGraphic;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import Shaders.WhiteOverlayShader;

using StringTools;

typedef FSConfig = {
	item1X:Float,
	item2X:Float
}

class FreeplaySelectorState extends MusicBeatState
{
	public static var curSelected:Int = 0;
	
	public static var weeks:Array<Array<String>> = [
		["week1", "week2", "week3"],
		["weekG", "weekK"],
		["kapow", "alt", "bonus"]
	];

	var select:Array<String> = [
		'story',
		'guerrilla',
		'extras'
	];

	var bgs:Array<String> = [
		'bloody-bg',
		'fearful-bg',
		'shanked-bg'
	];

	var jsonFile:FSConfig;

	var bg1:FlxSprite;
	var bg2:FlxSprite;
	var bg3:FlxSprite;
	var swagItems:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		Application.current.window.title = Main.appTitle + ' - ' + 'Freeplay Selector';

		if (!FlxG.sound.music.playing || FreeplayState.songPlayFuck) {
			FreeplayState.songPlayFuck = false;
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Selector", null);
		#end

		jsonFile = Json.parse(Paths.getTextFromFile('images/freeplay/select/config.json'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg1 = new FlxSprite().loadGraphic(Paths.freeImage('fallen-soldier/' + bgs[0]));
		bg1.updateHitbox();
		bg1.screenCenter();
		bg1.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg1);

		bg2 = new FlxSprite().loadGraphic(Paths.freeImage('fallen-soldier/' + bgs[1]));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.alpha = 0;
		add(bg2);

		bg3 = new FlxSprite().loadGraphic(Paths.freeImage('fallen-soldier/' + bgs[2]));
		bg3.updateHitbox();
		bg3.screenCenter();
		bg3.antialiasing = ClientPrefs.globalAntialiasing;
		bg3.alpha = 0;
		add(bg3);

		swagItems = new FlxTypedGroup<FlxSprite>();
		add(swagItems);

		var swagItem:FlxSprite = new FlxSprite().loadGraphic(Paths.freeImage('select/' + select[0]));
		swagItem.x = jsonFile.item1X;
		swagItem.ID = 0;
		swagItem.antialiasing = ClientPrefs.globalAntialiasing;
		swagItem.updateHitbox();
		swagItem.screenCenter(Y);
		swagItem.shader = new WhiteOverlayShader();
		swagItems.add(swagItem);

		var swagItem:FlxSprite = new FlxSprite().loadGraphic(Paths.freeImage('select/' + select[1]));
		swagItem.ID = 1;
		swagItem.antialiasing = ClientPrefs.globalAntialiasing;
		swagItem.updateHitbox();
		swagItem.screenCenter();
		swagItem.shader = new WhiteOverlayShader();
		swagItems.add(swagItem);

		var swagItem:FlxSprite = new FlxSprite(10).loadGraphic(Paths.freeImage('select/' + select[2]));
		swagItem.x = jsonFile.item2X;
		swagItem.ID = 2;
		swagItem.antialiasing = ClientPrefs.globalAntialiasing;
		swagItem.updateHitbox();
		swagItem.screenCenter(Y);
		swagItem.shader = new WhiteOverlayShader();
		swagItems.add(swagItem);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.sound.music.stop();
                Application.current.window.title = Main.appTitle;
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				enterItem();
			}
		}

		super.update(elapsed);
	}

	var bg1Tween:FlxTween;
	var bg2Tween:FlxTween;
	var bg3Tween:FlxTween;

	function bgChangeLol(huh:Int)
	{
		if(bg1Tween != null)
			bg1Tween.cancel();

		if(bg2Tween != null)
			bg2Tween.cancel();

		if(bg3Tween != null)
			bg3Tween.cancel();

		if(huh == 0) {
			bg1Tween = FlxTween.tween(bg1, {alpha: 1}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(e:FlxTween)
				{
					bg1Tween = null;
				}
			});

			bg2Tween = FlxTween.tween(bg2, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg2Tween = null;
				}
			});

			bg3Tween = FlxTween.tween(bg3, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg3Tween = null;
				}
			});
		} else if(huh == 1) {
			bg1Tween = FlxTween.tween(bg1, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(e:FlxTween)
				{
					bg1Tween = null;
				}
			});

			bg2Tween = FlxTween.tween(bg2, {alpha: 1}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg2Tween = null;
				}
			});

			bg3Tween = FlxTween.tween(bg3, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg3Tween = null;
				}
			});
		} else if(huh == 2) {
			bg1Tween = FlxTween.tween(bg1, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(e:FlxTween)
				{
					bg1Tween = null;
				}
			});

			bg2Tween = FlxTween.tween(bg2, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg2Tween = null;
				}
			});

			bg3Tween = FlxTween.tween(bg3, {alpha: 1}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(t:FlxTween)
				{
					bg2Tween = null;
				}
			});
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= 3)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 3 - 1;

		FreeplayState.freeplaySelect = curSelected;

		bgChangeLol(curSelected);

		swagItems.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 0.6;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.alpha = 1;
				spr.centerOffsets();
			}
		});
	}

	function enterItem()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxG.sound.music.fadeOut(1, 0, function(_:FlxTween)
		{
			FlxG.sound.music.stop();
		});
		Application.current.window.title = Main.appTitle;

		swagItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.3, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween) {
						spr.kill();
					}
				});
			}
			else
			{
				spr.shader.data.progress.value = [1.0];
				FlxTween.num(1.0, 0.0, 1.0, {ease: FlxEase.cubeOut}, function(num:Float)
				{
					spr.shader.data.progress.value = [num];
				});
			}
		});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			MusicBeatState.switchState(new FreeplayState(weeks[curSelected]));
		});
	}
}
