function love.load()
    xrect = love.graphics.getWidth()/2-100
    yrect = love.graphics.getHeight()/2-100
end

function love.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("fill",xrect,yrect,200,200)
    love.graphics.setColor(0,0,255)
    love.graphics.print("Love funcionando!",xrect+45,yrect+90)
end