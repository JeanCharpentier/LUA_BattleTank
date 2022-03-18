---- Tank -----
tank = {}
local MAX_SPEED = 200
local BOOST = 3
local canBoost = true
local isBoost = false
local tourelle = {}


tank = {x=200,y=200,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=MAX_SPEED,power=100,vie=100,score=0}
--tank.wave = 1

---- Boulets et Tirs ----
local imgTir = {love.graphics.newImage("images/bulletsDouble.png"),love.graphics.newImage("images/bulletRed2.png"),love.graphics.newImage("images/bulletDark3.png")}
tank.tirs = {}

---- Timer mitrailleuse ----
local TMSTATES = {SINGLE="single",BURST="burst",FULL="full",ENDBURST="endburst"}
local nbTirs = 3
tank.state = TMSTATES.SINGLE

local tmFireRate = 0.2 -- Fullauto
local tmTimer = 0
local tbFireRate = 0.1 -- Burst
local tbTimer = 1

---- Timer Tourelle ---
local ttFireRate = 4
local ttTimer = 0
local ttCanShoot = true

---- Curseur Souris ----
local mouseX = 0
local mouseY = 0

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
    --[[                                                              
  ####   ####  #    # ##### #####   ####  #      #      ######  ####  
 #    # #    # ##   #   #   #    # #    # #      #      #      #      
 #      #    # # #  #   #   #    # #    # #      #      #####   ####  
 #      #    # #  # #   #   #####  #    # #      #      #           # 
 #    # #    # #   ##   #   #   #  #    # #      #      #      #    # 
  ####   ####  #    #   #   #    #  ####  ###### ###### ######  ####  
]]

    ---- Rotation tourelle ----
    mouseX,mouseY = love.mouse.getPosition()
    tourelle.angle = math.atan2(mouseY - tank.y, mouseX - tank.x) -- Angle de la tourelle vers le curseur de la souris

    ---- Vecteurs de direction ----
    local vx = tank.s * math.cos(tank.angle)
    local vy = tank.s * math.sin(tank.angle)

    ---- Valeurs tampon Bordures ----
    local tx = tank.x
    local ty = tank.y
    
    ---- Clavier ----
    if love.keyboard.isDown("s") then
        tank.x = tank.x - (vx * dt)
        tank.y = tank.y - (vy * dt)
    end
    if love.keyboard.isDown("z") then
        tank.x = tank.x + (vx * dt)
        tank.y = tank.y + (vy * dt)
    end
    if love.keyboard.isDown("q") then
        tank.angle = tank.angle - (1 * dt)
    end
    if love.keyboard.isDown("d") then
        tank.angle = tank.angle + (1 * dt)
    end
    ---- Collisions bordures de map
    if (tank.y > mySystem.HAUTEUR) or (tank.y < 0) then
        tank.y = ty
    end
    if (tank.x > mySystem.LARGEUR) or (tank.x < 0) then
        tank.x = tx
    end
    
    ---- Mitrailleuse ----
    tank.mStates(dt)
    if love.mouse.isDown(1) then -- Tir mitrailleuse
        if tank.state == TMSTATES.FULL then
            tmTimer = tmTimer - dt
            if tmTimer <= 0 then
                tank.creerTir(1)
                tmTimer = tmFireRate
            end
        end
        if tank.state == TMSTATES.BURST then
            tmTimer = tmTimer - dt
            if tmTimer <= 0 then
                if nbTirs > 0 then
                    tank.creerTir(1)
                    tmTimer = tmFireRate
                    nbTirs = nbTirs - 1
                else
                    nbTirs = 3
                    tank.state = TMSTATES.ENDBURST
                end
            end
        end
    else
        tmTimer = tmFireRate        
    end

    ---- Tourelle ----
    if love.mouse.isDown(2) then
        ttTimer = ttTimer - dt
        if ttCanShoot == true then
            tank.creerTir(2)
            ttCanShoot = false            
        end
    else
        if ttCanShoot == false then
            ttTimer = ttTimer - dt
            if ttTimer <= 0 then
                ttCanShoot = true
                ttTimer = ttFireRate
            end
        else
            ttTimer = ttFireRate
        end
    end

        --[[          
 ##### # #####   ####  
   #   # #    # #      
   #   # #    #  ####  
   #   # #####       # 
   #   # #   #  #    # 
   #   # #    #  ####  
]]
    ---- Mouvements Boulets ----
    local ennemis = {}
    ennemis = myEnn.ennListe

    for i=#tank.tirs,1,-1 do
        local monBoulet = tank.tirs[i]
        local vx = monBoulet.speed * math.cos(monBoulet.angle)
        local vy = monBoulet.speed * math.sin(monBoulet.angle)
        monBoulet.x = tank.tirs[i].x + (vx * dt)
        monBoulet.y = tank.tirs[i].y + (vy * dt)
        
        if mySystem.isOutsideScreen(monBoulet,20) then
            table.remove(tank.tirs, i)
        end

        ---- Collisions Ennemis ----
        for n=#ennemis,1,-1 do
            local monEnnemi = ennemis[n]
            if math.dist(monBoulet.x, monBoulet.y, monEnnemi.x, monEnnemi.y) < (monEnnemi.imgBase:getWidth()/2) then
                table.insert(mySystem.explos,mySystem.Explosion(monBoulet.x,monBoulet.y))
                if (monEnnemi.vie - monBoulet.degats) > 0 then -- Perte de vie ennemi
                    monEnnemi.vie = monEnnemi.vie - monBoulet.degats
                    table.remove(tank.tirs, i)
                    if monBoulet.type == 2 then
                        tank.spray(monBoulet)
                    end
                else -- Destruction ennemi
                    if monBoulet.type == 2 then
                        tank.spray(monBoulet)
                    end
                    myLoot.addLoot(monEnnemi.x,monEnnemi.y)
                    table.remove(ennemis, n)
                    table.remove(tank.tirs, i)
                    tank.score = tank.score + (10 * myGame.wave)
                end
            end
        end
    end
