mainmenu = {}

local V_OFFSET = 400

local btnFrames = {love.graphics.newImage("images/UI/green_button01.png"), love.graphics.newImage("images/UI/green_button00.png")}
local buttons = {}

mainmenu.state = true
mainmenu.condition = nil

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
]]
function mainmenu.Load()

    table.insert(buttons, mainmenu.addButton("Sounds"))
    table.insert(buttons, mainmenu.addButton("Quit"))

    for i=1,#buttons,1 do -- Alignement des boutons
        buttons[i].x = (mySystem.LARGEUR/2)-(buttons[i].imgBase:getWidth()/2)
        buttons[i].y = (i*(buttons[i].imgBase:getHeight()+20))+V_OFFSET
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
function mainmenu.Update(dt)

    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    for i=1,#buttons,1 do
        local btn = buttons[i]
       if (mouseX >= btn.x) and (mouseX <= btn.x+btn.imgBase:getWidth()) and (mouseY >= btn.y) and (mouseY <= btn.y+btn.imgBase:getHeight()) then
            buttons[i].imgBase = btnFrames[2]
            if love.mouse.isDown(1) then
                if i == 1 then
                    if mainmenu.condition ~= nil then
                        mySystem.resetGame()
                    end
                    mainmenu.state = false -- Lance le jeu
                    mySounds.Music:setLooping(true)
                    mySounds.Music:play()
                    myEnn.Load() -- Création d'une nouvelle table d'ennemis
                elseif i == 2 then
                    local quit = love.event.quit() -- Quitte le jeu
                end
            end
       else
            buttons[i].imgBase = btnFrames[1]
       end
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
function mainmenu.Draw()
    if mainmenu.condition ~= nil then
        love.graphics.printf(mainmenu.condition,mySystem.LARGEUR/2,100,400,"center")
    end
    
    for i=1,#buttons,1 do
        local btn = buttons[i]
        love.graphics.draw(btn.imgBase, btn.x,btn.y)
        love.graphics.printf(btn.txt, btn.x, btn.y,btn.imgBase:getWidth(),"center")
    end
end


function mainmenu.addButton(ltexte)
    local btn = {}
    btn.x = 0
    btn.y = 0
    btn.txt = ltexte
    btn.imgBase = btnFrames[1]
    return btn

end

--------- RETURN ---------

return mainmenu