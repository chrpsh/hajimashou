Unit = Object:extend()

function Unit:new(num)
	self.id = num
	self.x = 0 + 200*num
	self.hp = 100
	self.attack = 1
	
	self.talk = {'KISAMA', 'MASAKA', 'TATAKAE', 'SHINEE', 'KUROSU', 'ARA ARA', 'SATTE TO', 'HAJIMEMASHOU', 'WARUKATTA', 'SHIMATTA', 'YARE YARE', 'AHO', 'BAKA'}
	
	--self.win = {'おまえはもうしんでいる'}

	self.log = {}
	self.log.hp = {}

	--t = math.random(1,3)
end


function Unit:update(dt)

end


function Unit:draw()
	love.graphics.setFont(comm)

	if self.hp > 0 then
		love.graphics.print('#' .. self.id, self.x, 14*0)
		love.graphics.print('LOV ' .. self.hp, self.x, 14*1)
		love.graphics.print('HAT ' .. self.attack, self.x, 14*2)
		if self.log.hp[turn] ~= self.log.hp[turn-1] and self.log.hp[turn-1] ~= nil and self.log.hp[turn] ~= nil then
			local hp_width = comm:getWidth('HAP' .. self.hp)
			local hp_diff = self.log.hp[turn-1] - self.log.hp[turn]
			love.graphics.print(' (−' .. hp_diff .. ')', hp_width + self.x, 14*1)
			love.graphics.print('>' .. self.talk[phrase_num] .. '!', self.x, 14*4)
			--love.graphics.setFont(jap)
			--love.graphics.print('>きさま', self.x, 14*3)
			--love.graphics.setFont(comm)
		end
		--love.graphics.print('HAT ' .. math.floor(self.attack/2), self.x, 14*3)
		--love.graphics.print('LOV ' .. math.floor(self.attack/33), self.x, 14*4)
		love.graphics.print('SAD ' .. math.floor(self.attack/4*3), self.x, 14*3)
		--love.graphics.print('ANX ' .. self.hp - self.attack*3, self.x, 14*6)
		--local size = table.getn(self.words)
		--local num = math.random(1,size)
		
		--love.graphics.print('—' .. self.words[num], self.x, 14*3)
	else
		set_color('red')
		--love.graphics.print('***', self.x, 14*0)
		love.graphics.print('DIED', self.x, 14*0)
		love.graphics.print('DIED', self.x, 14*1)
		love.graphics.print('×××', self.x, 14*2)
		set_color('white')
	end



	--[[if self.log.hp[turn] ~= nil then
		love.graphics.print('LOG' .. self.log.hp[turn], self.x, 14*2)
	end
	if self.log.hp[turn-1] ~= nil then
		love.graphics.print('LOG←' .. self.log.hp[turn-1], self.x, 14*3)
	end]]

end