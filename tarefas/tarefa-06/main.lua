-- Functions taken from https://love2d.org/wiki/General_math
function lerp(a,b,t) return a + (b - a) * t end

function love.load()
    -- Tables of entities that will be drawn
    player = {}
    hud = {}
    menu = {}
    entities = {}

    -- Loads the UI and HUD fonts
    font = love.graphics.newFont("kenvector_future.ttf")

    -- Loads the reusable assets
    menubackground = love.graphics.newImage("Scene-2.jpg")
    boss = love.graphics.newImage("Shooter_Boss_Sprite.png")
    background = love.graphics.newImage("Scene-1.jpg")
    title = love.graphics.newImage("nebula.png")
    spritesheet = love.graphics.newImage("Shooter_SpriteSheet.png")
    particlequad = love.graphics.newQuad(148,35,11,11,spritesheet:getDimensions())

    -- Sets Gamemode to 0 (0 is the menu)
    gamemode = -1
    changeMode(0)
end

function love.update(dt)
    if gamemode == 0 then

    elseif gamemode == 1 then
        if gameover == false then
            --Update the HUD
            for key,value in pairs(hud) do
                hud[key]:update(dt)
            end
            --Update the player
            player.update(dt)
            --Update the entities
            for i in ipairs(entities) do
                entities[i]:update(dt)
            end
        end
    end
end

function love.draw()
    --If gamemode is menu.
    if gamemode == 0 then
        --Loads background for menu
        love.graphics.draw(menubackground,0,0)
        --Write the game name on the screen
        love.graphics.draw(title,30,100)
        --Loads background panel from file.
        if panel == nil then
            panel = love.graphics.newImage("grey_panel.png")
        end
        --Draws background panel.
        love.graphics.draw(panel,245,325,0,3,3)
        --Draws menu entities.
        for key,value in pairs(menu) do
            menu[key]:draw()
        end
    --If gamemode is game
    elseif gamemode == 1 then
        --Draw the background
        love.graphics.draw(background,0,0)
        --Draw the player
        player.draw()
        --Draw the entities
        for i in ipairs(entities) do
            entities[i]:draw()
        end
        --Draw the HUD
        for key,value in pairs(hud) do
            hud[key]:draw()
        end
        --If player is dead
        if gameover == true then
            love.graphics.setColor(192,192,192,100)
            love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),love.graphics.getHeight())
            love.graphics.reset()
            if panel == nil then
                panel = love.graphics.newImage("grey_panel.png")
            end
            love.graphics.draw(panel,(love.graphics.getWidth()/4),(love.graphics.getHeight()/4)*1.3,0,4,2)
            love.graphics.setFont(font)
            love.graphics.setColor(0,0,0,255)
            love.graphics.print("You survived for: "..math.floor(hud.timer.data.timer).." seconds.",(love.graphics.getWidth()/4)*1.1,(love.graphics.getHeight()/4)*1.5,0,1.5,2)
            love.graphics.reset()
            if menu.vaipromenu == nil then
                createMenuEntity('vaipromenu',(love.graphics.getWidth()/4)*1.2,(love.graphics.getHeight()/4)*1.8,192*1.7,49*2,
                function(self)
                    if #(self.images) == 0 then
                        self.images.standard = love.graphics.newImage("grey_button01.png")
                        self.images.pressed = love.graphics.newImage("grey_button02.png")
                    end
                    if pointCollides(self,love.mouse.getX(),love.mouse.getY()) == true then
                        love.graphics.draw(self.images.pressed,self.x,self.y,0,1.7,2)
                    else
                        love.graphics.draw(self.images.standard,self.x,self.y,0,1.7,2)
                    end
                    love.graphics.setColor(0,0,0,255)
                    love.graphics.setFont(font)
                    love.graphics.print("MENU",self.x*1.6,self.y*1.1)
                    love.graphics.reset()
                end,
                function(self)
                    changeMode(0)
                end)
            end
            for key,value in pairs(menu) do
                menu[key]:draw()
            end
        end
    end
end

