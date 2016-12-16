local image_path = ""
local image = {}
local anim  = {}

local speed = 0.1
local scale = 2

local created  = false

local vars = {
	width = 128,
	frame = 4,
	speed = 0.1,
	scale = 1
}

local suit   = require 'suit'
local width_slider = {value = vars.width, min = 1, max = 256}
local frame_slider = {value = vars.frame, min = 1, max = 32}
local speed_slider = {value = vars.speed, min = 0, max = 1}
local scale_slider = {value = vars.scale, min = 0, max = 5}

function love.load()
	require 'Anim'

	drop = love.graphics.newImage('drop.png')

	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(65,77,108, 255)
end

function love.update(dt)
	if dt > 0.1 then return end --stop update if window is being dragged

	if created then
		anim:update(dt)

		if checkVars() then
			createAnimation(image_data)
		end
	end

    suit.Label("Frame width: " .. math.floor(width_slider.value), {align = "left"}, 20, 10, 200, 20)
    suit.Slider(width_slider, 20, 30, 250, 20)

    suit.Label("Frame count: " .. math.floor(frame_slider.value), {align = "left"}, 20, 60, 200, 20)
    suit.Slider(frame_slider, 20, 80, 250, 20)

    suit.Label("Animation speed: " .. math.floor(speed_slider.value * 100) * 0.01, {align = "left"}, 20, 110, 200, 20)
    suit.Slider(speed_slider, 20, 130, 250, 20)

    suit.Label("Scale factor: " .. math.floor(scale_slider.value * 10) * 0.1, {align = "left"}, 20, 160, 200, 20)
    suit.Slider(scale_slider, 20, 180, 250, 20)

    if suit.Button("Refresh", 20, 230, 250, 20).hit and created then
    	getImageData(image_path)
        createAnimation(image_data)
    end
end

function love.draw()
	if created then
		anim:draw((love.graphics.getWidth() - 300) / 2 + 300 - vars.width * vars.scale / 2, love.graphics.getHeight() / 2 - image:getHeight() * vars.scale / 2, 0, vars.scale, vars.scale)
	else
		love.graphics.draw(drop, (love.graphics.getWidth() - 300) / 2 + 250, love.graphics.getHeight() / 2 - 50)
	end

	love.graphics.setColor(20, 30, 45, 255)
	love.graphics.rectangle('fill', 0, 0, 300, love.graphics.getHeight())
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