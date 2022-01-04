Unit = Object:extend()

function Unit:new(num, name)
	self.id = num
	self.width = comm:getWidth('H') * 7
	
	if num == 0 then
		self.x = 0
	else
		self.x = window_width - self.width
	end

	--[[if num < 4 then
		self.x = 0
		self.y = 0 + 100*num
	elseif num >= 4 then
		self.x = window_width - self.width
		self.y = 0 + 100*(num-4)
	end]]

	self.y = 0
	
	self.name = name

	self.stat = {}
	self.stat['hp'] = 30
	self.stat['att'] = math.random(3,5)
	self.stat['def'] = math.random(1,2)
	self.stat['sad'] = math.random(0,1)
	self.stat['irr'] = 1
	self.stat['anx'] = 0
	
	self.log = {}
	self.log['hp'] = {}
	self.log['att'] = {}
	self.log['def'] = {}
	self.log['sad'] = {}
	self.log['irr'] = {}
	self.log['anx'] = {}
	self.log['crit'] = {}
	self.log['miss'] = {}

	--old ↓

	--[[self.hp = 30
	self.att = self.stat['att']--math.random(3,5)
	self.def = math.random(1,2)
	self.sad = math.random(0,1)
	self.irr = 1
	self.anx = 0]]
	
	--good, use
	self.crit = 0
	self.miss = 0
	--//

	--[[self.log = {}
	self.log.hp = {}
	self.log.att = {}
	self.log.def = {}
	self.log.sad = {}
	self.log.anx = {}
	self.log.irr = {}
	self.log.crit = {}
	self.log.miss = {}]]
end


function Unit:update(dt)
end


function Unit:draw()
	love.graphics.setFont(comm)
	if self.stat['hp'] > 0 then
		love.graphics.print(self.name, self.x, self.y+14*0)
		
		love.graphics.print('HP ' .. self.stat['hp'], self.x, self.y+14*1)
		if self.log['hp'][turn] ~= self.log['hp'][turn-1] and self.log['hp'][turn-1] ~= nil and self.log['hp'][turn] ~= nil then
			local hp_width = comm:getWidth('HP ' .. self.stat['hp'])
			local hp_diff = self.log['hp'][turn-1] - self.log['hp'][turn]
			set_color('red')
			love.graphics.print(' −' .. hp_diff, hp_width + self.x, self.y+14*1)
			set_color('white')
		end

		if self.stat['att'] ~= self.log['att'][turn-1] and self.log['att'][turn-1] ~= nil and self.log['att'][turn] ~= nil then
			love.graphics.print('ATT ' .. self.log['att'][turn-1], self.x, self.y+14*2)
			local att_width = comm:getWidth('ATT ' .. self.log['att'][turn-1])
			local att_diff = self.stat['att'] - self.log['att'][turn-1]
			if self.stat['att'] > self.log['att'][turn-1] then
				set_color('yellow')
				love.graphics.print(' +' .. att_diff, att_width + self.x, self.y+14*2)
			else
				set_color('red')
				love.graphics.print(' ' .. att_diff, att_width + self.x, self.y+14*2)
			end
			set_color('white')
		else
			love.graphics.print('ATT ' .. self.stat['att'], self.x, self.y+14*2)
		end

		if self.stat['def'] ~= self.log['def'][turn-1] and self.log['def'][turn-1] ~= nil and self.log['def'][turn] ~= nil then
			love.graphics.print('DEF ' .. self.log['def'][turn-1], self.x, self.y+14*3)
			local def_width = comm:getWidth('DEF ' .. self.log['def'][turn-1])
			local def_diff = self.stat['def'] - self.log['def'][turn-1]
			if self.stat['def'] > self.log['def'][turn-1] then
				set_color('green')
				love.graphics.print(' +' .. def_diff, def_width + self.x, self.y+14*3)
			else
				set_color('red')
				love.graphics.print(' ' .. def_diff, def_width + self.x, self.y+14*3)
			end
			set_color('white')
		else
			love.graphics.print('DEF ' .. self.stat['def'], self.x, self.y+14*3)
		end

		if self.stat['sad'] ~= self.log['sad'][turn-1] and self.log['sad'][turn-1] ~= nil and self.log['sad'][turn] ~= nil then
			love.graphics.print('SAD ' .. self.log['sad'][turn-1], self.x, self.y+14*4)
			local sad_width = comm:getWidth('SAD ' .. self.log['sad'][turn-1])
			local sad_diff = self.stat['sad'] - self.log['sad'][turn-1]
			set_color('red')
			if self.stat['sad'] > self.log['sad'][turn-1] then
				love.graphics.print(' +' .. sad_diff, sad_width + self.x, self.y+14*4)
			else
				love.graphics.print(' ' .. sad_diff%1, sad_width + self.x, self.y+14*4)
			end
			set_color('white')
		else
			love.graphics.print('SAD ' .. self.stat['sad'], self.x, self.y+14*4)
		end

		if self.stat['irr'] ~= self.log['irr'][turn-1] and self.log['irr'][turn-1] ~= nil and self.stat['irr'] ~= nil then
			love.graphics.print('IRR ' .. self.log['irr'][turn-1], self.x, self.y+14*5)
			local irr_width = comm:getWidth('IRR ' .. self.log['irr'][turn-1])
			local irr_diff = self.stat['irr'] - self.log['irr'][turn-1]
			set_color('red')
			love.graphics.print(' +' .. irr_diff, irr_width + self.x, self.y+14*5)
			set_color('white')
		else
			love.graphics.print('IRR ' .. self.stat['irr'], self.x, self.y+14*5)
		end

		if self.stat['irr'] >= 1.6 then
			set_color('red')
			local h = 14
			love.graphics.rectangle('fill', self.x, self.y+14*6+2, h, h)
			
			love.graphics.print(' SHIT', self.x + h, self.y+14*6)
			set_color('white')
		end

		if self.stat['sad'] >= 1.6 then
			set_color('yellow')
			local h = 14
			love.graphics.rectangle('fill', self.x, self.y+14*7+2, h, h)
			love.graphics.print(' FUCK', self.x + h, self.y+14*7)
			set_color('white')
		end
	else
		set_color('red')
		love.graphics.print('DIED', self.x, self.y+14*0)
		love.graphics.print('DIED', self.x, self.y+14*1)
		love.graphics.print('×××', self.x, self.y+14*2)
		set_color('white')
	end
end