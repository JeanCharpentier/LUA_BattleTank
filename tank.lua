require("system")

---- Tank -----
local tank = {}
local MAX_SPEED = 80

---- Boulets et Tirs ----
local imgTir = {"images/bulletsDouble.png","images/bulletRed2.png"}
local tirs = {}

---- Explosions ----
local explos = {}
local exploSprites = {"images/explo/explosion1.png","images/explo/explosion2.png","images/explo/explosion3.png","images/explo/explosion4.png","images/explo/explosion5.png"}

---- Reload ----
local timeReload = 10
local canShoot = true


---- Curseur Souris ----
local mouseX = 0
local mouseY = 0

---- Liste ennemis ----


---- Fonctions ----

function tank.Load()
    tank = {x=largeur/4,y=hauteur/2,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=2}
    tourelle = {x=tank.x,y=tank.y,angle=0,imgBase=love.graphics.newImage("images/specialBarrel1.png")}
end

function tank.Update(dt)

    ---- Timer Reload ----
    
    ---- CONTROLLES ----
    if love.keyboard.isDown("s") then
        local vx = MAX_SPEED * math.cos(tank.angle)
        local vy = MAX_SPEED * math.sin(tank.angle)

        tank.x = tank.x - (vx * dt)
        tank.y = tank.y - (vy * dt)
    end
    if love.keyboard.isDown("z") then
        local vx = MAX_SPEED * math.cos(tank.angle)
        local vy = MAX_SPEED * math.sin(tank.angle)

        tank.x = tank.x + (vx * dt)
        tank.y = tank.y + (vy * dt)
    end
    if love.keyboard.isDown("q") then
        tank.angle = tank.angle - (1 * dt)
    end
    if love.keyboard.isDown("d") then
        tank.angle = tank.angle + (1 * dt)
    end

    ---- Rotation tourelle ----
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    tourelle.angle = math.atan2(mouseY - tourelle.y, mouseX - tourelle.x) -- Angle de la tourelle vers le curseur de la souris

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

        ---- Collisions ----
        for n=#ennemis,1,-1 do
            local monEnnemi = ennemis[n]
            if math.dist(monBoulet.x, monBoulet.y, monEnnemi.x, monEnnemi.y) < (monEnnemi.imgBase:getWidth()/2) then
                print("Collision !")
                table.insert(explos,Explosion(monBoulet.x,monBoulet.y))
                print(#explos)
                table.remove(ennemis, n)
                table.remove(tirs, i)
            end
        end
    end
    
    ---- Animations Explosions ----

    for n=#explos,1,-1 do
        local frame = explos[n].frames
        local myTime = explos[n].time + (10 * dt)
        --local modTime = myTime % 1
        explos[n].time = myTime
        if explos[n].time <= #exploSprites then
            explos[n].frames = math.floor(explos[n].time)
        else
            table.remove(explos,n)
        end
    end
end

function tank.Draw()
    ----- Affichage Tank, Tourelle et tirs ----
    love.graphics.draw(tank.imgBase,tank.x,tank.y,tank.angle,1,1,tank.imgBase:getWidth()/2,tank.imgBase:getHeight()/2) -- Affichage Tank
    for i=1,#tirs,1 do
        love.graphics.draw(tirs[i].imgBase,tirs[i].x,tirs[i].y,tirs[i].angle,1,1,tirs[i].imgBase:getWidth()/2,tirs[i].imgBase:getHeight()/2) -- Affichages boulets
    end
    love.graphics.draw(tourelle.imgBase,tank.x,tank.y,tourelle.angle,1,1,tourelle.imgBase:getWidth()/5,tourelle.imgBase:getHeight()/2) -- Affichage Tourelle
    
    ---- Affichage Explosions ----
    for i=1,#explos,1 do
        local imgExplo = love.graphics.newImage(exploSprites[explos[i].frames])
        love.graphics.draw(imgExplo, explos[i].x, explos[i].y,explos[i].angle,1,1,imgExplo:getWidth()/2,imgExplo:getHeight()/2)
    end

    --- DEBUG ---
    love.graphics.print("VALUE:"..tostring(#tirs))
end

function tank.creerTir(type) -- Créer un boulet selon son type et l'ajouter a la liste "tirs"
    local boulet = {}
    local ang = 0
    local s = 0
    if type == 2 then
        ang = tourelle.angle
        s = 100
    elseif type == 1 then
        ang = tank.angle
        s = 500
    end
    boulet = {x=tank.x,y=tank.y,imgBase=love.graphics.newImage(imgTir[type]),angle=ang,type=type,speed=s}
    table.insert(tirs,boulet)
    return boulet
end

function tank.getPos()
    local tankPos = {x=tank.x,y=tank.y}
    return tankPos
end

-------- RETURN ----------
return tank