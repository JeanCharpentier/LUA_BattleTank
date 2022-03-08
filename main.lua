-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


--------------------------------------------------------------------------

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
    love.graphics.setFont(mySystem.DEFAULT_FONT)
    if myMainMenu.state then -- Si le menu est activé on l'affiche
        myMainMenu.Draw()
    else -- Sinon on affiche le jeu
        myGame.Draw()
        
        myEnn.Draw()
        myTank.Draw()
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
end

function love.mousepressed(x, y, button, istouch)    
    if button == 1 then -- Mitrailleuse
        if myTank.state == "single" then
            myTank.creerTir(1)
        end
    end
    --[[if button == 2 then -- Tourelle
        myTank.creerTir(2)
    end]]
 end

 function love.mousereleased(x,y,button,istouch)
 end
