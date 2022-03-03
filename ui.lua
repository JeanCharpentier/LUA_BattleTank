ui = {}

function ui.Print(text,red,green,blue,alpha,x,y,limit,align,r,sx,sy,ox,oy,kx,ky)
    love.graphics.setColor(red,green,blue,alpha)
    love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
    love.graphics.setColor(1,1,1,1)
end

return ui