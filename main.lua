-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


--------------------------------------------------------------------------

local myGame = require("game")

function love.load()
    love.window.setMode(1280,720)

    largeur = love.graphics.getWidth()
    hauteur = love.graphics.getHeight()

    myGame.Load()
end

function love.update(dt)
end

function love.draw()
    myGame.Draw()
end

function love.keypressed(key)
end
