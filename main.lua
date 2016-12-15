local image_path = ""
local image = {}
local anim  = {}

local width = 128
local speed = 0.1
local frame = 4
local scale = 2

local time  = 0
local last_modtime = 0

local created  = false
local modified = true

function love.load()
	require 'Anim'

	love.graphics.setDefaultFilter('nearest', 'nearest')
end

function love.update(dt)
	if created then
		anim:update(dt)
		checkFile(dt)
	end
end

function love.draw()
	if created then
		anim:draw(300, 100, 0, scale, scale)
	end

	love.graphics.print("1: Width up, 2: Width down", 5, 10)
	love.graphics.print("Width of one frame: " .. width, 5, 25)

	love.graphics.print("3: Speed up, 4: Speed down", 5, 50)
	love.graphics.print("Speed of animation: " .. speed, 5, 65)

	love.graphics.print("5: Frame up, 6: Frame down", 5, 90)
	love.graphics.print("Number of frames: " .. frame, 5, 105)

	love.graphics.print("7: Scale up, 8: Scale down", 5, 130)
	love.graphics.print("Scale factor: " .. scale, 5, 145)

	if modtime then
		love.graphics.print(image_path, 300, 10)
	end
end

function newImage(i)
    img = love.graphics.newImage(i)
	local frame = math.ceil(img:getWidth() / width)
	anim  = newAnimation(img, width, img:getHeight(), speed, frame)

	created = true
end

function love.filedropped(file)
	file:open("r")
	image_path = 'img/' .. string.match(string.gsub(file:getFilename(),'/','\\'), "^.+\\(.+)$")
    imageData = love.image.newImageData(file)
    file:close()
    newImage(imageData)
end

function love.keypressed(key)
	if love.keyboard.isDown(3) then
		speed = speed - 0.05
	elseif love.keyboard.isDown(4) then
		speed = speed + 0.05
	elseif love.keyboard.isDown(1) then
		width = width + 1
	elseif love.keyboard.isDown(2) and width > 1 then
		width = width - 1
	elseif love.keyboard.isDown(5) then
		frame = frame + 1
	elseif love.keyboard.isDown(6) and frame > 1 then
		frame = frame - 1
	elseif love.keyboard.isDown(7) then
		scale = scale + 0.5
	elseif love.keyboard.isDown(8) and scale > 1 then
		scale = scale - 0.5
	end

	anim = newAnimation(img, width, img:getHeight(), speed, frame)
end

function checkFile(dt)
	time = time + dt

	if time > 1 then
		modtime, errormsg = love.filesystem.getLastModified(image_path)

		if last_modtime == 0 then
			last_modtime = modtime
		elseif modtime > last_modtime then
			newImage(image_path)
			modified = true
		end

		time = 0
	end
end