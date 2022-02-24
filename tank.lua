require("system")
local Tank = {}
local MAX_SPEED = 3
function Tank.Load()
    Tank = {x=largeur/2,y=hauteur/2,rot=0,imgBase=love.graphics.newImage("images/tankBody_huge.png"),vx=0,vy=0,s=2}
    Tourelle = {x=Tank.x,y=Tank.y,rot=0,imgBase=love.graphics.newImage("images/specialBarrel1.png")}
end

function Tank.Update(dt)

    ---- CONTROLLES ----
    if love.keyboard.isDown("down") then
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
    if (not love.keyboard.isDown("right")) and (not love.keyboard.isDown("left")) then
        Tank.vx = 0
    end
    if (not love.keyboard.isDown("up")) and (not love.keyboard.isDown("down")) then
        Tank.vy = 0
    end
    
end

function Tank.Draw()
    love.graphics.draw(Tank.imgBase,Tank.x,Tank.y,Tank.rot,1,1,Tank.imgBase:getWidth()/2,Tank.imgBase:getHeight()/2)
    love.graphics.draw(Tourelle.imgBase,Tank.x,Tank.y,Tourelle.rot,1,1,Tourelle.imgBase:getWidth()/2,0)
    --- DEBUG ---
    love.graphics.print("VALUE:"..tostring(limit(Tank.vx,0,MAX_SPEED)))
end


-------- RETURN ----------
return Tank