lg = love.graphics

local suit   = require 'suit'

image_path = ""
image = {}
anims = {}

created  = false

input_width  = {text = '128'}
input_height = {text = '128'}
input_frame  = {text = '1'}
input_speed  = {text = '0.2'}
input_scale  = {text = '1'}

width  = {value = 128, min = 1, max = 256}
height = {value = 128, min = 1, max = 256}
frame  = {value = 1,   min = 1, max = 64}
speed  = {value = 0.2, min = 0, max = 1}
scale  = {value = 1,   min = 0, max = 5}

local dock_width = 270

function love.load()
    require 'anim'
    require 'disp'

    lg.setDefaultFilter('nearest', 'nearest')

    drop  = love.graphics.newImage('img/icons/drop.png')
    
    buttons = {
        {color = {65,  77,  108}, normal = lg.newImage('img/buttons/button_1.png'), hover = lg.newImage('img/buttons/hover_1.png'), active = lg.newImage('img/buttons/active_1.png')},
        {color = {207, 111, 14},  normal = lg.newImage('img/buttons/button_2.png'), hover = lg.newImage('img/buttons/hover_2.png'), active = lg.newImage('img/buttons/active_2.png')},
        {color = {69,  152, 94},  normal = lg.newImage('img/buttons/button_3.png'), hover = lg.newImage('img/buttons/hover_3.png'), active = lg.newImage('img/buttons/active_3.png')},
        {color = {199, 46,  18},  normal = lg.newImage('img/buttons/button_4.png'), hover = lg.newImage('img/buttons/hover_4.png'), active = lg.newImage('img/buttons/active_4.png')}
    }

    lg.setBackgroundColor(buttons[1].color)
end

function love.update(dt)
    if dt > 0.1 then return end --stop update if window is being dragged

    if created then
        anims:update(dt)
    end

    suit.layout:reset(10,10)
    suit.layout:padding(0,5)

    suit.Label("Frame width: ", {align = "left"}, suit.layout:row(120, 20))

    if suit.Input(input_width, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_width.text)

        --TODO: Add error message for this
        --also should be moved into a function for max and minus check
        if n > width.max or n < 1 then
            input_width.text = tostring(math.floor(width.value))
            return
        end

        width.value = n

        animReload()
    end

    suit.layout._x = 10

    if suit.Slider(width, {align = "left"}, suit.layout:row(250, 20)).changed then
        
        animReload()

        input_width.text = tostring(math.floor(width.value))
    end

    suit.layout:row(0, 5)

    suit.Label("Frame height: ", {align = "left"}, suit.layout:row(120, 20))

    if suit.Input(input_height, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_height.text)

        --TODO: Add error message for this
        if n > height.max or n < 1 then
            input_height.text = tostring(math.floor(height.value))
            return
        end

        height.value = n

        animReload()
    end

    suit.layout._x = 10

    if suit.Slider(height, {align = "left"}, suit.layout:row(250, 20)).changed then
        
        animReload()

        input_height.text = tostring(math.floor(height.value))
    end

    suit.layout:row(0, 5)

    suit.Label("Go to frame: ", {align = "left"}, suit.layout:row(120, 20))

    if suit.Input(input_frame, suit.layout:col(60, 20)).submitted then
        n = tonumber(input_frame.text)

        --TODO: Add error message for this
        if n > frame.max or n < 1 then
            input_frame.text = tostring(math.floor(frame.value))
            return
        end

        if n > anims.count then
            n = anims.count
            input_frame.text = tostring(n)
        end

        anims.stop  = true
        anims.pos   = n
        frame.value = n
    end

    suit.layout:col(10, 0)

    if suit.Button("Play", suit.layout:col(60, 20)).hit and created then
        anims.stop = false
    end

    suit.layout._x = 10

    if suit.Slider(frame, {align = "left"}, suit.layout:row(250, 20)).changed then
        anims.stop = true
        input_frame.text = tostring(math.floor(frame.value))
        anims.pos  = tonumber(input_frame.text)
    end

    suit.layout:row(0, 5)

    suit.Label("Animation speed: ", {align = "left"}, suit.layout:row(120, 20))
    
    if suit.Input(input_speed, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_speed.text)

        --TODO: Add error message for this
        if n > speed.max or n < 1 then
            input_speed.text = tostring(math.floor(speed.value))
            return
        end

        speed.value = n
    end

    suit.layout._x = 10

    if suit.Slider(speed, {align = "left"}, suit.layout:row(250, 20)).changed then
        anims.speed = (math.floor(speed.value * 10) * 0.1)
        input_speed.text = tostring(math.floor(speed.value * 100) * 0.01)
    end

    suit.layout:row(0, 5)

    suit.Label("Scale factor: ", {align = "left"}, suit.layout:row(120, 20))
    
    if suit.Input(input_scale, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_scale.text)

        --TODO: Add error message for this
        if n > scale.max or n < 0 then
            input_scale.text = tostring(math.floor(scale.value))
            return
        end

        scale.value = n

    end

    suit.layout._x = 10

    if suit.Slider(scale, suit.layout:row(250, 20)).changed then
        anims.scale = math.floor(speed.value * 10) * 0.1
        input_scale.text = tostring(math.floor(scale.value * 10) * 0.1)
    end

    suit.layout:row(0, 15)

    if suit.Button("Refresh", suit.layout:row(250, 20)).hit and created then
        getImageData(image_path)
        createAnimation(image_data)
    end

    suit.layout:row(0, 15)
    suit.layout:row(0, 15)

    changeBackgroundColor(buttons[1], suit)
    changeBackgroundColor(buttons[2], suit)
    changeBackgroundColor(buttons[3], suit)
    changeBackgroundColor(buttons[4], suit)
end

function love.draw()
    if created then
        anims:draw((love.graphics.getWidth() - dock_width) / 2 + dock_width - width.value * scale.value / 2, love.graphics.getHeight() / 2 - height.value * scale.value / 2, 0, scale.value, scale.value)
    else
        love.graphics.draw(drop, (love.graphics.getWidth() - dock_width) / 2 + 220, love.graphics.getHeight() / 2 - 50)
    end

    love.graphics.setColor(20, 30, 45, 255)
    love.graphics.rectangle('fill', 0, 0, dock_width, love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255, 255)

    suit.draw()
end

function love.filedropped(file)
    file:open("r")
    file:close()
    image_path = string.gsub(file:getFilename(), '\\', '/')
    image_data = love.image.newImageData(file)
    createAnimation(image_data)
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end