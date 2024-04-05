function onCreatePost()
    runHaxeCode([[
       game.boyfriendCameraOffset = [-275, 150]
    ]])
    setProperty('boyfriendGroup.y', getProperty('boyfriendGroup.y') - 450)
    setProperty('boyfriendGroup.x', getProperty('boyfriendGroup.x') + 350)
end