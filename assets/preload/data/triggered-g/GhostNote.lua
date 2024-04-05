--[[ made by Laztrix#5670 

please credit if you gonna use this as a mod that will be public

]]

local timeEffect = 0.3

function onSongStart()
	makeTrailEffect()
end
function onEvent(n,v1,v2)
	if n == 'Change Character' then
		runHaxeCode([[
			game.remove(trailBF);
			game.remove(trailDad);
			game.remove(trailGF);
		]])
		runTimer('characterChanged',0.2)
	end
end
function opponentNoteHit(id, direction ,noteType, isSustainNote)
	if not isSustainNote and not gfSection or not isSustainNote and not noteType == 'GF Sing' then
		if passDirectionDad ~= nil then
    	runHaxeCode([[
    	    trailDad.playAnim(game.singAnimations[]]..passDirectionDad..[[], true);
			trailDad.holdTimer = 0;
    	]])
		cancelTimer('dadframed')
		setProperty('trailDad.alpha',1)
		doTweenAlpha('betraildad','trailDad',0,timeEffect,'linear')
		end
		passDirectionDad = direction
		runTimer('dadframed', 0.03)
	end
	if not isSustainNote and gfSection or not isSustainNote and noteType == 'GF Sing' then
		if passDirectionGF ~= nil then
    	runHaxeCode([[
    	    trailGF.playAnim(game.singAnimations[]]..passDirectionGF..[[], true);
			trailGF.holdTimer = 0;
    	]])
		cancelTimer('gfframed')
		setProperty('trailGF.alpha',1)
		doTweenAlpha('betrailgf','trailGF',0,timeEffect,'linear')
		end
		passDirectionGF = direction
		runTimer('gfframed', 0.03)
	end
end
function goodNoteHit(id, direction ,noteType, isSustainNote) 
   if not isSustainNote then
	if passDirectionBF ~= nil then
    	   runHaxeCode([[
    	        trailBF.playAnim(game.singAnimations[]]..passDirectionBF..[[], true);
		trailBF.holdTimer = 0;
    	   ]])
	   cancelTimer('bfframed')
	   setProperty('trailBF.alpha',1)
	   doTweenAlpha('betrailbf','trailBF',0,timeEffect,'linear')
	end
	passDirectionBF = direction
	runTimer('bfframed', 0.03)
   end
end
function onTimerCompleted(t)
    if t == 'bfframed' then
        passDirectionBF = nil
    end

    if t == 'dadframed' then
        passDirectionDad = nil
    end

	if t == 'gfframed' then
        passDirectionGF = nil
    end

	if t == 'characterChanged' then
		makeTrailEffect()
	end
end
function makeTrailEffect()
	runHaxeCode([[
	// getting character original position
		BFPos = [game.boyfriend.x,game.boyfriend.y];
      	DadPos = [game.dad.x,game.dad.y];
		GFPos = [game.gf.x,game.gf.y];

	// new characters for the trails
		trailBF = new Boyfriend(BFPos[0], BFPos[1], ']]..boyfriendName..[[');
		game.addBehindBF(trailBF);

		trailDad = new Character(DadPos[0], DadPos[1], ']]..dadName..[[');
		game.addBehindDad(trailDad);

		trailGF = new Character(GFPos[0], GFPos[1], ']]..gfName..[[');
		game.addBehindGF(trailGF);

	// set the variable so you can mess it with setProperty stuff
		game.variables.set('trailGF', trailGF);
		game.variables.set('trailDad', trailDad);
        game.variables.set('trailBF', trailBF);

	// grrr
		trailDad.alpha = 0;
		trailBF.alpha = 0;
		trailGF.alpha = 0;
	]])
end
--[[ made by Laztrix#5670 

please credit if you gonna use this as a mod that will be public

]]