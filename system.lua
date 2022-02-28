local PI = math.pi

MAP_WIDTH = 20
MAP_HEIGHT = 11
TILE_WIDTH = 64
TILE_HEIGHT = 64

DEFAULT_FONT = love.graphics.newFont("fonts/kenvector_future.ttf",40)

function Limit(v,c1,c2) -- Pour limiter une valeu /!\ C'est pas un Clamp !
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

function Explosion(lx,ly) -- Créer une explosion
    local explo = {}
    explo.x = lx
    explo.y = ly
    explo.frames = 1
    explo.angle = math.random(0,2*PI)
    explo.time = 1
    return explo
end