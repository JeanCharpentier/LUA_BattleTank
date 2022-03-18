loot = {}

loot.liste = {}
loot.Img = love.graphics.newImage("images/sandbagBrown.png")

function loot.Draw()
    if loot.liste ~= nil then
        for n=#loot.liste,1,-1 do
            love.graphics.draw(loot.Img,loot.liste[n].x,loot.liste[n].y,loot.liste[n].r,1,1,loot.Img:getWidth()/2,loot.Img:getHeight()/2)
        end
    end
end

function loot.addLoot(lx,ly)
    local lt = {}
    lt.x = lx
    lt.y = ly
    lt.r = love.math.random(0,2*mySystem.PI)

    lt.points = 10 * myGame.wave
    table.insert(loot.liste,lt)    
end

return loot