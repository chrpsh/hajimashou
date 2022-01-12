Unit = Object:extend()

function Unit:new(num, string)
	--1, 2, 3
	self.id = num
	self.stats = {math.random(0,99),math.random(0,99),math.random(0,99)}
	self.name = string
	self.x = 0
	self.y = 0 + window_height/2*num
	self.lh = 22
end


function Unit:update(dt)
end


function Unit:draw()
	love.graphics.setFont(txt)
	love.graphics.print(self.name, self.x, self.y)
	love.graphics.print('CONFUSION ' .. self.stats[1], self.x, self.y+self.lh)
	love.graphics.print('ANXIETY ' .. self.stats[2], self.x, self.y+self.lh*2)
	love.graphics.print('NAUSEA ' .. self.stats[3], self.x, self.y+self.lh*3)
end