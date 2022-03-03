local mySystem = require("system")

---- Tank -----
local tank = {}
local MAX_SPEED = 80
local BOOST = 3
local canBoost = true
local isBoost = false
local tourelle = {}

tank = {x=100,y=100,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=MAX_SPEED,power=100,vie=100}

---- Boulets et Tirs ----
local imgTir = {"images/bulletsDouble.png","images/bulletRed2.png"}
local tirs = {}

---- Explosions ----
local explos = {}
local EXPLOSPRITES = {"images/explo/explosion1.png","images/explo/explosion2.png","images/explo/explosion3.png","images/explo/explosion4.png","images/explo/explosion5.png"}

---- Curseur Souris ----
local mouseX = 0
local mouseY = 0

---- HUD ----
local mainHUD = love.graphics.newImage("images/UI/mainHUD.png")
local reloadingMask = love.graphics.newImage("images/UI/blue_button13.png")

---- Reload ----
local timeReload = 10
local canShoot = true

local myCol = require("game")

---- Fonctions ----
--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function tank.Load()
    ---- Chargement et création du tank + tourelle ----
    --tank = {x=largeur/4,y=hauteur/2,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=MAX_SPEED,power=100,vie=100}
    tourelle = {x=tank.x,y=tank.y,angle=0,imgBase=love.graphics.newImage("images/specialBarrel1.png")}
end

--[[
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
]]

function tank.Update(dt)
    
    ---- Rotation tourelle ----
    mouseX,mouseY = love.mouse.getPosition()
    tourelle.angle = math.atan2(mouseY - tank.y, mouseX - tank.x) -- Angle de la tourelle vers le curseur de la souris

    ---- CONTROLLES ----
    if love.keyboard.isDown("s") then
        local vx = tank.s * math.cos(tank.angle)
        local vy = tank.s * math.sin(tank.angle)

        tank.x = tank.x - (vx * dt)
        tank.y = tank.y - (vy * dt)
    end
    if love.keyboard.isDown("z") then
        local vx = tank.s * math.cos(tank.angle)
        local vy = tank.s * math.sin(tank.angle)

        tank.x = tank.x + (vx * dt)
        tank.y = tank.y + (vy * dt)
    end
    if love.keyboard.isDown("q") then
        tank.angle = tank.angle - (1 * dt)
    end
    if love.keyboard.isDown("d") then
        tank.angle = tank.angle + (1 * dt)
    end

    ---- Mouvements Boulets ----
    local ennListe = require("enn")
    local ennemis = {}
    ennemis = ennListe.getListe()

    for i=#tirs,1,-1 do
        local monBoulet = tirs[i]
        local vx = monBoulet.speed * math.cos(monBoulet.angle)
        local vy = monBoulet.speed * math.sin(monBoulet.angle)
        monBoulet.x = tirs[i].x + (vx * dt)
        monBoulet.y = tirs[i].y + (vy * dt)
        
        if mySystem.isOutsideScreen(monBoulet) then
            table.remove(tirs, i)
        end

        ---- Collisions Ennemis ----
        for n=#ennemis,1,-1 do
            local monEnnemi = ennemis[n]
            if math.dist(monBoulet.x, monBoulet.y, monEnnemi.x, monEnnemi.y) < (monEnnemi.imgBase:getWidth()/2) then
                table.insert(explos,mySystem.Explosion(monBoulet.x,monBoulet.y))
                if (monEnnemi.vie - monBoulet.degats) > 0 then
                    monEnnemi.vie = monEnnemi.vie - monBoulet.degats
                    table.remove(tirs, i)
                else
                    table.remove(ennemis, n)
                    table.remove(tirs, i)
                end
            end
        end
    end

    ---- Collisions Décors ----
    local cc, col
    for cl=1,mySystem.MAP_HEIGHT,1 do
        for cc=1,mySystem.MAP_WIDTH,1 do
            local id = myCol.colMap[cl][cc]
            local vx = tank.s * math.cos(tank.angle)
            local vy = tank.s * math.sin(tank.angle)
            local tx = (cc-1)*mySystem.TILE_WIDTH -- Position selon la taille de la tuile et son emplacement dans la grille
            local ty = (cl-1)*mySystem.TILE_HEIGHT
            if id ~= 0 and id ~= 1 then -- Si on touche un arbre ou une caisse, on la détruit
                if mySystem.CheckCollisions(tank.x-20,tank.y-20,40,40,tx-20,ty-20,40,40) then
                    myCol.colMap[cl][cc] = 0
                    table.insert(explos, mySystem.Explosion(tx, ty))
                end
            end
            if id == 1 then -- Si on touche une barriquade, on ralentit
                if mySystem.CheckCollisions(tank.x-20,tank.y-20,40,40,tx-20,ty-20,40,40) then
                    if math.dist(tank.x, tank.y,tx,ty) < 40 then
                        tank.s = MAX_SPEED / 3
                    else
                        tank.s = MAX_SPEED
                    end
                end
            end
        end
    end
    
    ---- Animations Explosions ----
    for n=#explos,1,-1 do
        local frame = explos[n].frames
        local myTime = explos[n].time + (10 * dt)
        explos[n].time = myTime
        if explos[n].time <= #EXPLOSPRITES then
            explos[n].frames = math.floor(explos[n].time)
        else
            table.remove(explos,n)
        end
    end

    ---- Boost et Power ----
    if tank.power > 0 and isBoost then
        tank.power = tank.power - (60 * dt)
    elseif tank.power <= 0 then
        tank.s = MAX_SPEED
        isBoost = false
        canBoost = false
    end
    if tank.power < 100 and (not isBoost) then
        tank.power = tank.power + (10 * dt)
    end
    if tank.power >= 100 then
        canBoost = true
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

