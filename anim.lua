anim = {}
anim.__index = anim

function anim.new(img, fw, fh, speed)
	local self = setmetatable({}, anim)

	self.iw  	= img:getWidth()
	self.ih  	= img:getHeight()

	local col = math.ceil(self.iw / fw)
	local row = math.ceil(self.ih / fh)

	self.img    = img 
	self.speed  = speed
	self.pos 	= 1
	self.time   = 0
 	self.frames = {}
 	self.count  = col * row
 	self.stop   = false
	
	for i = 0, row - 1, 1 do
		for j = 0, col - 1, 1 do
			table.insert(self.frames, love.graphics.newQuad(fw * j, fh * i, fw, fh, self.iw, self.ih))
		end
	end

 	return setmetatable(self, anim)
end

function anim:draw(...)
	--TODO: Raise error here when error console implemented
	if self.pos > #self.frames then return end

	love.graphics.draw(self.img, self.frames[self.pos], ...)
end

function anim:update(dt)
	if self.stop then return end

	self.time = self.time + dt

	if self.time > self.speed then
		self.time = 0

		if self.pos < #self.frames then
			self.pos = self.pos + 1
		else
			self.pos = 1
		end
	end
end

function anim:reload(fw, fh, fc)
	--TODO: Raise error here when console implemented
	if fw > self.iw or fh > self.ih then return end

	local col   = math.ceil(self.iw / fw)
	local row   = math.ceil(self.ih / fh)

	self.count  = col * row
	count.max   = self.count
	self.frames = {}

	local c = 0

	for i = 0, row - 1, 1 do
		for j = 0, col - 1, 1 do
			if c >= fc  then return end --return if frame count reached

			c = c + 1
			table.insert(self.frames, love.graphics.newQuad(fw * j, fh * i, fw, fh, self.iw, self.ih))
		end
	end
end