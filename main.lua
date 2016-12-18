lg = love.graphics

local image_path = ""
local image = {}
local anim  = {}

local created  = false

local vars = {
	width = 128,
	height= 128,
	frame = 4,
	speed = 0.1,
	scale = 1
}

local suit   = require 'suit'
local width_slider = {value = vars.width, min = 1, max = 256}
local height_slider= {value = vars.width, min = 1, max = 256}
local frame_slider = {value = vars.frame, min = 1, max = 32}
local speed_slider = {value = vars.speed, min = 0, max = 1}
local scale_slider = {value = vars.scale, min = 0, max = 5}

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
		anim:update(dt)

		if checkVars() then
			createAnimation(image_data)
		end
	end

	suit.layout:reset(10,10)
    suit.layout:padding(0,5)

    suit.Label("Frame width: " .. math.floor(width_slider.value), {align = "left"}, suit.layout:row(250, 20))
    suit.Slider(width_slider, suit.layout:row(250, 20))

    suit.layout:row(0, 5)

    suit.Label("Frame height: " .. math.floor(height_slider.value), {align = "left"}, suit.layout:row(250, 20))
    suit.Slider(height_slider, suit.layout:row(250, 20))

    suit.layout:row(0, 5)

    suit.Label("Frame count: " .. math.floor(frame_slider.value), {align = "left"}, suit.layout:row(250, 20))
    suit.Slider(frame_slider, suit.layout:row(250, 20))

    suit.layout:row(0, 5)

    suit.Label("Animation speed: " .. math.floor(speed_slider.value * 100) * 0.01, {align = "left"}, suit.layout:row(250, 20))
    suit.Slider(speed_slider, suit.layout:row(250, 20))

    suit.layout:row(0, 5)

    suit.Label("Scale factor: " .. math.floor(scale_slider.value * 10) * 0.1, {align = "left"}, suit.layout:row(250, 20))
    suit.Slider(scale_slider, suit.layout:row(250, 20))

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
		anim:draw((love.graphics.getWidth() - 270) / 2 + 270 - vars.width * vars.scale / 2, love.graphics.getHeight() / 2 - image:getHeight() * vars.scale / 2, 0, vars.scale, vars.scale)
	else
		love.graphics.draw(drop, (love.graphics.getWidth() - 270) / 2 + 220, love.graphics.getHeight() / 2 - 50)
	end

	love.graphics.setColor(20, 30, 45, 255)
	love.graphics.rectangle('fill', 0, 0, 270, love.graphics.getHeight())
	love.graphics.setColor(255, 255, 255, 255)

	suit.draw()
end

function checkVars()
	if vars.width ~= width_slider.value then vars.width = width_slider.value return true end
	if vars.frame ~= frame_slider.value then vars.frame = frame_slider.value return true end
	if vars.scale ~= scale_slider.value then vars.scale = scale_slider.value return true end
	if vars.speed ~= speed_slider.value then vars.speed = speed_slider.value return true end

	return false
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
	anim  = newAnimation(image, vars.width, image:getHeight(), vars.speed, vars.frame)

	created = true
end

function love.filedropped(file)
	file:open("r")
	file:close()
	image_path = string.gsub(file:getFilename(), '\\', '/')
    image_data = love.image.newImageData(file)
    createAnimation(image_data)
end