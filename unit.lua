Unit = Object:extend()

function Unit:new(num, string)
	self.id = num
	self.name = string
	self.st = {}
	self.st['nausea'] = math.random(0,2)
	self.st['confusion'] = math.random(1,3)
	self.st['insomnia'] = math.random(1,2)
	self.line = 20
	self.x = 0 --+ window_width/2*num
	self.y = self.line*5*num -2
	self.arrw = ''

	self.st.last = {}
	self.st.last['nausea'] = self.st['nausea']
	self.st.last['confusion'] = self.st['confusion']
	self.st.last['insomnia'] = self.st['insomnia']

	--self.st.change = {}
end


function Unit:update(dt)
end

function Unit:diff(str)
	if self.st[str] ~= self.st.last[str] then
		if self.st[str] > self.st.last[str] then
			--self.st.change[str] = '+' .. self.st[str] - self.st.last[str]
			return ' +' .. self.st[str] - self.st.last[str]
		else
			--self.st.change[str] = '−' .. self.st.last[str] - self.st[str]
			return ' −' .. self.st.last[str] - self.st[str]
		end
	end
	return ''
end

function Unit:draw()
	love.graphics.setFont(txt)
	love.graphics.print(self.arrw .. self.name, self.x, self.y)
	love.graphics.print('NAUSEA ' .. self.st['nausea'] .. self:diff('nausea'), self.x, self.y+self.line)
	love.graphics.print('CONFUSION ' .. self.st['confusion'] .. self:diff('confusion'), self.x, self.y+self.line*2)
	love.graphics.print('INSOMNIA ' .. self.st['insomnia'] .. self:diff('insomnia'), self.x, self.y+self.line*3)


	--[[local str = 'nausea'
	love.graphics.print(self:diff(str), self.x, self.y+self.line*8)
	

	if self.st[str] == nil then
		love.graphics.print('FUCK YOU .STAT', self.x, self.y+self.line*9)
	end
	if self.st.last[str] == nil then
		love.graphics.print('FUCK YOU .STAT.LAST', self.x, self.y+self.line*10)
	end]]

	--[[local w = txt:getWidth('CONFUSION') + 10
	love.graphics.print('NAUSEA', self.x, self.y+self.line)
	love.graphics.print(self.st['nausea'], self.x+w, self.y+self.line)
	love.graphics.print('CONFUSION', self.x, self.y+self.line*2)
	love.graphics.print(self.st['confusion'], self.x+w, self.y+self.line*2)
	love.graphics.print('INSOMNIA', self.x, self.y+self.line*3)
	love.graphics.print(self.st['insomnia'], self.x+w, self.y+self.line*3)]]
end