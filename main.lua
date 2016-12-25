lg = love.graphics

local image_path = ""
local image = {}
local anims = {}

local created  = false

local input = {text = '1'}

local suit   = require 'suit'
local width  = {value = 128, min = 1, max = 256}
local height = {value = 128, min = 1, max = 256}
local frame  = {value = 1,   min = 1, max = 64}
local speed  = {value = 0.2, min = 0, max = 1}
local scale  = {value = 1,   min = 0, max = 5}

function love.load()
	require 'anim'

	lg.setDefaultFilter('nearest', 'nearest')

	drop  = love.graphics.newImage('drop.png')
	
	buttons = {
		{color = {65,  77,  108}, normal = lg.newImage('buttons/button_1.png'), hover = lg.newImage('buttons/hover_1.png'), active = lg.newImage('buttons/active_1.png')},
		{color = {207, 111, 14},  normal = lg.newImage('buttons/button_2.png'), hover = lg.newImage('buttons/hover_2.png'), active = lg.newImage('buttons/active_2.png')},
		{color = {69,  152, 94},  normal = lg.newImage('buttons/button_3.png'), hover = lg.newImage('buttons/hover_3.png'), active = lg.newImage('buttons/active_3.png')},
		{color = {199, 46,  18},  normal = lg.newImage('buttons/button_4.png'), hover = lg.newImage('buttons/hover_4.png'), active = lg.newImage('buttons/active_4.png')}
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

    suit.Label("Frame width: " .. math.floor(width.value), {align = "left"}, suit.layout:row(250, 20))
    if suit.Slider(width, suit.layout:row(250, 20)).changed then
    	anims:reload(math.floor(width.value), math.floor(height.value))
        frame.max = anims.count + 0.9
    end

    suit.layout:row(0, 5)

    suit.Label("Frame height: " .. math.floor(height.value), {align = "left"}, suit.layout:row(250, 20))
    if suit.Slider(height, {align = "left"}, suit.layout:row(250, 20)).changed then
		anims:reload(math.floor(width.value), math.floor(height.value))
        frame.max = anims.count + 0.9
    end

    suit.layout:row(0, 5)

    suit.Label("Go to frame: " .. input.text, {align = "left"}, suit.layout:row(250, 20))
    if suit.Input(input, suit.layout:row(120, 20)).submitted then
    	local n = tonumber(input.text)

    	if n > anims.count then
    		n = anims.count
    		input.text = tostring(n)
    	end

    	anims.stop  = true
    	anims.pos   = n
    	frame.value = n
    end

    suit.layout:col(10, 0)

    if suit.Button("Play", suit.layout:col(120, 20)).hit and created then
    	anims.stop = false
    end

    suit.layout._x = 10

    if suit.Slider(frame, {align = "left"}, suit.layout:row(250, 20)).changed then
    	anims.stop = true
    	input.text = tostring(math.floor(frame.value))
    	anims.pos  = tonumber(input.text)
    end

    suit.layout:row(0, 5)

    suit.Label("Animation speed: " .. math.floor(speed.value * 100) * 0.01, {align = "left"}, suit.layout:row(250, 20))
    if suit.Slider(speed, suit.layout:row(250, 20)).changed then
    	anims.speed = math.floor(speed.value * 100) * 0.01
    end

    suit.layout:row(0, 5)

    suit.Label("Scale factor: " .. math.floor(scale.value * 10) * 0.1, {align = "left"}, suit.layout:row(250, 20))
    if suit.Slider(scale, suit.layout:row(250, 20)).changed then
    	scale.value = math.floor(scale.value * 10) * 0.1
    end

	suit.layout:row(0, 15)

    if suit.Button("Refresh", suit.layout:row(250, 20)).hit and created then
    	getImageData(image_path)
        createAnimation(image_data)
    end

    suit.layout:row(0, 15)

    if suit.ImageButton(buttons[1].normal, {hovered = buttons[1].hover, active = buttons[1].active}, suit.layout:row(66, 20)).hit then
    	love.graphics.setBackgroundColor(buttons[1].color)
    end

    if suit.ImageButton(buttons[2].normal, {hovered = buttons[2].hover, active = buttons[2].active}, suit.layout:col(66, 20)).hit then
    	love.graphics.setBackgroundColor(buttons[2].color)
    end

    if suit.ImageButton(buttons[3].normal, {hovered = buttons[3].hover, active = buttons[3].active}, suit.layout:col(66, 20)).hit then
    	love.graphics.setBackgroundColor(buttons[3].color)
    end

    if suit.ImageButton(buttons[4].normal, {hovered = buttons[4].hover, active = buttons[4].active}, suit.layout:col(66, 20)).hit then
    	love.graphics.setBackgroundColor(buttons[4].color)
    end
end

function love.draw()
	if created then
		anims:draw((love.graphics.getWidth() - 270) / 2 + 270 - width.value * scale.value / 2, love.graphics.getHeight() / 2 - height.value * scale.value / 2, 0, scale.value, scale.value)
	else
		love.graphics.draw(drop, (love.graphics.getWidth() - 270) / 2 + 220, love.graphics.getHeight() / 2 - 50)
	end

	love.graphics.setColor(20, 30, 45, 255)
	love.graphics.rectangle('fill', 0, 0, 270, love.graphics.getHeight())
	love.graphics.setColor(255, 255, 255, 255)

	suit.draw()
end

function getImageData()
	local file = io.open(image_path, 'rb')
	file_data = file:read('*all')
	file:close()

	image_data = love.filesystem.newFile("temp.png", "w")
	image_data:write(file_data)
	image_data:close()

	image = love.graphics.newImage("temp.png")
end

function createAnimation(img)
    image = love.graphics.newImage(img)
	anims = anim.new(image, width.value, height.value, speed.value)
	
	frame.max   = anims.count + 0.9
	frame.value = 1

	created = true
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