function tank.Draw()
    ----- Affichage Tank, Tourelle et tirs ----
    love.graphics.draw(tank.imgBase,tank.x,tank.y,tank.angle,1,1,tank.imgBase:getWidth()/2,tank.imgBase:getHeight()/2) -- Affichage Tank
    for i=1,#tirs,1 do
        love.graphics.draw(tirs[i].imgBase,tirs[i].x,tirs[i].y,tirs[i].angle,1,1,tirs[i].imgBase:getWidth()/2,tirs[i].imgBase:getHeight()/2) -- Affichages boulets
    end
    love.graphics.draw(tourelle.imgBase,tank.x,tank.y,tourelle.angle,1,1,tourelle.imgBase:getWidth()/5,tourelle.imgBase:getHeight()/2) -- Affichage Tourelle
    
    ---- Affichage Explosions ----
    for i=1,#explos,1 do
        local imgExplo = love.graphics.newImage(EXPLOSPRITES[explos[i].frames])
        love.graphics.draw(imgExplo, explos[i].x, explos[i].y,explos[i].angle,1,1,imgExplo:getWidth()/2,imgExplo:getHeight()/2)
    end

    ---- Affichage HUD ----
    love.graphics.draw(mainHUD,0,0)

    ---- Affichage BOOST ----
    love.graphics.rectangle("fill", 100, mySystem.hauteur - (reloadingMask:getHeight() + 10), (tank.power * reloadingMask:getWidth()) / 100, reloadingMask:getHeight())
    love.graphics.draw(reloadingMask, 100, mySystem.hauteur - (reloadingMask:getHeight() + 10))

    ---- Affichage Vie ----
    love.graphics.setColor(0,255,0,0.5)
    love.graphics.rectangle("fill",tank.x-20,tank.y-40,tank.vie,7)
    love.graphics.setColor(255,255,255,1)


    --- DEBUG ---
    --[[local vx = tank.s * math.cos(tank.angle)
    local vy = tank.s * math.sin(tank.angle)
    love.graphics.line(tank.x + (vx/2), tank.y + (vy/2),tank.x,tank.y)
    love.graphics.print("VALUE:"..tostring(math.dist(tank.x + (vx/2), tank.y + (vy/2),tank.x,tank.y)))
    ]]
end

--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]
function tank.creerTir(type) -- Créer un boulet selon son type et l'ajouter a la liste "tirs"
    local boulet = {}
    local ang = 0
    local s = 0
    local d = 0
    if type == 2 then
        ang = tourelle.angle
        s = 100
        d = 10
    elseif type == 1 then
        ang = tank.angle
        s = 500
        d = 5
    end
    boulet = {x=tank.x,y=tank.y,imgBase=love.graphics.newImage(imgTir[type]),angle=ang,type=type,speed=s,degats=d}
    table.insert(tirs,boulet)
    return boulet
end

function tank.getInfos() -- Renvoi la position et la vie du Tank aux ennemis
    local tankPos = {x=tank.x,y=tank.y,vie=tank.vie}
    return tankPos
end

function tank.boost() -- Lance le boost
    if canBoost then
        tank.s = MAX_SPEED * BOOST
        canBoost = false
        isBoost = true
    end
end

-------- RETURN ----------
return tank