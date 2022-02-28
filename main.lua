-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


--------------------------------------------------------------------------
require("system") -- "Librairie" perso
require("mainmenu")

local myGame = require("game")
local myTank = require("tank")
local myEnn = require("enn")
local myMainMenu = require("mainmenu")

function love.load()
    love.window.setMode(1280,720)

    largeur = love.graphics.getWidth()
    hauteur = love.graphics.getHeight()

    math.randomseed(os.time()) -- Reset de la graine du Random

    myMainMenu.Load()
    myGame.Load()
    myTank.Load()
    myEnn.Load()
end

function love.update(dt)
    if myMainMenu.state then -- Si le menu est activé on l'update
        myMainMenu.Update(dt)
    else -- Sinon on update la boucle de jeu
        myGame.Update(dt)
        myTank.Update(dt)
        myEnn.Update(dt)
    end
end

function love.draw()
    love.graphics.setFont(DEFAULT_FONT)
    if myMainMenu.state then -- Si le menu est activé on l'affiche
        myMainMenu.Draw()
    else -- Sinon on affiche le jeu
        myGame.Draw()
        myTank.Draw()
        myEnn.Draw()
    end
end

function love.keypressed(key)
    if key == "space" then
        myTank.boost()
    end
end

function love.mousepressed(x, y, button, istouch)    
    if button == 1 then -- Mitrailleuse
        myTank.creerTir(1)
    end
    if button == 2 then -- Canon
        myTank.creerTir(2)
    end
 end
