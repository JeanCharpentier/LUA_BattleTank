require("system")

local Game = {}

---- Maps ----

Game.Map = {}
Game.Map =  {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 21, 21, 21, 21, 21, 21, 21, 21, 21},
        {1, 14, 3, 3, 7, 3, 3, 15, 1, 1, 8, 21, 21, 21, 21, 21, 21, 21, 21, 21},
        {1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 8, 21, 31, 34, 23, 23, 23, 23, 35, 21},
        {1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 8, 21, 21, 22, 21, 21, 21, 21, 22, 21},
        {1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 8, 21, 21, 22, 21, 21, 21, 21, 22, 21},
        {1, 2, 1, 1, 4, 3, 3, 12, 3, 3, 28, 23, 23, 25, 21, 21, 21, 31, 22, 21},
        {1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 8, 21, 21, 22, 21, 21, 34, 23, 37, 21},
        {1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 8, 21, 21, 22, 21, 21, 22, 21, 21, 21},
        {1, 2, 1, 1, 4, 3, 3, 17, 1, 1, 8, 21, 21, 22, 21, 21, 22, 21, 21, 21},
        {1, 16, 3, 3, 17, 1, 1, 1, 1, 1, 8, 21, 31, 22, 21, 21, 22, 31, 21, 21},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 21, 21, 36, 23, 23, 37, 21, 21, 21}
    }

Game.colMap = {}
Game.colMap =  {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 3, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 2, 0, 0, 0, 1},
        {1, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 4, 0, 0, 1},
        {1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1},
        {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 0, 1},
        {1, 2, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 3, 3, 3, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    }

Game.Tilesheet = nil
Game.TileTextures = {} --Tableau des textures

Game.colSprites = {}
Game.colSprites ={
    "images/obs/barricadeMetal.png",
    "images/obs/crateMetal.png",
    "images/obs/crateWood.png",
    "images/obs/treeBrown_large.png"
}
--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function Game.Load()
    Game.Tilesheet = love.graphics.newImage("images/terrainTiles_default.png")
    local nbColumns = Game.Tilesheet:getWidth() / TILE_WIDTH
    local nbLines = Game.Tilesheet:getHeight() / TILE_HEIGHT


    ---- Découpage TileSheet ----
    local l,c
    local id = 1
    Game.TileTextures[0] = nil
    for l=1,nbLines,1 do
        for c=1,nbColumns,1 do
            Game.TileTextures[id] = love.graphics.newQuad((c-1)*TILE_WIDTH,(l-1)*TILE_HEIGHT,TILE_WIDTH,TILE_HEIGHT,Game.Tilesheet:getWidth(),Game.Tilesheet:getHeight())
            id = id + 1
        end
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
function Game.Update(dt)

end
--[[    
██████╗ ██████╗  █████╗ ██╗    ██╗
██╔══██╗██╔══██╗██╔══██╗██║    ██║
██║  ██║██████╔╝███████║██║ █╗ ██║
██║  ██║██╔══██╗██╔══██║██║███╗██║
██████╔╝██║  ██║██║  ██║╚███╔███╔╝
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ 
]]
function Game.Draw()

    ----- Affichge Map ------
    local c,l

    for l=1,MAP_HEIGHT,1 do
        for c=1,MAP_WIDTH,1 do
            local id = Game.Map[l][c]
            local texQuad = Game.TileTextures[id]

            if texQuad ~= nil then
                love.graphics.draw(Game.Tilesheet,texQuad,(c-1)*TILE_WIDTH,(l-1)*TILE_HEIGHT)
            end
        end
    end

    ---- Affichage Colliders ----
    local cc, col
    for cl=1,MAP_HEIGHT,1 do
        for cc=1,MAP_WIDTH,1 do
            local id = Game.colMap[cl][cc]
            if id ~= 0 then
                local texCol = love.graphics.newImage(tostring(Game.colSprites[id]))
                if texCol ~= nil and texCol ~= 0 then
                    love.graphics.draw(texCol,(cc-1)*TILE_WIDTH,(cl-1)*TILE_HEIGHT,0,1,1,texCol:getWidth()/2,texCol:getHeight()/2)
                end
            end
        end
    end

    ------ ID de la tuile sous la souris --------
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    local col = math.floor(x / TILE_WIDTH) + 1
    local lig = math.floor(y / TILE_HEIGHT) + 1
    if col>0 and col<=MAP_WIDTH and lig>0 and lig<=MAP_HEIGHT then
        local id = Game.Map[lig][col]
        --love.graphics.print("ID:"..tostring(id),10,10)
    end
end

----------------------------------------
-----------RETURN-----------------------

return Game