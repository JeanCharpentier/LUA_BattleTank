sounds = {}

sounds.sndTirM = love.audio.newSource("sounds/Shoot_00.mp3","static")
sounds.sndTirT = love.audio.newSource("sounds/Hit_02.mp3","static")
sounds.sndSpray = love.audio.newSource("sounds/Explosion_02.mp3","static")
sounds.sndExplo = love.audio.newSource("sounds/Explosion_03.mp3","static")
sounds.Music = love.audio.newSource("sounds/Song.ogg","stream")

sounds.start = true

function sounds.Start()
    if sounds.start then
        mySounds.Music:setLooping(true)
        mySounds.Music:play()
    end
    sounds.start = false
end
return sounds