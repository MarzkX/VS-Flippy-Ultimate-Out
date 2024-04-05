package;

// GameJolt things
import lime.app.Application;
import haxe.io.Path;
import lime.media.FlashAudioContext;
import flixel.addons.ui.FlxUIState;
import tentools.api.FlxGameJolt as GJApi;

// Login things
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import haxe.Json;

// Toast things
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.Lib;
import flixel.FlxG;
import openfl.display.Sprite;

using StringTools;

class GameJoltAPI // Connects to tentools.api.FlxGameJolt
{
    /**
     * Inline variable to see if the user has logged in.
     * True for logged in, false for not logged in.
     */
    public static var userLogin:Bool = false; //For User Login Achievement (Like IC)
    /**
     * Grabs user data and returns as a string, true for Username, false for Token
     * @param username Bool value
     * @return String 
     */

     public static var leaderboardToggle:Bool;

    public static function getUserInfo(username:Bool = true):String
    {
        if(username)return GJApi.username;
        else return GJApi.usertoken;
    }

    /**
     * Returns the user login status
     * @return Bool
     */
    public static function getStatus():Bool
    {
        return userLogin;
    }

    /**
     * Sets the game API key from GJKeys.api
     * Doesn't return anything
     */
    public static function connect() 
    {
        trace("Grabbing API keys...");
        GJApi.init(Std.int(GJKeys.id), Std.string(GJKeys.key), function(data:Bool){
            #if debug
            Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Game " + (data ? "authenticated!" : "not authenticated..."), (!data ? "If you are a developer, check GJKeys.hx\nMake sure the id and key are formatted correctly!" : "Yay!"), false);
            #end
        });
    }

    /**
     * Inline function to auth the user. Shouldn't be used outside of GameJoltAPI things.
     * @param in1 username
     * @param in2 token
     * @param loginArg Used in only GameJoltLogin
     */
    public static function authDaUser(in1, in2, ?loginArg:Bool = false)
    {
        if(!userLogin)
        {
            GJApi.authUser(in1, in2, function(v:Bool)
            {
                trace("user: "+(in1 == "" ? "n/a" : in1));
                trace("token: "+in2);
                if(v)
                    {
                        Main.gjToastManager.createToast(GameJoltInfo.imagePath, in1 + " SIGNED IN!", "CONNECTED TO GAMEJOLT", false);
                        trace("User authenticated!");
                    
                        if(ClientPrefs.gjUser != null)
                            ClientPrefs.gjUser = in1;
    
                        if(ClientPrefs.gjToken != null)
                            ClientPrefs.gjToken = in2;
                        
                        userLogin = true;
                        startSession();
                        if(loginArg)
                        {
                            GameJoltLogin.login=true;
                            MusicBeatState.switchState(new GameJoltLogin());
                        }
                    }
                else 
                    {
                        if(loginArg)
                        {
                            GameJoltLogin.login=true;
                            MusicBeatState.switchState(new GameJoltLogin());
                        }
                        Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Not signed in!\nSign in to save GameJolt Trophies!", "", false);
                        trace("User login failure!");
                        // MusicBeatState.switchState(new GameJoltLogin());
                    }
            });
        }
    }
    
    /**
     * Inline function to deauth the user, shouldn't be used out of GameJoltLogin state!
     * @return  Logs the user out and closes the game
     */
    public static function deAuthDaUser()
    {
        closeSession();
        userLogin = false;

        if(FlxG.save.data != null)
        {
            FlxG.save.data.gjUser = null;
            FlxG.save.data.gjToken = null;

            ClientPrefs.gjUser = "";
            ClientPrefs.gjToken = "";

            FlxG.save.flush();

            trace(FlxG.save.data.gjUser);
            trace(FlxG.save.data.gjToken);
        }

        trace("Logged out!");

        TitleState.restart();
    }

    /**
     * Give a trophy!
     * @param trophyID Trophy ID. Check your game's API settings for trophy IDs.
     */
    public static function getTrophy(trophyID:Int) /* Awards a trophy to the user! */
    {
        if(userLogin)
        {
            GJApi.addTrophy(trophyID, function(data:Map<String,String>){
                trace(data);
                var bool:Bool = false;
                if (data.exists("message"))
                    bool = true;
            });
        }
    }

