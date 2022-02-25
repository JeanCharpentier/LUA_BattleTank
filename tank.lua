require("system")

---- Tank -----
local tank = {}

---- Boulets et Tirs ----
local imgTir = {"images/bulletsDouble.png","images/bulletRed2.png"}
local tirs = {}

---- Reload ----
local timeReload = 10
local canShoot = true


---- Curseur Souris ----
local mouseX = 0
local mouseY = 0


---- Fonctions ----

function tank.Load()
    tank = {x=largeur/2,y=hauteur/2,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=2}
    tourelle = {x=tank.x,y=tank.y,angle=0,imgBase=love.graphics.newImage("images/specialBarrel1.png")}
end

function tank.Update(dt)

    ---- Timer Reload ----
    
    ---- CONTROLLES ----
    if love.keyboard.isDown("s") then
        local vx = 20 * math.cos(tank.angle)
        local vy = 20 * math.sin(tank.angle)

        tank.x = tank.x - (vx * dt)
        tank.y = tank.y - (vy * dt)
    end
    if love.keyboard.isDown("z") then
        local vx = 20 * math.cos(tank.angle)
        local vy = 20 * math.sin(tank.angle)

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

    tourelle.angle = math.atan2(mouseY - tourelle.y, mouseX - tourelle.x)

    ---- Mouvements Boulets ----
    for i=1,#tirs,1 do
        monBoulet = tirs[i]
        local vx = monBoulet.speed * math.cos(monBoulet.angle)
        local vy = monBoulet.speed * math.sin(monBoulet.angle)
        monBoulet.x = tirs[i].x + (vx * dt)
        monBoulet.y = tirs[i].y + (vy * dt)
    end
    
end

function tank.Draw()
    love.graphics.draw(tank.imgBase,tank.x,tank.y,tank.angle,1,1,tank.imgBase:getWidth()/2,tank.imgBase:getHeight()/2) -- Affichage Tank
    for i=1,#tirs,1 do
        love.graphics.draw(tirs[i].imgBase,tirs[i].x,tirs[i].y,tirs[i].angle,1,1,tirs[i].imgBase:getWidth()/2,tirs[i].imgBase:getHeight()/2) -- Affichages boulets
    end
    love.graphics.draw(tourelle.imgBase,tank.x,tank.y,tourelle.angle,1,1,tourelle.imgBase:getWidth()/5,tourelle.imgBase:getHeight()/2) -- Affichage Tourelle

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


-------- RETURN ----------
return tank