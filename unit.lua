Unit = Object:extend()

function Unit:new(num, name)
	self.id = num
	self.width = comm:getWidth('H') * 6
	if num == 0 then
		self.x = 0
		--self.y = 0 + 140*num
	else
		self.x = window_width - self.width
		--self.y = 0 + 140*(num-4)
	end

	self.y = 0
	

	self.name = name

	self.hp = 30
	self.att = math.random(3,5)
	self.def = math.random(1,2)
	self.sad = math.random(0,1)
	--self.anx = math.random(0,1)
	self.irr = math.random(0,1)
	self.crit = 0
	
	--self.talk = {'KISAMA', 'MASAKA', 'TATAKAE', 'SHINEE', 'KUROSU', 'ARA ARA', 'SATTE TO', 'HAJIMEMASHOU', 'WARUKATTA', 'SHIMATTA', 'YARE YARE', 'AHO', 'BAKA'}

	self.log = {}
	self.log.hp = {}
	self.log.att = {}
	self.log.def = {}
	self.log.sad = {}
	--self.log.anx = {}
	self.log.irr = {}
	self.log.crit = {}
end


function Unit:update(dt)
end


function Unit:draw()
	love.graphics.setFont(comm)
	if self.hp > 0 then
		--love.graphics.print('>>' .. self.id, self.x, 14*0)
		love.graphics.print(self.name, self.x, self.y+14*0)
		
		love.graphics.print('HP ' .. self.hp, self.x, self.y+14*1)
		if self.log.hp[turn] ~= self.log.hp[turn-1] and self.log.hp[turn-1] ~= nil and self.log.hp[turn] ~= nil then
			local hp_width = comm:getWidth('HP ' .. self.hp)
			local hp_diff = self.log.hp[turn-1] - self.log.hp[turn]
			set_color('red')
			love.graphics.print(' −' .. hp_diff, hp_width + self.x, self.y+14*1)
			set_color('white')
		end

		--love.graphics.print('ATT ' .. self.att, self.x, 14*2)
		
		if self.log.att[turn] ~= self.log.att[turn-1] and self.log.att[turn-1] ~= nil and self.log.att[turn] ~= nil then
			love.graphics.print('ATT ' .. self.log.att[turn-1], self.x, self.y+14*2)
			local att_width = comm:getWidth('ATT ' .. self.log.att[turn-1])
			local att_diff = self.log.att[turn] - self.log.att[turn-1]
			set_color('yellow')
			love.graphics.print(' +' .. att_diff, att_width + self.x, self.y+14*2)
			set_color('white')
		else
			love.graphics.print('ATT ' .. self.att, self.x, self.y+14*2)
		end

		--love.graphics.print('DEF ' .. self.def, self.x, 14*3)
		if self.log.def[turn] ~= self.log.def[turn-1] and self.log.def[turn-1] ~= nil and self.log.def[turn] ~= nil then
			love.graphics.print('DEF ' .. self.log.def[turn-1], self.x, self.y+14*3)
			local def_width = comm:getWidth('DEF ' .. self.log.def[turn-1])
			local def_diff = self.log.def[turn] - self.log.def[turn-1]
			set_color('green')
			love.graphics.print(' +' .. def_diff, def_width + self.x, self.y+14*3)
			set_color('white')
		else
			love.graphics.print('DEF ' .. self.def, self.x, self.y+14*3)
		end

		love.graphics.print('SAD ' .. self.sad, self.x, self.y+14*4)
		--love.graphics.print('ANX ' .. self.anx, self.x, self.y+14*4)
		--love.graphics.print('IRR ' .. self.irr, self.x, self.y+14*5)

		--love.graphics.print('DEF ' .. self.hp, self.x, 14*1)
	else
		set_color('red')
		love.graphics.print('DIED', self.x, self.y+14*0)
		love.graphics.print('DIED', self.x, self.y+14*1)
		love.graphics.print('×××', self.x, self.y+14*2)
		set_color('white')
	end
end