function limit(v,c1,c2) -- Pour limiter une valeu /!\ C'est pas un Clamp !
    local value = v
    if value < c1 then
        value = c1
    elseif value > c2 then
        value = c2
    end
    return value
end

function math.dist(x1,y1, x2,y2) -- Collision par distance !
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function Explosion(lx,ly)
    local explo = {}
    explo.x = lx
    explo.y = ly
    explo.frames = 1
    explo.angle = math.random(0,6)
    explo.time = 1
    return explo
end