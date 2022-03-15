-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


--------------------------------------------------------------------------
myDebug = require("debug")
mySystem = require("system")
myGame = require("game")
myTank = require("tank")
myEnn = require("enn")
myMainMenu = require("mainmenu")
myUI = require("ui")
mySounds = require("sounds")

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function love.load()
    
    mySystem.Load()

    myMainMenu.Load()
    myGame.Load()
    myTank.Load()
end
--[[
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
]]
function love.update(dt)
    if myMainMenu.state then -- Si le menu est activé on l'update
        myMainMenu.Update(dt)
    else -- Sinon on update la boucle de jeu
        --mySystem.Update(dt)
        myGame.Update(dt)
        myTank.Update(dt)
        myEnn.Update(dt)
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
function love.draw()
    love.graphics.setFont(ui.DEFAULT_FONT)
    if myMainMenu.state then -- Si le menu est activé on l'affiche
        myMainMenu.Draw()
    else -- Sinon on affiche le jeu
        --mySystem.Draw()
        myGame.Draw() -- Map
        myUI.Draw() -- UI
        myEnn.Draw() -- Ennemis
        myTank.Draw() -- Tank
        
    end
end
--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]
function love.keypressed(key)
    if key == "space" then
        myTank.boost()
    end
    if key == "f9" then -- Toogle tirs des ennemis
        if myDebug.ennShoots == true then
            myDebug.ennShoots = false
        else
            myDebug.ennShoots = true
        end
    end
    if key == "f10" then
        if myDebug.mute == true then
            myDebug.mute = false
            love.audio.setVolume(1)
        else
            myDebug.mute = true
            love.audio.setVolume(0)
        end
    end
    if key == "f11" then
        myEnn.Load()
    end
end

function love.mousepressed(x, y, button, istouch)    
    if button == 1 then -- Mitrailleuse
        if myTank.state == "single" then
            myTank.creerTir(1)
        end
    end
 end

 function love.mousereleased(x,y,button,istouch)
 end