--[[                                             
  ####   ####  #         #####  ######  ####   ####  #####  
 #    # #    # #         #    # #      #    # #    # #    # 
 #      #    # #         #    # #####  #      #    # #    # 
 #      #    # #         #    # #      #      #    # #####  
 #    # #    # #         #    # #      #    # #    # #   #  
  ####   ####  ######    #####  ######  ####   ####  #    # 
]]
    ---- Collisions Décors ----
    local cc, col
    for cl=1,mySystem.MAP_HEIGHT,1 do
        for cc=1,mySystem.MAP_WIDTH,1 do
            local id = myGame.colMap[cl][cc]
            local tx = (cc-1)*mySystem.TILE_WIDTH -- Position selon la taille de la tuile et son emplacement dans la grille
            local ty = (cl-1)*mySystem.TILE_HEIGHT
            if id ~= 0 and id ~= 1 then -- Si on touche un arbre ou une caisse, on la détruit
                if mySystem.CheckCollisions(tank.x-20,tank.y-20,40,40,tx-20,ty-20,40,40) then
                    myGame.colMap[cl][cc] = 0
                    table.insert(mySystem.explos, mySystem.Explosion(tx, ty))
                end
            end
            if id == 1 then -- Si on touche une barriquade, on ralentit
                if mySystem.CheckCollisions(tank.x-20,tank.y-20,40,40,tx-20,ty-20,40,40) then
                    if math.dist(tank.x, tank.y,tx,ty) < 40 then
                        tank.s = MAX_SPEED / 3
                        tank.canBoost = false
                    else
                        tank.s = MAX_SPEED
                        tank.canBoost = true
                    end
                end
            end
        end
    end
    

    --[[                                  
   ##   #    # ##### #####  ######  ####  
  #  #  #    #   #   #    # #      #      
 #    # #    #   #   #    # #####   ####  
 ###### #    #   #   #####  #           # 
 #    # #    #   #   #   #  #      #    # 
 #    #  ####    #   #    # ######  ####  
    ]]
    ---- Animations Explosions ----
    for n=#mySystem.explos,1,-1 do  
        local myTime = mySystem.explos[n].time + (10 * dt)
        mySystem.explos[n].time = myTime
        if mySystem.explos[n].time <= #mySystem.EXPLOSPRITES then
            mySystem.explos[n].frames = math.floor(mySystem.explos[n].time)
        else
            table.remove(mySystem.explos,n)
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

    ---- Loots ----
    if myLoot.liste ~= nil then
        for n=#myLoot.liste,1,-1 do
            if myLoot.Img:getHeight() > math.dist(tank.x,tank.y,myLoot.liste[n].x,myLoot.liste[n].y) then
                tank.score = tank.score + myLoot.liste[n].points
                table.remove(myLoot.liste,n)
            end
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

