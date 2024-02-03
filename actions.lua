Actions = Object:extend()

function Actions:new()
	self.line = unit[0].line
	self.x = 0
	self.y = window_height - self.line * 3 -2
	self.act = {'TAKE MEDS', --[['PREGABALIN',]] 'SEDATIVE', 'CRY'}
	self.hov = 1
	self.arrw = {}
	self.arrw[1] = ''
	self.arrw[2] = ''
	self.arrw[3] = ''
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
	elseif key =="up" then
		if self.hov > 1 then
			self.hov = self.hov - 1
		else
			self.hov = 1
		end
	end
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
	self.hov = 1
end

function Actions:draw()
	love.graphics.print(self.hov, self.x+100, self.y+200)
	love.graphics.print(self.arrw[1] .. self.act[1], self.x, self.y)
	love.graphics.print(self.arrw[2] .. self.act[2], self.x, self.y+self.line)
	love.graphics.print(self.arrw[3] .. self.act[3], self.x, self.y+self.line*2)
end