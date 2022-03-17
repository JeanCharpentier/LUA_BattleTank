ui = {}

ui.DEFAULT_FONT = love.graphics.newFont("fonts/kenvector_future.ttf",30)

---- Interface ----
ui.MAIN_HUD = love.graphics.newImage("images/UI/mainHUD.png")
ui.LOADING_MASK = love.graphics.newImage("images/UI/blue_button13.png")
ui.CONTROLLES = love.graphics.newImage("images/UI/Controlles.png")

ui.showControl = false

function ui.Draw()
    ---- Affichage Main HUD ----
    love.graphics.draw(ui.MAIN_HUD,0,0)
    ui.Print(myTank.score,1,0,0,1,mySystem.LARGEUR/2,mySystem.HAUTEUR-45,300,"center",0,1,1,150,0)

    if ui.showControl then
        love.graphics.draw(ui.CONTROLLES,0,0)
    end
end

function ui.Print(text,red,green,blue,alpha,x,y,limit,align,r,sx,sy,ox,oy,kx,ky)
    love.graphics.setColor(red,green,blue,alpha)
    love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
    love.graphics.setColor(1,1,1,1)
end

return ui