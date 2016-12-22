anim = {}
anim.__index = anim

function anim.new(img, fw, fh, speed)
	local self = setmetatable({}, anim)

	local iw  = img:getWidth()
	local ih  = img:getHeight()
	local col = math.ceil(iw / fw)
	local row = math.ceil(ih / fh)

	self.img    = img 
	self.speed  = speed
	self.pos 	= 1
	self.time   = 0
 	self.frames = {}

	for i = 0, row - 1, 1 do
		for j = 0, col - 1, 1 do
			table.insert(self.frames, love.graphics.newQuad(fw * j, fh * i, fw, fh, iw, ih))
		end
	end

 	return setmetatable(self, anim)
end

function anim:draw(...)
	love.graphics.draw(self.img, self.frames[self.pos], ...)
end

function anim:update(dt)
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