lg = love.graphics

suit   = require 'suit'

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

    displayFrameWidthTool()
    displayFrameHeightTool()
    displayGoToFrameTool()
    displayAnimSpeedTool()
    displayScaleFactorTool()
    displayRefreshTool()

    suit.layout:row(0, 5)

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