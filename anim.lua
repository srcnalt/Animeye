anim = {}
anim.__index = anim

function anim.new(img, fw, fh, speed)
	local self = setmetatable({}, anim)

	self.iw  	= img:getWidth()
	self.ih  	= img:getHeight()

	self.col = math.ceil(self.iw / fw)
	self.row = math.ceil(self.ih / fh)

	self.img    = img 
	self.speed  = speed
	self.pos 	= 1
	self.time   = 0
 	self.frames = {}
 	self.count  = self.col * self.row
 	self.stop   = false
	
	for i = 0, self.row - 1, 1 do
		for j = 0, self.col - 1, 1 do
			table.insert(self.frames, love.graphics.newQuad(fw * j, fh * i, fw, fh, self.iw, self.ih))
		end
	end

 	return setmetatable(self, anim)
end

function anim:draw(...)
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

function anim:reload(fw, fh)
	self.frames = {}

	for i = 0, self.row - 1, 1 do
		for j = 0, self.col - 1, 1 do
			table.insert(self.frames, love.graphics.newQuad(fw * j, fh * i, fw, fh, self.iw, self.ih))
		end
	end
end