    /**
     * Checks a trophy to see if it was collected
     * @param id TrophyID
     * @return Bool (True for achieved, false for unachieved)
     */
    public static function checkTrophy(id:Int):Bool
    {
        var value:Bool = false;
        GJApi.fetchTrophy(id, function(data:Map<String, String>)
            {
                trace(data);
                if (data.get("achieved").toString() != "false")
                    value = true;
                trace(id+""+value);
            });
        return value;
    }

    public static function pullTrophy(?id:Int):Map<String,String>
    {
        var returnable:Map<String,String> = null;
        GJApi.fetchTrophy(id, function(data:Map<String,String>){
            trace(data);
            returnable = data;
        });
        return returnable;
    }

    public static function addScore(score:Int, tableID:Int, ?extraData:String)
    {
        if (GameJoltAPI.leaderboardToggle)
        {
            trace("Trying to add a score");
            var formData:String = extraData.split(" ").join("%20");
            GJApi.addScore(score+"%20Points", score, tableID, false, null, formData, function(data:Map<String, String>){
                trace("Score submitted with a result of: " + data.get("success"));
                Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Score submitted!", "Score: " + score + "\nExtra Data: "+extraData, true);
            });
        }
        else
        {
            Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Score not submitted!", "Score: " + score + "Extra Data: " +extraData+"\nScore was not submitted due to score submitting being disabled!", true);
        }
    }

    /**
     * Return the highest score from a table!
     * 
     * Usable by pulling the data from the map by [function].get();
     * 
     * Values returned in the map: score, sort, user_id, user, extra_data, stored, guest, success
     * 
     * @param tableID The table you want to pull from
     * @return Map<String,String>
     */
    public static function pullHighScore(tableID:Int):Map<String,String>
    {
        var returnable:Map<String,String>;
        GJApi.fetchScore(tableID,1, function(data:Map<String,String>){
            trace(data);
            returnable = data;
        });
        return returnable;
    }

    /**
     * Inline function to start the session. Shouldn't be used out of GameJoltAPI
     * Starts the session
     */
    public static function startSession()
    {
        GJApi.openSession(function()
            {
                trace("Session started!");
                new FlxTimer().start(20, function(tmr:FlxTimer){pingSession();}, 0);
            });
    }

    /**
     * Tells GameJolt that you are still active!
     * Called every 20 seconds by a loop in startSession().
     */
    public static function pingSession()
    {
        GJApi.pingSession(true, function(){trace("Ping!");});
    }

    /**
     * Closes the session, used for signing out
     */
    public static function closeSession()
    {
        GJApi.closeSession(function(){trace('Closed out the session');});
    }
}

class GameJoltInfo extends MusicBeatSubstate
{    
    /**
     * Variable to change which state to go to by hitting ESCAPE or the CONTINUE buttons.
     */
    public static var changeState:FlxUIState = new MainMenuState();
    /**
    * Inline variable to change the font for the GameJolt API elements.
    * @param font You can change the font by doing **Paths.font([Name of your font file])** or by listing your file path.
    * If *null*, will default to the normal font.
    */
    public static var font:String = null; /* Example: Paths.font("vcr.ttf"); */
    /**
    * Inline variable to change the font for the notifications made by Firubii.
    * 
    * Don't make it a NULL variable. Worst mistake of my life.
    */
    public static var fontPath:String = "assets/fonts/Bronx.otf";
    /**
    * Image to show for notifications. Leave NULL for no image, it's all good :)
    * 
    * Example: Paths.getLibraryPath("images/stepmania-icon.png")
    */
    public static var imagePath:String = 'gamejolt/user'; 

    /* Other things that shouldn't be messed with are below this line! */

    /**
    * GameJolt + FNF version.
    */
    public static var version:String = "1.1";
    /**
     * Random quotes I got from other people. Nothing more, nothing less. Just for funny.
     */
}

typedef GJConfig =
{
    userTX:Float,
    userTY:Float,
    tokenTX:Float,
    tokenTY:Float,
    userBX:Float,
    userBY:Float,
    tokenBX:Float,
    tokenBY:Float,
    userBW:Int,
    tokenBW:Int
}