function tank.Draw()
    ----- Affichage Tank, Tourelle et tirs ----
    love.graphics.draw(tank.imgBase,tank.x,tank.y,tank.angle,1,1,tank.imgBase:getWidth()/2,tank.imgBase:getHeight()/2) -- Affichage Tank
    for i=1,#tank.tirs,1 do
        love.graphics.draw(tank.tirs[i].imgBase,tank.tirs[i].x,tank.tirs[i].y,tank.tirs[i].angle,1,1,tank.tirs[i].imgBase:getWidth()/2,tank.tirs[i].imgBase:getHeight()/2) -- Affichages boulets
    end
    love.graphics.draw(tourelle.imgBase,tank.x,tank.y,tourelle.angle,1,1,tourelle.imgBase:getWidth()/5,tourelle.imgBase:getHeight()/2) -- Affichage Tourelle
    
    ---- Affichage Explosions ----
    for i=1,#mySystem.explos,1 do
        local imgExplo = mySystem.EXPLOSPRITES[mySystem.explos[i].frames]
        love.graphics.draw(imgExplo, mySystem.explos[i].x, mySystem.explos[i].y,mySystem.explos[i].angle,1,1,imgExplo:getWidth()/2,imgExplo:getHeight()/2)
    end
    ---- Affichage BOOST ----
    love.graphics.setColor(0,1,0,0.8)
    love.graphics.rectangle("fill", 100, mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() + 10), (tank.power * ui.LOADING_MASK:getWidth()) / 100, ui.LOADING_MASK:getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(ui.LOADING_MASK, 100, mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() + 10))
    myUI.Print("Power",0,0,0,1,90+(ui.LOADING_MASK:getWidth()/2),mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() * 1.5),300,"center",0,0.3,0.3,0,0,0,0)

    ---- Affichage Reload ----
    love.graphics.setColor(0.4,0.4,0.5,0.8)
    love.graphics.rectangle("fill", 300, mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() + 10), (ttTimer * ui.LOADING_MASK:getWidth())/4, ui.LOADING_MASK:getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(ui.LOADING_MASK, 300, mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() + 10))
    myUI.Print("Reloading",0,0,0,1,274+(ui.LOADING_MASK:getWidth()/2),mySystem.HAUTEUR - (ui.LOADING_MASK:getHeight() * 1.5),300,"center",0,0.3,0.3,0,0,0,0)

    ---- Affichage Vie ----
    love.graphics.setColor(0,1,0,0.5)
    love.graphics.rectangle("fill",tank.x-20,tank.y-40,tank.vie,7)
    love.graphics.setColor(1,1,1,1)


    --- DEBUG ---
    -- Ci-git un print()
end

--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]

function tank.mStates(dt) -- States Machine Mitrailleuse
    if love.keyboard.isDown("f1") then
        tank.state = TMSTATES.SINGLE
    elseif love.keyboard.isDown("f2") then
        tank.state = TMSTATES.BURST
    elseif love.keyboard.isDown("f3") then
        tank.state = TMSTATES.FULL
    end
    if tank.state == TMSTATES.ENDBURST then
        tbTimer = tbTimer - dt
        if tbTimer <= 0 then
            tank.state = TMSTATES.BURST
            tbTimer = tbFireRate
        end
    end
end

function tank.creerTir(type,ang,parent) -- Créer un boulet selon son type et l'ajouter a la liste "tirs"
    local boulet = {}
    local s = 0
    local d = 0
    local bx = 0
    local by = 0
    local sound = nil
    if ang == nil then
        ang = 0
    end
    if type == 2 then -- Tir tourelle avant dispersion
        ang = tourelle.angle
        s = 100
        d = 50
        bx = tank.x
        by = tank.y
        sound = mySounds.sndTirT
    elseif type == 3 then -- Dispersion Tir Tourelle
        s = 500
        d = 2
        bx = parent.x
        by = parent.y
        sound = mySounds.sndSpray
    elseif type == 1 then -- Mitrailleuse
        ang = tank.angle
        s = 500
        d = 5
        bx = tank.x
        by = tank.y
        sound = mySounds.sndTirM
        sound:stop()
    end
    boulet = {x=bx,y=by,imgBase=imgTir[type],angle=ang,type=type,speed=s,degats=d}
    sound:play()
    table.insert(tank.tirs,boulet)
    return boulet
end

function tank.spray(lBoulet) -- Fragmentation du tir de la tourelle
    for i=(mySystem.PI/4),((2 * mySystem.PI) - (mySystem.PI/4)),0.6 do
        tank.creerTir(3,math.atan(math.cos(i))+lBoulet.angle,lBoulet) -- Merci l'animation du cercle trigo !!!
    end
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