Actions = Object:extend()

function Actions:new()
	self.line = unit[0].line
	self.x = 0-- + window_width/2*num
	self.y = window_height - self.line * 3 -2
	self.act = {'TAKE MEDS', --[['PREGABALIN',]] 'SEDATIVE', 'CRY'}
	self.hov = 1
	self.arrw = {}
	self.arrw[1] = ''
	self.arrw[2] = ''
	self.arrw[3] = ''
	--self.arrw[4] = ''
	self.show = true
end


function Actions:update(dt)
	self:hover()
end

function Actions:keyPressed(key)
	if key == "down" then
		if self.hov < 3 then
			self.hov = self.hov + 1
		else
			self.hov = 3
		end
		--self:hover()
	elseif key =="up" then
		if self.hov > 1 then
			self.hov = self.hov - 1
		else
			self.hov = 1
		end
		--self:hover()
	end

	--[[if key == "return" then
		--console(1)
		if self.hov == 1 then
			--console(1)
		elseif self.hov == 2 then
		
		elseif self.hov == 3 then

		elseif self.hov == 4 then

		end
	end]]
end


function Actions:hover()
	for i=1,3 do
		if i == self.hov then
			self.arrw[i] = '→ '
		else
			self.arrw[i] = ''
		end  
	end
end


function Actions:changed(num)
	--self.x = 0 + window_width/2*num
	self.hov = 1
end

function Actions:draw()
	--kostyl'
	--[[if self.num == 1 then
		love.graphics.print('→ ' .. self.act[1], self.x, self.y)
	else
		love.graphics.print(self.act[1], self.x, self.y)
	end

	if self.num == 2 then
		love.graphics.print('→ ' .. self.act[2], self.x, self.y+self.line)
	else
		love.graphics.print(self.act[2], self.x, self.y+self.line)
	end

	if self.num == 3 then
		love.graphics.print('→ ' .. self.act[3], self.x, self.y+self.line*2)
	else
		love.graphics.print(self.act[3], self.x, self.y+self.line*2)
	end

	if self.num == 4 then
		love.graphics.print('→ ' .. self.act[4], self.x, self.y+self.line*3)
	else
		love.graphics.print(self.act[4], self.x, self.y+self.line*3)
	end]]

	--[[local hov = {}
	hov[1] = ''
	hov[2] = ''
	hov[3] = ''
	hov[4] = '']]

	--we know that hover is num_1
	--then we need to change arrow[num_1]
	--if not num_1 not change
	--every arrow_ that is num_1 should be changed

	--if arrow[num_1] == num_1 then change
	--use num_1 address of arrow_ and change it
	--arrow[num_1] — change

	--self.arrw[self.hov] = '→ '
	
	--local not_count = {1,2,3,4}
	--local not_pos
	--[[for i,v in ipairs(not_count) do
		if self.hov == not_count[i] then not_pos = i end
	end]]
	--[[for i,v in ipairs(not_count) do
		if not i == self.hov then
			self.arrw[i] = ''
		else
			self.arrw[i] = '→ '
		end  
	end]]
	 
	--self.arrw[self.hov] = '→ '

	love.graphics.print(self.hov, self.x+100, self.y+200)

	love.graphics.print(self.arrw[1] .. self.act[1], self.x, self.y)
	love.graphics.print(self.arrw[2] .. self.act[2], self.x, self.y+self.line)
	love.graphics.print(self.arrw[3] .. self.act[3], self.x, self.y+self.line*2)
	--love.graphics.print(self.arrw[4] .. self.act[4], self.x, self.y+self.line*3)
end