function love.mousepressed(x,y,button,istouch)
    if gamemode == 0 then
        for key,value in pairs(menu) do
            if pointCollides(menu[key],x,y) then
                menu[key]:action()
            end
        end
    elseif gamemode == 1 then
        for key,value in pairs(menu) do
            if pointCollides(menu[key],x,y) then
                menu[key]:action()
            end
        end
    end
end

function love.keypressed(key)
	-- tarefa-06
	-- O valor key recebido por essa função é uma enumeração, já que seu valor é sempre um valor dentre uma série de constantes (nesse caso cadeias de carecteres constantes)
	-- que representam as teclas que podem ser pressionadas pelo usuário.
    if gamemode == 1 then
        if key == "left" then
            leftpressed = true
        elseif key == "right" then
            rightpressed = true
        elseif key == "up" then
            uppressed = true
        elseif key == "down" then
            downpressed = true
        end
        if key == "escape" then
            changeMode(0)
        end
    end
end

function love.keyreleased(key)
    if gamemode == 1 then
        if key == "left" then
            leftpressed = false
        elseif key == "right" then
            rightpressed = false
        elseif key == "up" then
            uppressed = false
        elseif key == "down" then
            downpressed = false
        end
    end
end

function changeMode(gm)
    if gm == 0 then
        clearEntities()
        gamemode = 0
        initializeMenu()
    elseif gm == 1 then
        clearEntities()
        gamemode = 1
        initializeGame()
    end
end

function clearEntities()
    player = {}
    hud = {}
    menu = {}
    entities = {}
end

function initializeMenu()
    --Adds the play button
    createMenuEntity("play",300,400,190,45,
    function(self)
         --Load the images if they were never loaded.
        if #(self.images) == 0 then
            self.images.standard = love.graphics.newImage("grey_button01.png")
            self.images.pressed = love.graphics.newImage("grey_button02.png")
        end
        if pointCollides(self,love.mouse.getX(),love.mouse.getY()) == true then
            love.graphics.draw(self.images.pressed,self.x,self.y)
        else
            love.graphics.draw(self.images.standard,self.x,self.y)
        end
        love.graphics.setColor(0,0,0,255)
        love.graphics.setFont(font)
        love.graphics.print("START GAME",self.x+50,self.y+15)
        love.graphics.reset()
    end,
    function(self)
        changeMode(1)
    end)
    --Adds the Credits Button
    createMenuEntity("quit",300,475,190,45,
    function(self)
        if #(self.images) == 0 then
            self.images.standard = love.graphics.newImage("grey_button01.png")
            self.images.pressed = love.graphics.newImage("grey_button02.png")
        end
        if pointCollides(self,love.mouse.getX(),love.mouse.getY()) == true then
            love.graphics.draw(self.images.pressed,self.x,self.y)
        else
            love.graphics.draw(self.images.standard,self.x,self.y)
        end
        love.graphics.setColor(0,0,0,255)
        love.graphics.setFont(font)
        love.graphics.print("QUIT GAME",self.x + 60,self.y + 15)
        love.graphics.reset()
    end,
    function(self)
        love.event.quit()
    end)    
end

