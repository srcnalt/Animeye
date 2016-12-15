function love.load()
	require 'Anim'

	width = 50
	speed = 0.1
	frame = 3
	scale = 1
	created = false

	love.graphics.setDefaultFilter('nearest', 'nearest')

	timer = 0
	mtime = 0

	name = "no"
	image = {}
end

function love.update(dt)
	timerx(dt)

	if created then
		anim:update(dt)
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

	love.graphics.print(name, 300, 10)
end

function newImage(i)
    img = love.graphics.newImage(i)
	local frame = math.ceil(img:getWidth() / width)
	anim  = newAnimation(img, width, img:getHeight(), speed, frame)

	created = true
end

function love.filedropped(file)
	file:open("r")
	name = file:getFilename()
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

function timerx(dt)
	timer = timer + dt

	if timer > 1 then
		modtime, errormsg = love.filesystem.getLastModified("test.txt")

		if modtime > mtime then
			

		end

		timer = 0
		mtime = modtime
	end
end