require("system")
local Tank = {}
local MAX_SPEED = 3

local mouseX = 0
local mouseY = 0

function Tank.Load()
    Tank = {x=largeur/2,y=hauteur/2,angle=0,imgBase=love.graphics.newImage("images/tank_darkLarge.png"),vx=0,vy=0,s=2}
    Tourelle = {x=Tank.x,y=Tank.y,angle=0,imgBase=love.graphics.newImage("images/specialBarrel1.png")}
end

function Tank.Update(dt)

    ---- CONTROLLES ----
    --[[if love.keyboard.isDown("down") then
        Tank.vy = Tank.vy + (Tank.s * dt)
        Tank.y = Tank.y + limit(Tank.vy,0,MAX_SPEED)
    end
    if love.keyboard.isDown("up") then
        Tank.vy = Tank.vy + (Tank.s * dt)
        Tank.y = Tank.y - limit(Tank.vy,0,MAX_SPEED)
    end
    if love.keyboard.isDown("left") then
        Tank.vx = Tank.vx + (Tank.s * dt)
        Tank.x = Tank.x - limit(Tank.vx,0,MAX_SPEED)
    end
    if love.keyboard.isDown("right") then
        Tank.vx = Tank.vx + (Tank.s * dt)
        Tank.x = Tank.x + limit(Tank.vx,0,MAX_SPEED)
    end
    ---- Reset VX et VY si pas d'inputs ----
    if (not love.keyboard.isDown("right")) and (not love.keyboard.isDown("left")) then
        Tank.vx = 0
    end
    if (not love.keyboard.isDown("up")) and (not love.keyboard.isDown("down")) then
        Tank.vy = 0
    end]]--

    if love.keyboard.isDown("s") then
        local vx = 20 * math.cos(Tank.angle)
        local vy = 20 * math.sin(Tank.angle)

        Tank.x = Tank.x - (vx * dt)
        Tank.y = Tank.y - (vy * dt)
    end
    if love.keyboard.isDown("z") then
        local vx = 20 * math.cos(Tank.angle)
        local vy = 20 * math.sin(Tank.angle)

        Tank.x = Tank.x + (vx * dt)
        Tank.y = Tank.y + (vy * dt)
    end
    if love.keyboard.isDown("q") then
        Tank.angle = Tank.angle - (1 * dt)
    end
    if love.keyboard.isDown("d") then
        Tank.angle = Tank.angle + (1 * dt)
    end

    ---- Rotation Tourelle ----
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    Tourelle.angle = math.atan2(mouseY - Tourelle.y, mouseX - Tourelle.x)
    
end

function Tank.Draw()
    love.graphics.draw(Tank.imgBase,Tank.x,Tank.y,Tank.angle,1,1,Tank.imgBase:getWidth()/2,Tank.imgBase:getHeight()/2)
    love.graphics.draw(Tourelle.imgBase,Tank.x,Tank.y,Tourelle.angle,1,1,Tourelle.imgBase:getWidth()/5,Tourelle.imgBase:getHeight()/2)
    --- DEBUG ---
    love.graphics.print("VALUE:"..tostring(mouseX))
end


-------- RETURN ----------
return Tank