function initializeGame()
    --Reset the game status
    gameover = false
    --Initialize the Player
    initializePlayerEntity()
    --Initialize the Boss (Status 0 = Not Ready, 1 = Ready, 2 = Finished, 3 = Dead)
    bossstatus = 0
    movingright = true
    createEntity(10,-64*2.5,64*2.5,64*2.5,
    function(self)
        love.graphics.draw(boss,self.x,self.y,0,2.5,2.5)
    end,
    function(self,dt)
        if collides(player,self) then
            gameover = true
        end
        self.y = lerp(self.y,-20,0.03)
        if self.y > -22 then
            bossstatus = 1
        end
        if bossstatus == 1 then
            --Move the boss randomly
            if movingright then
                self.x = lerp(self.x,love.graphics.getWidth()-self.width-10,0.03)
                if self.x > love.graphics.getWidth()-self.width-50 then
                    movingleft = true
                    movingright = false
                end
            elseif movingleft then
                self.x = lerp(self.x,0,0.03)
                if self.x < 50 then
                    movingright = true
                    movingleft = false
                end
            end

            --Create particles
            local direction = math.random(0,2)
            if math.random(0,1) == 0 then
                createEntity((self.x + self.width/2)-12,self.y+self.height-10,11,11,
                function(this)
                    love.graphics.draw(spritesheet,particlequad,this.x,this.y,0,2,2)
                end,
                function(this,dt)
                    if this.y > love.graphics.getWidth()*1.1 then
                        entities[this] = nil
                    end
                    if collides(player,this) then
                        gameover = true
                    end
                    if direction == 1 then 
                        this.x = this.x + math.random(50,600)*dt
                    elseif direction == 2 then
                        this.x = this.x - math.random(50,600)*dt
                    end
                    this.y = this.y + math.random(100,500)*dt
                end)
            end
        end
    end)
    --Initialize the HUD
    createHUDEntity('timer',0,0,100,100,
    function(self)
        love.graphics.print("TIMER: " .. math.floor(self.data.timer),0,0,0,2,2)
    end,
    function(self,dt)
        if self.data.timer == nil then
            self.data.timer = 0
        end
        if gameover == false then
            self.data.timer = self.data.timer + dt
        end
    end)
end

function pointCollides(entity,x,y)
    if (((x > entity.x) and (x < (entity.x + entity.width))) and ((y > entity.y) and (y < (entity.y + entity.height)))) then
        return true
    else
        return false
    end
end

function collides(e1,e2)
    if e1.x < e2.x + e2.width and e1.x + e1.width > e2.x and e1.y < e2.y + e2.height and e1.y + e1.height > e2.y then
        return true
    end
    return false
end

function createMenuEntity(name,x,y,w,h,draw,action)
    local entity = {}
    entity.x = x
    entity.y = y
    entity.width = w
    entity.height = h
    entity.draw = draw
    entity.action = action
    entity.images = {}
    menu[name] = entity
end

function createHUDEntity(name,x,y,w,h,draw,update)
    local entity = {}
    -- tarefa-06
    -- A variável entity é um registro, pois possui um número finito de valores nomeados fixos. 
    -- Esses valores são preenchidos usando os argumentos da função createHUDEntity, que é o contrutor do registro.
    entity.x = x
    entity.y = y
    entity.width = w
    entity.height = h
    entity.data = {}
    entity.draw = draw
    entity.update = update 
    hud[name] = entity
    -- tarefa-06
    -- A variável hud (declarada na linha 7) é um dicionário, pois guarda objetos mapeados pelo valor da variável name.
end

function createEntity(x,y,w,h,draw,update)
    local entity = {}
    entity.x = x
    entity.y = y
    entity.width = w
    entity.height = h
    entity.images = {}
    entity.draw = draw
    entity.update = update
    -- Modificação feita para que a variável entities seja um array.
    table.insert(entities,entity)
    -- tarefa-06
    -- A variável entities é um array, pois guarda um conjunto de objetos homogêneos identificados por sua posição no array (índice).
end

