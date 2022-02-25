require("system")


---------------Gestion des ennemis -------------
local enn = {}
local MAX_EN = 6
local ennListe = {}
local ennImg = love.graphics.newImage("images/tank_blue.png")

local myTank = require("tank")
local tank = {}

function enn.creerEn()
    local lx = math.random(largeur/2,largeur-200)
    local ly = math.random(200, hauteur-200)
    local enn = {}
    enn = {x=lx,y=ly,imgBase=ennImg,angle=0}
    table.insert(ennListe, enn)
end

function enn.Load()
    for i=1,MAX_EN,1 do
        enn.creerEn()
    end
end

function enn.Update(dt)
    tank = myTank.getPos()
    for i=#ennListe,1,-1 do
        local enn = ennListe[i]
        enn.angle = math.atan2(tank.y - enn.y, tank.x - enn.x)
        local vx = 20 * math.cos(enn.angle)
        local vy = 20 * math.sin(enn.angle)
        enn.x = enn.x + (vx * dt)
        enn.y = enn.y + (vy * dt)
    end
    
    
end

function enn.Draw()
    for i=#ennListe,1,-1 do
        local enn = ennListe[i]
        love.graphics.draw(enn.imgBase,enn.x,enn.y,enn.angle,1,1,enn.imgBase:getWidth()/2,enn.imgBase:getWidth()/2)
    end
end


function enn.getListe()
    return ennListe
end


function enn.rmEnnemi(ln)
    table.remove(ennListe,ln)
end
------- RETURN ----------

return enn