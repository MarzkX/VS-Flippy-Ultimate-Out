function onCreate()
	makeLuaSprite('theblack', 'blackstuff', 0, 0)
	setObjectCamera('theblack', 'hud')
	setProperty('theblack.alpha', 0)
	setObjectOrder('theblack', 1)
	addLuaSprite('theblack', true)
end 

function onEvent(name)
	if name == 'Black Stuff' then
		setProperty('theblack.alpha', 80)
		cameraFlash('hud', '000000', 1, true)
		setProperty("defaultCamZoom", 1)
	elseif name == 'Remove Black' then
		setProperty('theblack.alpha', 0)
		cameraFlash('hud', '000000', 1, true)
		setProperty("defaultCamZoom", 0.6)
	end
end