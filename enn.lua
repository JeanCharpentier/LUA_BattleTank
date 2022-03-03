local mySystem  = require("system")

---------------Gestion des ennemis -------------
local enn = {}
local MAX_ENN = 6
local ennListe = {}
local ennImg = love.graphics.newImage("images/tank_blue.png")

local ESTATES = {NONE = "none", GARDE = "garde", ATTACK = "attack", CHANGEDIR = "change", APPROCHE="approche"}

local ennTirs = {}

---- Timer tirs ----
local tDuration = 2
local tTime = 0

---- Position du tank ----
local myTank = require("tank")
--local tank = {}

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function enn.Load()
    for i=1,MAX_ENN,1 do
        enn.creerEnn()
    end
end
--[[
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
]]
function enn.Update(dt)
    --tank = myTank.getInfos()
    print(tostring(myTank.x))
    for i=#ennListe,1,-1 do
        local ennemi = ennListe[i]
        enn.UpdateEnn(ennemi,myTank)
        ennemi.x = ennemi.x + (ennemi.vx * dt)
        ennemi.y = ennemi.y + (ennemi.vy * dt)
    end

    ---- Timer tir automatique ----
    tTime = tTime + (6*dt)
    --print(tostring(tTime))

    ---- Update Boulets ----
    for i=#ennTirs,1,-1 do
        local monBoulet = ennTirs[i]
        local vx = monBoulet.speed * math.cos(monBoulet.angle)
        local vy = monBoulet.speed * math.sin(monBoulet.angle)
        monBoulet.x = ennTirs[i].x + (vx * dt)
        monBoulet.y = ennTirs[i].y + (vy * dt)

        if mySystem.isOutsideScreen(monBoulet) then
            table.remove(ennTirs, i)
        end

        ---- Collisions Tank ----
        if math.dist(monBoulet.x, monBoulet.y, myTank.x, myTank.y) < 30 then
            table.remove(ennTirs, i)
            myTank.vie = myTank.vie - 10
        end
    end
end
--[[    
██████╗ ██████╗  █████╗ ██╗    ██╗
██╔══██╗██╔══██╗██╔══██╗██║    ██║
██║  ██║██████╔╝███████║██║ █╗ ██║
██║  ██║██╔══██╗██╔══██║██║███╗██║
██████╔╝██║  ██║██║  ██║╚███╔███╔╝
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ 
]]
function enn.Draw()
    for i=#ennListe,1,-1 do
        local enn = ennListe[i]
        love.graphics.draw(enn.imgBase,enn.x,enn.y,enn.angle,1,1,enn.imgBase:getWidth()/2,enn.imgBase:getWidth()/2)
        ---- Affichage vie ----
        love.graphics.setColor(255,0,0,0.5)
        love.graphics.rectangle("fill",enn.x-20,enn.y-40,enn.vie*2,7)
        love.graphics.setColor(255,255,255,1)
    end
    for i=#ennTirs,1,-1 do
        local tir = ennTirs[i]
        love.graphics.draw(tir.imgBase,tir.x,tir.y,tir.angle,1,1,tir.imgBase:getWidth()/2,tir.imgBase:getWidth()/2)
    end
end

--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]

function enn.getListe()
    return ennListe
end


function enn.rmEnnemi(ln)
    table.remove(ennListe,ln)
end


function enn.creerTir(lEnn) -- Créer un boulet et l'ajouter a la liste "tirs"
    local boulet = {}
    local s = 120
    boulet = {x=lEnn.x,y=lEnn.y,imgBase=love.graphics.newImage("images/bulletRed2.png"),angle=lEnn.angle,speed=s}
    table.insert(ennTirs,boulet)
    return boulet
end

function enn.creerEnn()
    local lx = math.random(mySystem.largeur/2,mySystem.largeur-200)
    local ly = math.random(200, mySystem.hauteur-200)
    local enn = {}
    enn = {x=lx,y=ly,imgBase=ennImg,angle=0,speed=20,vx=0,vy=0,state=ESTATES.NONE,vie=20}
    table.insert(ennListe, enn)
end

--[[
███████╗████████╗ █████╗ ████████╗███████╗    ███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝    ████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
███████╗   ██║   ███████║   ██║   █████╗      ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
╚════██║   ██║   ██╔══██║   ██║   ██╔══╝      ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
███████║   ██║   ██║  ██║   ██║   ███████╗    ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
]]
function enn.UpdateEnn(lEnn,lTank)
    if lEnn.state == ESTATES.NONE then
        lEnn.state = ESTATES.CHANGEDIR
    elseif lEnn.state == ESTATES.GARDE then
        if math.dist(lEnn.x,lEnn.y,lTank.x,lTank.y) < 400 then
            lEnn.state = ESTATES.APPROCHE
        end
    elseif lEnn.state == ESTATES.CHANGEDIR then
        local angle = math.angle(lEnn.x, lEnn.y, math.random(0,mySystem.largeur), math.random(0,mySystem.hauteur))
        lEnn.vx = lEnn.speed * math.cos(angle)
        lEnn.vy = lEnn.speed * math.sin(angle)
        lEnn.angle = angle
        lEnn.state = ESTATES.GARDE
    elseif lEnn.state == ESTATES.ATTACK then
        if math.dist(lEnn.x,lEnn.y,lTank.x,lTank.y) >= 200 then
            lEnn.state = ESTATES.APPROCHE
        end
        if tTime >= tDuration then
            tTime = 0
            enn.creerTir(lEnn)
        end
    elseif lEnn.state == ESTATES.APPROCHE then
        if math.dist(lEnn.x,lEnn.y,lTank.x,lTank.y) >= 400 then
            lEnn.state = ESTATES.GARDE
        elseif math.dist(lEnn.x,lEnn.y,lTank.x,lTank.y) < 200 then
            lEnn.state = ESTATES.ATTACK
        end
        lEnn.angle = math.angle(lEnn.x, lEnn.y, lTank.x, lTank.y)
        lEnn.vx = lEnn.speed * math.cos(lEnn.angle)
        lEnn.vy = lEnn.speed * math.sin(lEnn.angle)
    end
end

------- RETURN ----------

return enn