class GameJoltLogin extends MusicBeatState
{
    var bg:FlxSprite;
    var loginTexts:FlxTypedGroup<FlxText>;
    var loginBoxes:FlxTypedGroup<FlxUIInputText>;
    var loginButtons:FlxTypedGroup<FlxButton>;
    var usernameText:FlxText;
    var tokenText:FlxText;
    var usernameBox:FlxUIInputText;
    var tokenBox:FlxUIInputText;
    var signInBox:FlxButton;
    var helpBox:FlxButton;
    var trophiesBox:FlxButton;
    var logOutBox:FlxButton;
    var cancelBox:FlxButton;
    var continueBox:FlxButton;
    var username1:FlxText;
    var username2:FlxText;
    var colorTween:FlxTween;
    var baseX:Int = 0;
    var baseXX:Int = -100;
    var trophies:FlxText;
    var configJSON:GJConfig;
    public static var login:Bool = false;
    override function create()
    {
        if (FlxG.save.data.lbToggle != null)
        {
            GameJoltAPI.leaderboardToggle = FlxG.save.data.lbToggle;
        }

        trace(GJApi.initialized);

        FlxG.mouse.visible = true;

        Application.current.window.title = Main.appTitle + ' - GameJolt Menu';

        bg = new FlxSprite().loadGraphic(Paths.image('gamejolt/bg'));
		bg.setGraphicSize(FlxG.width);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set();
        bg.color = 0xFF1EFF00;
		add(bg);

        if(ClientPrefs.flashing)
            tweenShit();

        var gjIcon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('gamejolt/stuff'));
        gjIcon.updateHitbox();
        gjIcon.setGraphicSize(FlxG.width);
        gjIcon.antialiasing = ClientPrefs.globalAntialiasing;
        gjIcon.scrollFactor.set();
        gjIcon.screenCenter();
        add(gjIcon);

        configJSON = Json.parse(Paths.getTextFromFile('images/gamejolt/config.json'));