function initializePlayerEntity()
    player.image = love.graphics.newImage("ship.png")
    player.atlas = {}
    player.atlas.center1 = love.graphics.newQuad(32,0,16,24,player.image:getDimensions())
    player.atlas.center2 = love.graphics.newQuad(32,24,16,24,player.image:getDimensions())
    player.atlas.left11 = love.graphics.newQuad(16,0,16,24,player.image:getDimensions())
    player.atlas.left12 = love.graphics.newQuad(16,24,16,24,player.image:getDimensions())
    player.atlas.left21 = love.graphics.newQuad(0,0,16,24,player.image:getDimensions())
    player.atlas.left22 = love.graphics.newQuad(0,24,16,24,player.image:getDimensions())
    player.atlas.right11 = love.graphics.newQuad(48,0,16,24,player.image:getDimensions())
    player.atlas.right12 = love.graphics.newQuad(48,24,16,24,player.image:getDimensions())
    player.atlas.right21 = love.graphics.newQuad(64,0,16,24,player.image:getDimensions())
    player.atlas.right22 = love.graphics.newQuad(64,24,16,24,player.image:getDimensions())
    player.x = 380
    player.y = 500
    player.width = 16
    player.velx = 350
    player.vely = 150
    player.height = 24
    player.sprite = player.atlas.center1
    player.framecounter = 0
    player.framecounter2 = 0
    player.draw = function(self)
        if gameover == false then
            player.updateSprite()
            player.animatesprite()
            love.graphics.draw(player.image,player.sprite,player.x,player.y,0,2.5,2.5)
            player.framecounter = player.framecounter + 1
            player.framecounter2 = player.framecounter2 + 1
        end
    end
    player.update = function(dt)
        if leftpressed and rightpressed then
            return
        end
        if leftpressed then
            if not player.OutOfBoundsX(player.x - player.velx * dt) then
                player.updateSprite()
                player.x = player.x - player.velx * dt
            end
        elseif rightpressed then
            if not player.OutOfBoundsX(player.x + player.velx * dt) then
                player.updateSprite()
                player.x = player.x + player.velx * dt
            end
        end
        if uppressed then
            if not player.OutOfBoundsY(player.y - player.vely * dt) then
                player.updateSprite()
                player.y = player.y - player.vely * dt
            end
        elseif downpressed then
            if not player.OutOfBoundsY(player.y + player.vely * dt) then
                player.updateSprite()
                player.y = player.y + player.vely * dt
            end
        end
    end
    player.animatesprite = function()
        local animationtimer = 10
        if player.sprite == player.atlas.center1 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.center2
            player.framecounter = 0
        elseif player.sprite == player.atlas.center2 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.center1
            player.framecounter = 0
        elseif player.sprite == player.atlas.left11 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.left12
            player.framecounter = 0
        elseif player.sprite == player.atlas.left12 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.left11
            player.framecounter = 0
        elseif player.sprite == player.atlas.left21 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.left22
            player.framecounter = 0
        elseif player.sprite == player.atlas.left22 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.left21
            player.framecounter = 0
        elseif player.sprite == player.atlas.right11 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.right12
            player.framecounter = 0
        elseif player.sprite == player.atlas.right12 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.right11
            player.framecounter = 0
        elseif player.sprite == player.atlas.right21 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.right22
            player.framecounter = 0
        elseif player.sprite == player.atlas.right22 and player.framecounter >= animationtimer then
            player.sprite = player.atlas.right21
            player.framecounter = 0
        end
    end
    player.updateSprite = function()
        if not leftpressed and not rightpressed then
            player.sprite = player.atlas.center1
        end
        if (player.sprite == player.atlas.left11 or player.sprite == player.atlas.left21) and not leftpressed then
            player.sprite = player.atlas.center1
        end
        if (player.sprite == player.atlas.right11 or player.sprite == player.atlas.right21) and not rightpressed then
            player.sprite = player.atlas.center1
        end
        if player.sprite == player.atlas.center1 and leftpressed and player.framecounter2 >= 20 then
            player.sprite = player.atlas.left11
            player.framecounter2 = 0
        elseif player.sprite == player.atlas.center1 and rightpressed and player.framecounter2 >= 20 then
            player.sprite = player.atlas.right11
            player.framecounter2 = 0
        elseif player.sprite == player.atlas.left11 and leftpressed and player.framecounter2 >= 40 then
            player.sprite = player.atlas.left21
            player.framecounter2 = 0
        elseif player.sprite == player.atlas.right11 and rightpressed and player.framecounter2 >= 40 then
            player.sprite = player.atlas.right21
            player.framecounter2 = 0
        end
    end
    player.OutOfBoundsX = function(newx)
        if newx <= 50 or newx + player.width >= love.graphics.getWidth() - 50 then
            return true
        end
        return false
    end
    player.OutOfBoundsY = function(newy)
        if newy <= 64*2.5 or newy + player.height >= love.graphics.getHeight()  then
            return true
        end
        return false
    end
end