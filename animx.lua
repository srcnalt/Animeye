animx = {}
animx.__index = animx

function animx.new(img, fw, fh, speed)
	local self = setmetatable({}, animx)

	local iw  = img:getHeight()
	local ih  = img:getWidth()
	local col = math.ceil(iw / fw)
	local row = math.ceil(ih / fh)

	self.img    = img 
	self.speed  = speed
	self.pos 	= 1
	self.time   = 0
 	self.frames = {}

	for i = 0, row - 1, 1 do
		for j = 0, col - 1, 1 do
			table.insert(self.frames, love.graphics.newQuad(128 * i, 128 * j, 128, 128, 128, 512))
		end
	end

 	return setmetatable(self, animx)
end

function animx:draw(...)
	love.graphics.draw(self.img, self.frames[self.pos], ...)
end

function animx:update(dt)
	self.time = self.time + dt * self.speed

	if self.time > self.speed then
		self.time = 0

		if self.pos < #self.frames then
			self.pos = self.pos + 1
		else
			self.pos = 1
		end
	end
end