        var blackBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('gamejolt/blackbg'));
        blackBG.alpha = 0.6;
        blackBG.updateHitbox();
        blackBG.screenCenter();
        blackBG.antialiasing = ClientPrefs.globalAntialiasing;
        blackBG.scrollFactor.set();
        add(blackBG);

        loginTexts = new FlxTypedGroup<FlxText>(2);
        add(loginTexts);

        usernameText = new FlxText(0, 200, 300, "Username:", 20);

        tokenText = new FlxText(0, 300, 300, "Token:", 20);

        loginTexts.add(usernameText);
        loginTexts.add(tokenText);
        loginTexts.forEach(function(item:FlxText){
            item.screenCenter(X);
            item.x += baseXX;
            item.font = GameJoltInfo.font;
        });

        loginBoxes = new FlxTypedGroup<FlxUIInputText>(2);
        add(loginBoxes);

        var text1BG:FlxSprite = new FlxSprite(250, 240).makeGraphic(500, 45, FlxColor.BLACK);
        text1BG.alpha = 0.6;
        text1BG.updateHitbox();
        text1BG.scrollFactor.set();
        text1BG.screenCenter(X);
        text1BG.x += baseX;
        text1BG.antialiasing = ClientPrefs.globalAntialiasing;
        add(text1BG);

        var text2BG:FlxSprite = new FlxSprite(250, 340).makeGraphic(500, 45, FlxColor.BLACK);
        text2BG.alpha = 0.6;
        text2BG.updateHitbox();
        text2BG.scrollFactor.set();
        text2BG.screenCenter(X);
        text2BG.x += baseX;
        text2BG.antialiasing = ClientPrefs.globalAntialiasing;
        add(text2BG);

        usernameBox = new FlxUIInputText(250, 240, 500, null, 32, FlxColor.WHITE, FlxColor.BLACK);
        tokenBox = new FlxUIInputText(250, 340, 500, null, 32, FlxColor.WHITE, FlxColor.BLACK);

        loginBoxes.add(usernameBox);
        loginBoxes.add(tokenBox);
        loginBoxes.forEach(function(item:FlxUIInputText){
            item.screenCenter(X);
            item.x += baseX;
            item.font = GameJoltInfo.font;
        });

        var whatMenu:FlxText = new FlxText(550, 135, 500, "Log In Menu", 20);
        whatMenu.scrollFactor.set();
        whatMenu.font = GameJoltInfo.font;
        whatMenu.updateHitbox();
        whatMenu.antialiasing = ClientPrefs.globalAntialiasing;
        add(whatMenu);

        GameJoltAPI.checkTrophy(207407);

        if(FlxG.save.data.noAchieved != null)
        {
            if(GameJoltAPI.checkTrophy(207407))
                FlxG.save.data.noAchieved = true;
            else
                FlxG.save.data.noAchieved = false;
        }

        if(GameJoltAPI.getStatus())
        {
            remove(text1BG);
            remove(text2BG);
            remove(loginTexts);
            remove(loginBoxes);
            remove(whatMenu);
        }

        var user:FlxSprite = new FlxSprite().loadGraphic(Paths.image('awards/thanks'));
        user.scrollFactor.set();
        user.updateHitbox();
        user.screenCenter();
        user.x -= 10;
        user.y += 25;
        user.antialiasing = ClientPrefs.globalAntialiasing;

        trophies = new FlxText(0, 0, 500, "", 16);
        trophies.screenCenter();
        trophies.x -= 50;
        trophies.antialiasing = ClientPrefs.globalAntialiasing;
        trophies.updateHitbox();
        trophies.scrollFactor.set();

        if(GameJoltAPI.getStatus())
        {
            add(user);
            add(trophies);
        }
        else
        {
            remove(user);
        }

        loginButtons = new FlxTypedGroup<FlxButton>(3);
        add(loginButtons);

        signInBox = new FlxButton(0, 475, "Sign In", function()
        {
            trace(usernameBox.text);
            trace(tokenBox.text);
            GameJoltAPI.authDaUser(usernameBox.text,tokenBox.text,true);
        });
        signInBox.screenCenter(X);
        signInBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        signInBox.setSize(signInBox.width - 0.3, signInBox.height - 0.3);
        signInBox.color = 0xFF51DA51;

        helpBox = new FlxButton(350, 475, "GameJolt Token", function()
        {
            if (!GameJoltAPI.getStatus())
                CoolUtil.browserLoad('https://youtu.be/Zod80sfysMc');
        });
        helpBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        helpBox.color = 0xFFF7B234;

        trophiesBox = new FlxButton(350, 525, "Trophies", function()
        {
            CoolUtil.browserLoad('https://gamejolt.com/games/ULTIMATEFLIPPY/785321/trophies');
        });
        trophiesBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        trophiesBox.color = 0xFFF7b234;

        logOutBox = new FlxButton(850, 525, "Log Out & Close", function()
        {
            GameJoltAPI.deAuthDaUser();
        });
        logOutBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        logOutBox.color = 0xFFFF0000;

        cancelBox = new FlxButton(850, 475, "Not Right Now", function()
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.mouse.visible = false;
            LoadingState.loadAndSwitchState(new MainMenuState());
        });
        cancelBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        cancelBox.color = 0xFFFF0000;

        continueBox = new FlxButton(0, 525, "Continue", function()
        {
            if(FlxG.save.data != null)
            {
                FlxG.save.data.gjUser = ClientPrefs.gjUser;
                FlxG.save.data.gjToken = ClientPrefs.gjToken;
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7, false, null, true);
                FlxG.save.flush();
                FlxG.mouse.visible = false;
                LoadingState.loadAndSwitchState(new MainMenuState());
                Application.current.window.title = Main.appTitle;
            }
        });
        continueBox.loadGraphic(Paths.image("gamejolt/button"), true, 160, 40);
        continueBox.color = 0xFF51DA51;
        continueBox.screenCenter(X);

        if(!GameJoltAPI.getStatus())
        {
            loginButtons.add(signInBox);
        }
        else
        {
            loginButtons.add(trophiesBox);
            loginButtons.add(continueBox);
            loginButtons.add(logOutBox);
        }
        loginButtons.add(helpBox);
        loginButtons.add(cancelBox);

        loginButtons.forEach(function(item:FlxButton){
            item.setGraphicSize(Std.int(item.width) * 3);
        });

        if(GameJoltAPI.getStatus())
        {
            username1 = new FlxText(0, 185, 0, "Signed in as:", 40);
            username1.alignment = CENTER;
            username1.font = GameJoltInfo.font;
            username1.screenCenter(X);
            add(username1);

            username2 = new FlxText(0, 245, 0, "" + GameJoltAPI.getUserInfo(true) + "", 40);
            username2.alignment = CENTER;
            username2.font = GameJoltInfo.font;
            username2.screenCenter(X);
            add(username2);
        }

        if(GameJoltInfo.font != null)
        {       
            username1.font = GameJoltInfo.font;
            username2.font = GameJoltInfo.font;
            loginBoxes.forEach(function(item:FlxUIInputText){
                item.font = GameJoltInfo.font;
            });
            loginTexts.forEach(function(item:FlxText){
                item.font = GameJoltInfo.font;
            });
        }

        super.create();
    }

    function tweenShit(?blue:Bool = false)
    {
        if(colorTween != null)
            colorTween.cancel();

        if(!blue)
            colorTween = FlxTween.color(bg, 5, 0xFF1EFF00, 0xFF8C00FF, {
                ease: FlxEase.quadInOut,
                onComplete: function(twn:FlxTween)
                {
                    colorTween = null;
                    tweenShit(true);
                }
            });
        else
            colorTween = FlxTween.color(bg, 5, 0xFF8C00FF, 0xFF1EFF00, {
                ease: FlxEase.quadInOut,
                onComplete: function(twn:FlxTween)
                {
                    colorTween = null;
                    tweenShit(false);
                }
            });
    }

    override function update(elapsed:Float)
    {
        if (FlxG.save.data.lbToggle == null)
        {
            FlxG.save.data.lbToggle = false;
            FlxG.save.flush();
        }

        if (GameJoltAPI.getStatus())
        {
            trophies.text = "Earned Trophies: " + Std.string(ClientPrefs.trophiesAchieved);

            remove(cancelBox);
            remove(helpBox);
        }

        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        if (!FlxG.sound.music.playing)
        {
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }

        if (controls.BACK)
        {
            if(GameJoltAPI.getStatus())
            {
                if(FlxG.save.data != null)
                {
                    FlxG.save.data.gjUser = ClientPrefs.gjUser;
                    FlxG.save.data.gjToken = ClientPrefs.gjToken;
                    FlxG.save.flush();
                }
            }
            FlxG.mouse.visible = false;
            LoadingState.loadAndSwitchState(new MainMenuState());
            Application.current.window.title = Main.appTitle;
            FlxG.sound.play(Paths.sound('cancelMenu'));
        }

        super.update(elapsed);
    }

    override function beatHit()
    {
        super.beatHit();
    }
}

