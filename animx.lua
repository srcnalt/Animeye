local anim = {}
anim.__index = anim

function anim.new(img, fw, fh, speed)
	local iw = image:getHeight()
	local ih = image:getWidth()

	self.img    = imag 
	self.fw     = fw 
	self.fh     = fh
	self.speed  = speed
	self.row    = iw / fh
	self.col    = ih / fw
 	self.count  = row * col
 	self.frames = {}

 	for i = 0, col, 1 do
 		for j = 0, row, 1 do
	 		table.insert(self.frames, love.graphics.newQuad(i*fw, j*fh, fw, fh, iw, ih))
	 	end
 	end

 	return setmetatable(self, anim)
end