---------------Gestion des ennemis -------------
local enn = {}
enn.maxEnn = 2
enn.maxSpeed = 100
local ennImg = love.graphics.newImage("images/tank_blue.png")
enn.ennListe = {}

local ESTATES = {NONE = "none", GARDE = "garde", ATTACK = "attack", CHANGEDIR = "change", APPROCHE="approche", OUTSIDE="outside", COLLIDE="collide"}

local imgTir = love.graphics.newImage("images/bulletRed2.png")
enn.ennTirs = {}

---- Timer tirs ----
enn.tDuration = 5
enn.tTime = 0

---- Timer collisions ----
enn.tcDuration = 1
enn.tcTime = 0

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function enn.Load()
    for i=1,enn.maxEnn,1 do
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
    ---- Update Ennemis ----
    for n=#enn.ennListe,1,-1 do
        local ennemi = enn.ennListe[n]
        for m=#enn.ennListe,1,-1 do
            if m ~= n then -- Ne se prend pas en compte soit-même
                local col = enn.ennListe[m]
                if math.dist(ennemi.x, ennemi.y,col.x,col.y) <= 40 and col.state ~= ESTATES.COLLIDE then -- Si l'object "Collidé" n'est pas déjà en collision
                    ennemi.state = ESTATES.COLLIDE
                end
            end
        end
        enn.UpdateEnn(ennemi,dt)
        ennemi.x = ennemi.x + (ennemi.vx * dt)
        ennemi.y = ennemi.y + (ennemi.vy * dt)
    end

    ---- Update Boulets ----
    for i=#enn.ennTirs,1,-1 do
        local monBoulet = enn.ennTirs[i]

        if mySystem.isOutsideScreen(monBoulet,20) then -- On détruit les boulets qui sortent de l'écran
            table.remove(enn.ennTirs, i)
        elseif math.dist(monBoulet.x, monBoulet.y, myTank.x, myTank.y) < 30 then -- Collision Tank
            if myTank.vie > 10 then
                myTank.vie = myTank.vie - 10
                table.insert(mySystem.explos, mySystem.Explosion(monBoulet.x, monBoulet.y))
            else
                mySounds.Music:stop()
                myMainMenu.state = true
                myMainMenu.condition = "defaite"
            end
            table.remove(enn.ennTirs, i)
        else -- Sinon on update normalement
            local vx = monBoulet.speed * math.cos(monBoulet.angle)
            local vy = monBoulet.speed * math.sin(monBoulet.angle)
            monBoulet.x = enn.ennTirs[i].x + (vx * dt)
            monBoulet.y = enn.ennTirs[i].y + (vy * dt)
        end
    end
    ---- Si plus d'ennemis à l'écran ---
    if #enn.ennListe == 0 and (not myMainMenu.state) then
        myGame.wave = myGame.wave + 1
        enn.maxEnn = enn.maxEnn * myGame.wave
        enn.maxSpeed = 50 * myGame.wave
        enn.Load() -- On recharge une nouvelle vague
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
    for i=#enn.ennListe,1,-1 do
        local enn = enn.ennListe[i]
        love.graphics.draw(enn.imgBase,enn.x,enn.y,enn.angle,1,1,enn.imgBase:getWidth()/2,enn.imgBase:getWidth()/2)
        ---- Affichage vie ----
        love.graphics.setColor(255,0,0,0.5)
        love.graphics.rectangle("fill",enn.x-20,enn.y-40,enn.vie*2,7)
        love.graphics.setColor(255,255,255,1)
    end
    for i=#enn.ennTirs,1,-1 do
        local tir = enn.ennTirs[i]
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

function enn.rmEnnemi(ln)
    table.remove(enn.ennListe,ln)
end

function enn.creerTir(lEnn) -- Créer un boulet et l'ajouter a la liste "tirs"
    local boulet = {}
    local s = 120
    boulet = {x=lEnn.x,y=lEnn.y,imgBase=imgTir,angle=lEnn.angle,speed=s}
    table.insert(enn.ennTirs,boulet)
    return boulet