/* The toast things, pulled from Hololive Funkin
* Thank you Firubii for the code for this!
* https://twitter.com/firubiii
* https://github.com/firubii
* ILYSM
*/

class GJToastManager extends Sprite
{
    public static var ENTER_TIME:Float = 0.5;
    public static var DISPLAY_TIME:Float = 3.0;
    public static var LEAVE_TIME:Float = 0.5;
    public static var TOTAL_TIME:Float = ENTER_TIME + DISPLAY_TIME + LEAVE_TIME;

    var playTime:FlxTimer = new FlxTimer();

    public function new()
    {
        super();
        FlxG.signals.postStateSwitch.add(onStateSwitch);
        FlxG.signals.gameResized.add(onWindowResized);
    }

    /**
     * Create a toast!
     * 
     * Usage: **Main.gjToastManager.createToast(iconPath, title, description);**
     * @param iconPath Path for the image **Paths.getLibraryPath("image/example.png")**
     * @param title Title for the toast
     * @param description Description for the toast
     * @param sound Want to have an alert sound? Set this to **true**! Defaults to **false**.
     */
    public function createToast(iconPath:String, title:String, description:String, ?sound:Bool = false, ?color:String = '#3848CC'):Void
    {
        if (sound) FlxG.sound.play(Paths.sound('unlock')); 
        
        var toast = new Toast(iconPath, title, description, color);
        addChild(toast);

        playTime.start(TOTAL_TIME);
        playToasts();
    }

    public function playToasts():Void
    {
        for (i in 0...numChildren)
        {
            var child = getChildAt(i);
            FlxTween.cancelTweensOf(child);
            FlxTween.tween(child, {y: (numChildren - 1 - i) * child.height}, ENTER_TIME, {ease: FlxEase.quadOut,
                onComplete: function(tween:FlxTween)
                {
                    FlxTween.cancelTweensOf(child);
                    FlxTween.tween(child, {y: (i + 1) * -child.height}, LEAVE_TIME, {ease: FlxEase.quadOut, startDelay: DISPLAY_TIME,
                        onComplete: function(tween:FlxTween)
                        {
                            cast(child, Toast).removeChildren();
                            removeChild(child);
                        }
                    });
                }
            });
        }
    }

