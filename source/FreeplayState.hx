package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	public static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var songTimer:FlxTimer;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	public static var songPlayFuck:Bool = false;

	var leText:String;

	private var iconArray:Array<HealthIcon> = [];
	var icon:HealthIcon;
	var fbg:FlxSprite;
	var fg:FlxSprite;
	var discBG:FlxSprite;
	var resetKey:String;
	var weekFile:WeekFile = null;
	var bgTween:FlxTween;
	var text:FlxText;
	var backspace:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	public static var freeplaySelect:Int;
	var weeks:Null<Array<String>>;

	public function new(?newWeeks:Null<Array<String>>)
	{
		super();

		if (newWeeks != null)
			weeks = newWeeks;
	}

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();

		if (weeks == null)
			weeks = WeekData.weeksList;
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...weeks.length) {
			if (weekIsLocked(weeks[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(weeks[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				switch (song[0])
				{
					default:
						addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), song[3]);
				}
			}
		}
		WeekData.loadTheFirstEnabledMod();
		fbg = new FlxSprite().loadGraphic(Paths.image('freeplay/fallen-soldier/og-bg'));
		fbg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fbg);

		fg = new FlxSprite().loadGraphic(Paths.image('freeplay/fallen-soldier/og-fg'));
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fg);

		var gradient:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/gradient'));
		gradient.setGraphicSize(FlxG.width, FlxG.height);
		gradient.antialiasing = ClientPrefs.globalAntialiasing;
		add(gradient);

		var sideBlack:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/menuSide'));
		sideBlack.antialiasing = ClientPrefs.globalAntialiasing;
		add(sideBlack);

		discBG = new FlxSprite().makeGraphic(295, 295);
		discBG.scrollFactor.set();
		add(discBG);

		var disc:FlxSprite = new FlxSprite();
		disc.frames = Paths.getSparrowAtlas('freeplay/disc');
		disc.animation.addByPrefix('disc', 'disc', 24, true);
		disc.animation.play('disc');
		disc.antialiasing = ClientPrefs.globalAntialiasing;
		disc.scrollFactor.set();
		add(disc);

		discBG.x = disc.x + 25;
		discBG.y = disc.y + 25;

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		genSongs();

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 50, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.alpha = 0;
		add(diffText);

		add(scoreText);

		if (curSelected >= songs.length)
			curSelected = 0;
		discBG.color = songs[curSelected].color;
		intendedColor = discBG.color;

		if (lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		leText = "Press CTRL to open the Gameplay Changers Menu";

		var size:Int = 16;
		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		text.screenCenter(X);
		add(text);
		super.create();
	}
	
	function genSongs()
	{
		for (i in 0...songs.length)
		{
			if (grpSongs.members[i] != null)
				return;

			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, art:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, art));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	function checkKey(s)
	{
		return !(s != null && s != '---');
	}
		
	function getKey(t)
	{
		var s = InputFormatter.getKeyName(t);
		
		return checkKey(s) ? '' : s;
	}

	function flipHardy() {
		if(songs[curSelected].art != null)
		{
			fbg.loadGraphic(Paths.image('freeplay/fallen-soldier/' + songs[curSelected].art + '-bg'));
			fg.loadGraphic(Paths.image('freeplay/fallen-soldier/' + songs[curSelected].art + '-fg'));
		}
		else
		{
			fbg.loadGraphic(Paths.image('freeplay/default'));
			fg.loadGraphic(Paths.image('freeplay/default'));
		}

		if(bgTween != null) {
			bgTween.cancel();
		}

		bgTween = FlxTween.tween(fg, {x: 0}, 0.3, {ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				bgTween = null;
				fbg.y = 0;
			}
		});
	}

	var instPlaying:Int = -1;
	var artsDiff:Bool = false;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		
		lime.app.Application.current.window.title = Main.appTitle + ' - ' + 'Freeplay' + ' - ' + songs[curSelected].songName;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if(FlxG.keys.justPressed.T)
			artsDiff = true;
		else if(FlxG.keys.justPressed.Y)
			artsDiff = false;

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new FreeplaySelectorState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (accepted)
		{
			persistentUpdate = false;

			for (song in grpSongs)
			{
				if (song.targetY == 0)
					continue;

				FlxTween.tween(song, {alpha: 0}, 0.1);
			}

			for (icon in iconArray)
			{
				if (iconArray.indexOf(icon) == curSelected)
					continue;

				FlxTween.tween(icon, {alpha: 0}, 0.1);
			}

			new FlxTimer().start(0.1, function(_:FlxTimer)
			{
				if(shiftMult == 3)
					selectSong(false);
				else
					selectSong(true);
			});
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {/*lol*/}

	public function selectSong(?playstate:Bool = true, ?story:Bool = false)
	{
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = story;
		PlayState.storyDifficulty = curDifficulty;

		if (colorTween != null)
		{
			colorTween.cancel();
		}

		lime.app.Application.current.window.title = Main.appTitle;

		FlxG.sound.music.volume = 0;

		songPlayFuck = false;

		destroyFreeplayVocals();

		if (playstate)
			LoadingState.loadAndSwitchState(new PlayState());
		else
			MusicBeatState.switchState(new ChartingState());
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	static var diffTween:FlxTween;

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(discBG, 1, discBG.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		fg.x = 100;

		songPlayFuck = false;

		flipHardy();

		if(freeplaySelect == 0)
		{
			if(curSelected == 2)
			{
				if(diffTween != null)
					diffTween.cancel();

				diffTween = FlxTween.tween(diffText, {alpha: 1}, 0.2, {
					ease: FlxEase.cubeOut,
					onComplete: function(t:FlxTween)
					{
						diffTween = null;
					}
				});
			}
			else
			{
				if(diffTween != null)
					diffTween.cancel();

				diffTween = FlxTween.tween(diffText, {alpha: 0}, 0.2, {
					ease: FlxEase.cubeOut,
					onComplete: function(t:FlxTween)
					{
						diffTween = null;
					}
				});
			}
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		if (FlxG.sound.music.playing)
		{
			FlxG.sound.music.stop();
		}
		if (songTimer != null)
		{
			songTimer.cancel();
			songTimer.destroy();
		}
		songTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			if (FlxG.sound.music.playing)
			{
				FlxG.sound.music.stop();
			}
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			songPlayFuck = true;
			Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase()).bpm);
		}, 1);
		#else
		Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase()).bpm);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
			iconArray[i].animation.play("idle");
		}

		iconArray[curSelected].alpha = 1;
		iconArray[curSelected].animation.play("winning");

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if(ClientPrefs.camZooms)
		{
			FlxG.camera.zoom += 0.015;
			FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var art:String = "";
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int, art:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.art = art;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}