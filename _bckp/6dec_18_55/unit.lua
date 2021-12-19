Unit = Object:extend()

function Unit:new(num)
	self.num = num
	self.x = 0 + 200*num
	
	self.level = 1
	self.exp = {}
	self.exp.total = 1
	self.exp.new = 0
	--self.threshold = {10, 10*2, 10*3, 10*4, 10*5}
	self.threshold = {}

	for i=1,100 do
		self.threshold[i] = 5*i
	end

	self.health = {}
	self.health.total = 100
	self.health.lost = 0
	self.attack = 1
	self.defense = 0
	self.sadness = 0
	self.damage = self.attack - self.sadness

	self.log = {}
	self.log.level = {}
	--self.log.level = {}
	self.log.exp = {}
	self.log.exp.total = {}
	self.log.exp.new = {}
	self.log.attack = {}
	self.log.damage = {}
	self.log.defense = {}
	self.log.sadness = {}

	self.isLevelup = false
end


function Unit:update(dt)

end


function Unit:draw()
	love.graphics.setFont(comm)
	love.graphics.print('u_' .. self.num, self.x, 14*0)
	love.graphics.print('level ' .. self.level, self.x, 14*1)

	if self.log.level[step-1] or self.log.level[step-2] --[[self.level ~= self.log.level[step-1]] --[[self.isLevelup]] then
		local margin = comm:getWidth('level ' .. self.level)
		set_color('green')
		love.graphics.print(' UP!', self.x + margin, 14*1)
		set_color('white')
	end


	love.graphics.print('experience ' .. self.exp.total, self.x, 14*2)

	if step >= 1 and self.log.exp.total[step] - self.log.exp.total[step-1] > 0 then
		local margin = comm:getWidth('experience ' .. self.exp.total)
		local new_exp = self.log.exp.total[step] - self.log.exp.total[step-1]
		set_color('yellow')
		love.graphics.print(' (+' .. new_exp .. ')', self.x + margin, 14*2)
		set_color('white')
	end


	--[[if self.exp.new ~= 0 then
		local margin = comm:getWidth('experience ' .. self.exp.total)
		set_color('yellow')
		love.graphics.print(' (+' .. self.exp.new .. ')', self.x + margin, 14*2)
		set_color('white')
	end]]

	--if not self.exp.new == 0 then
	--	love.graphics.print('experience ' .. self.exp.total .. ' (+' .. self.exp.new .. ')', self.x, 14*2)
	--else
		--love.graphics.print('experience ' .. self.exp.total, self.x, 14*2)
	--end
	love.graphics.print('health ' .. self.health.total, self.x, 14*3)

	if self.health.lost ~= 0 then
		local margin = comm:getWidth('health ' .. self.health.total)
		set_color('red')
		love.graphics.print(' (−' .. self.health.lost .. ')', self.x + margin, 14*3)
		set_color('white')
	end
	--set_color('green')
	love.graphics.print('attack ' .. self.attack, self.x, 14*4)
	--set_color('blue')
	love.graphics.print('sadness ' .. self.sadness, self.x, 14*5)
	--set_color('white')
	--love.graphics.print('defense ' .. self.defense, self.x, 14*3)
end