    public function collapseToasts():Void
    {
        for (i in 0...numChildren)
        {
            var child = getChildAt(i);
            FlxTween.tween(child, {y: (i + 1) * -child.height}, LEAVE_TIME, {ease: FlxEase.quadOut,
                onComplete: function(tween:FlxTween)
                {
                    cast(child, Toast).removeChildren();
                    removeChild(child);
                }
            });
        }
    }

    public function onStateSwitch():Void
    {
        if (!playTime.active)
            return;

        var elapsedSec = playTime.elapsedTime / 1000;
        if (elapsedSec < ENTER_TIME)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.cancelTweensOf(child);
                FlxTween.tween(child, {y: (numChildren - 1 - i) * child.height}, ENTER_TIME - elapsedSec, {ease: FlxEase.quadOut,
                    onComplete: function(tween:FlxTween)
                    {
                        FlxTween.cancelTweensOf(child);
                        FlxTween.tween(child, {y: (i + 1) * -child.height}, LEAVE_TIME, {ease: FlxEase.quadOut, startDelay: DISPLAY_TIME,
                            onComplete: function(tween:FlxTween)
                            {
                                cast(child, Toast).removeChildren();
                                removeChild(child);
                            }
                        });
                    }
                });
            }
        }
        else if (elapsedSec < DISPLAY_TIME)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.cancelTweensOf(child);
                FlxTween.tween(child, {y: (i + 1) * -child.height}, LEAVE_TIME, {ease: FlxEase.quadOut, startDelay: DISPLAY_TIME - (elapsedSec - ENTER_TIME),
                    onComplete: function(tween:FlxTween)
                    {
                        cast(child, Toast).removeChildren();
                        removeChild(child);
                    }
                });
            }
        }
        else if (elapsedSec < LEAVE_TIME)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.tween(child, {y: (i + 1) * -child.height}, LEAVE_TIME -  (elapsedSec - ENTER_TIME - DISPLAY_TIME), {ease: FlxEase.quadOut,
                    onComplete: function(tween:FlxTween)
                    {
                        cast(child, Toast).removeChildren();
                        removeChild(child);
                    }
                });
            }
        }
    }

    public function onWindowResized(x:Int, y:Int):Void
    {
        for (i in 0...numChildren)
        {
            var child = getChildAt(i);
            child.x = Lib.current.stage.stageWidth - child.width;
        }
    }
}

class Toast extends Sprite
{
    var back:Bitmap;
    var icon:Bitmap;
    var title:TextField;
    var desc:TextField;

    public function new(iconPath:String, titleText:String, description:String, ?color:String = '#3848CC')
    {
        super();
        back = new Bitmap(new BitmapData(500, 125, true, 0xFF000000));
        back.alpha = 0.9;
        back.x = 0;
        back.y = 0;

        var iconBmp = FlxG.bitmap.add(Paths.image(iconPath));
        iconBmp.persist = true;
        
        if(iconPath != null)
        {
            icon = new Bitmap(iconBmp.bitmap);
            icon.width = 100;
            icon.height = 100;
            icon.x = 10;
            icon.y = 10;
        }

        title = new TextField();
        title.text = titleText.toUpperCase();
        title.setTextFormat(new TextFormat(CoolUtil.returnMenuFont(), 30, FlxColor.fromString(color), true));
        title.wordWrap = true;
        title.width = 360;
        if(iconPath!=null){title.x = 120;}
        else{title.x = 5;}
        title.y = 5 + 10;

        desc = new TextField();
        desc.text = description.toUpperCase();
        desc.setTextFormat(new TextFormat(CoolUtil.returnMenuFont(), 24, FlxColor.WHITE));
        desc.wordWrap = true;
        desc.width = 360;
        desc.height = 95;
        if(iconPath!=null){desc.x = 120;}
        else{desc.x = 5;}
        desc.y = 35 + 10;
        if (titleText.length >= 25 || titleText.contains("\n"))
        {   
            desc.y += 25;
            desc.height -= 25;
        }

        addChild(back);
        if(iconPath!=null){addChild(icon);}
        addChild(title);
        addChild(desc);

        width = back.width;
        height = back.height;
        x = Lib.current.stage.stageWidth - width;
        y = -height;
    }
}