end

function enn.creerEnn() -- Créer un ennemi à une position aléatoire sur la moitié droite de l'écran
    local lx = math.random(mySystem.LARGEUR/2,mySystem.LARGEUR-200)
    local ly = math.random(200, mySystem.HAUTEUR-200)
    local ennemi = {}
    ennemi = {x=lx,y=ly,imgBase=ennImg,angle=0,speed=enn.maxSpeed,vx=0,vy=0,state=ESTATES.NONE,vie=20}
    table.insert(enn.ennListe, ennemi)
end

--[[
███████╗████████╗ █████╗ ████████╗███████╗    ███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝    ████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
███████╗   ██║   ███████║   ██║   █████╗      ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
╚════██║   ██║   ██╔══██║   ██║   ██╔══╝      ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
███████║   ██║   ██║  ██║   ██║   ███████╗    ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
]]
function enn.UpdateEnn(lEnn,dt)
    if lEnn.state == ESTATES.NONE then
        lEnn.state = ESTATES.CHANGEDIR
    elseif lEnn.state == ESTATES.GARDE then
        if math.dist(lEnn.x,lEnn.y,myTank.x,myTank.y) < 400 then
            lEnn.state = ESTATES.APPROCHE
        end
        if mySystem.isOutsideScreen(lEnn,-30) then
            lEnn.state = ESTATES.OUTSIDE
        end
    elseif lEnn.state == ESTATES.OUTSIDE then
        local angle = math.angle(lEnn.x, lEnn.y, math.random(300,mySystem.LARGEUR-300),math.random(200,mySystem.HAUTEUR-200))
        lEnn.angle = angle
        lEnn.state = ESTATES.APPROCHE
    elseif lEnn.state == ESTATES.CHANGEDIR then
        local angle = math.angle(lEnn.x, lEnn.y, math.random(0,mySystem.LARGEUR), math.random(0,mySystem.HAUTEUR))
        lEnn.vx = lEnn.speed * math.cos(angle)
        lEnn.vy = lEnn.speed * math.sin(angle)
        lEnn.angle = angle
        lEnn.state = ESTATES.GARDE
    elseif lEnn.state == ESTATES.ATTACK then
        lEnn.angle = math.angle(lEnn.x, lEnn.y, myTank.x, myTank.y)
        lEnn.vx = 0
        lEnn.vy = 0
        enn.tTime = enn.tTime + (6*dt)
        if math.dist(lEnn.x,lEnn.y,myTank.x,myTank.y) >= 200 then
            lEnn.state = ESTATES.APPROCHE
        end
        if enn.tTime >= enn.tDuration then
            enn.tTime = 0
            if myDeb.ennShoots then
                enn.creerTir(lEnn)
            end      
        end
    elseif lEnn.state == ESTATES.APPROCHE then
        if math.dist(lEnn.x,lEnn.y,myTank.x,myTank.y) >= 400 then
            lEnn.state = ESTATES.GARDE
        elseif math.dist(lEnn.x,lEnn.y,myTank.x,myTank.y) < 200 then
            lEnn.state = ESTATES.ATTACK
        end
        lEnn.angle = math.angle(lEnn.x, lEnn.y, myTank.x, myTank.y)
        lEnn.vx = lEnn.speed * math.cos(lEnn.angle)
        lEnn.vy = lEnn.speed * math.sin(lEnn.angle)
    elseif lEnn.state == ESTATES.COLLIDE then
        enn.tcTime = enn.tcTime + dt
        lEnn.vx = 0
        lEnn.vy = 0        
        if enn.tcTime >= enn.tcDuration then
            local angle = lEnn.angle - mySystem.PI/2
            lEnn.vx = lEnn.speed * math.cos(angle)
            lEnn.vy = lEnn.speed * math.sin(angle)
            lEnn.state = ESTATES.APPROCHE
            enn.tcTime = 0
        end
    end
end

------- RETURN ----------

return enn