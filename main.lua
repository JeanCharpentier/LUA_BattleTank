-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


--------------------------------------------------------------------------

local myGame = require("game")
local myTank = require("tank")

function love.load()
    love.window.setMode(1280,720)

    largeur = love.graphics.getWidth()
    hauteur = love.graphics.getHeight()

    myGame.Load()
    myTank.Load()
end

function love.update(dt)
    myTank.Update(dt)
end

function love.draw()
    myGame.Draw()
    myTank.Draw()
end

function love.keypressed(key)
    if key == "space" then
        myTank.creerTir(1)
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Mitrailleuse
        myTank.creerTir(2)
    end
    if button == 2 then -- Canon
        myTank.creerTir(1)
    end
 end
