ui = {}

ui.DEFAULT_FONT = love.graphics.newFont("fonts/kenvector_future.ttf",30)

---- Interface ----
ui.MAIN_HUD = love.graphics.newImage("images/UI/mainHUD.png")
ui.LOADING_MASK = love.graphics.newImage("images/UI/blue_button13.png")

function ui.Print(text,red,green,blue,alpha,x,y,limit,align,r,sx,sy,ox,oy,kx,ky)
    love.graphics.setColor(red,green,blue,alpha)
    love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
    love.graphics.setColor(1,1,1,1)
end

return ui