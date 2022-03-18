loot = {}

loot.liste = {}
local lootImg = love.graphics.newImage("images/sandbagBrown.png")

function loot.Draw()
    if loot.liste ~= nil then
        for n=#loot.liste,1,-1 do
            love.graphics.draw(lootImg,loot.liste[n].x,loot.liste[n].y,loot.liste[n].r,1,1,lootImg:getWidth()/2,lootImg:getHeight()/2)
        end
    end
end

function loot.addLoot(lx,ly)
    local lt = {}
    lt.x = lx
    lt.y = ly
    lt.r = love.math.random(0,2*mySystem.PI)
    table.insert(loot.liste,lt)    
end

return loot