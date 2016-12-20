local animation = {}
animation.__index = animation

function newAnimation(image, fw, fh, delay, frames)
	local a = {}
	a.img = image
	a.frames = {}
	a.delays = {}
	a.timer = 0
	a.position = 1
	a.fw = fw
	a.fh = fh
	a.playing = true
	a.speed = 1
	a.direction = 1

	local imgw = image:getWidth()
	local imgh = image:getHeight()
	
	if frames == 0 then
		frames = imgw / fw * imgh / fh
	end
	local rowsize = imgw/fw
	for i = 1, frames do
		local row = math.floor((i-1)/rowsize)
		local column = (i-1)%rowsize
		local frame = love.graphics.newQuad(column*fw, row*fh, fw, fh, imgw, imgh)
		table.insert(a.frames, frame)
		table.insert(a.delays, delay)
	end
	return setmetatable(a, animation)
end

function animation:update(dt)
	if not self.playing then return end
	self.timer = self.timer + dt * self.speed
	if self.timer > self.delays[self.position] then
		self.timer = self.timer - self.delays[self.position]
		self.position = self.position + 1 * self.direction
		if self.position > #self.frames then
			if self.mode == 1 then
				self.position = 1
			elseif self.mode == 2 then
				self.position = self.position - 1
				self:stop()
			elseif self.mode == 3 then
				self.direction = -1
				self.position = self.position - 1
			end
		elseif self.position < 1 and self.mode == 3 then
			self.direction = 1
			self.position = self.position + 1
		elseif self.position < 1 and self.mode == 4 then
			self.position = #self.frames
		end
	end
end

function animation:draw(...)
	love.graphics.draw(self.img, self.frames[self.position], ...)
end

function animation:addFrame(x, y, w, h, delay)
	local frame = love.graphics.newQuad(x, y, w, h, self.img:getWidth(), self.img:getHeight())
	table.insert(self.frames, frame)
	table.insert(self.delays, delay)
end

function animation:play()
	self.playing = true
end

function animation:stop()
	self.playing = false
end

function animation:reset()
	return self:seek(1)
end

function animation:seek(frame)
	self.position = frame
	self.timer = 0
end

function animation:getCurrentFrame()
	return self.position
end

function animation:getSize()
	return #self.frames
end

function animation:setDelay(frame, delay)
	self.delays[frame] = delay
end

function animation:setSpeed(speed)
	self.speed = speed
end

function animation:getWidth()
	return (select(3, self.frames[self.position]:getViewport()))
end

function animation:getHeight()
	return (select(4, self.frames[self.position]:getViewport()))
end

function animation:setMode(mode)
	if mode == "loop" then
		self.mode = 1
		self.direction = 1
	elseif mode == "once" then
		self.mode = 2
		self.direction = 1
	elseif mode == "bounce" then
		self.mode = 3
	elseif mode == "reverse" then
		self.mode = 4
		self.direction = -1
	end
end

if Animations_legacy_support then
	love.graphics.newAnimation = newAnimation
	local oldLGDraw = love.graphics.draw
	function love.graphics.draw(item, ...)
		if type(item) == "table" and item.draw then
			return item:draw(...)
		else
			return oldLGDraw(item, ...)
		end
	end
end
