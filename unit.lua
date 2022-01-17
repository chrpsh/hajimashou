Unit = Object:extend()

function Unit:new(num, string)
	self.id = num
	self.name = string
	self.st = {}
	self.st['nausea'] = math.random(0,2)
	self.st['confusion'] = math.random(1,3)
	self.st['insomnia'] = math.random(1,2)
	self.line = 20
	self.x = 0 + window_width/2*num
	self.y = -2
end


function Unit:update(dt)
end


function Unit:draw()
	love.graphics.setFont(txt)
	love.graphics.print(self.name, self.x, self.y)
	love.graphics.print('NAUSEA ' .. self.st['nausea'], self.x, self.y+self.line)
	love.graphics.print('CONFUSION ' .. self.st['confusion'], self.x, self.y+self.line*2)
	love.graphics.print('INSOMNIA ' .. self.st['insomnia'], self.x, self.y+self.line*3)

	--[[local w = txt:getWidth('CONFUSION') + 10
	love.graphics.print('NAUSEA', self.x, self.y+self.line)
	love.graphics.print(self.st['nausea'], self.x+w, self.y+self.line)
	love.graphics.print('CONFUSION', self.x, self.y+self.line*2)
	love.graphics.print(self.st['confusion'], self.x+w, self.y+self.line*2)
	love.graphics.print('INSOMNIA', self.x, self.y+self.line*3)
	love.graphics.print(self.st['insomnia'], self.x+w, self.y+self.line*3)]]
end