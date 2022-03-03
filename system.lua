local system = {}

system.PI = math.pi

system.MAP_WIDTH = 20
system.MAP_HEIGHT = 11
system.TILE_WIDTH = 64
system.TILE_HEIGHT = 64

system.DEFAULT_FONT = love.graphics.newFont("fonts/kenvector_future.ttf",40)

function system.Load()
    love.window.setMode(1280,720)

    system.LARGEUR = love.graphics.getWidth()
    system.HAUTEUR = love.graphics.getHeight()

    math.randomseed(os.time()) -- Reset de la graine du Random
end

function system.isOutsideScreen(lObject) -- Vérifie si un objet sort de l'écran
    if lObject.x < 0 or lObject.x > system.LARGEUR or lObject.y < 0 or lObject.y > system.HAUTEUR then
        return true
    else
        return false
    end
end

function system.CheckCollisions(lx1,ly1,lw1,lh1,lx2,ly2,lw2,lh2)
    return lx1 < lx2+lw2 and
    lx2 < lx1 + lw1 and
    ly1 < ly2 + lh2 and
    ly2 < ly1 + lh1
end

function math.angle(x1,y1,x2,y2) -- Angle entre deux objets
    return math.atan2(y2-y1,x2-x1)
end

function math.dist(x1,y1, x2,y2) -- Collision par distance !
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function system.Limit(v,c1,c2) -- Pour limiter une valeur /!\ C'est pas un Clamp !
    local value = v
    if value < c1 then
        value = c1
    elseif value > c2 then
        value = c2
    end
    return value
end

function system.Explosion(lx,ly) -- Créer une explosion
    local explo = {}
    explo.x = lx
    explo.y = ly
    explo.frames = 1
    explo.angle = math.random(0,2*system.PI)
    explo.time = 1
    return explo
end

return system