Unit = Object:extend()

function Unit:new(num, string)
	self.id = num
	self.name = string
	self.st = {}
	self.st['nausea'] = math.random(3,5)
	self.st['irritation'] = math.random(3,5)
	self.st['insomnia'] = math.random(2,5)
	self.line = 20
	self.x = 0
	self.y = self.line*5*num -2
	self.arrw = ''
	self.st.last = {}
	self.st.last['nausea'] = self.st['nausea']
	self.st.last['irritation'] = self.st['irritation']
	self.st.last['insomnia'] = self.st['insomnia']
	self.magic = 0
	self.work = 0
end

function Unit:update(dt)
end

function Unit:diff(str)
	if self.st[str] ~= self.st.last[str] then
		if self.st[str] > self.st.last[str] then
			return ' +' .. self.st[str] - self.st.last[str]
		else
			return ' −' .. self.st.last[str] - self.st[str]
		end
	end
	return ''
end

function Unit:draw()
	love.graphics.setFont(txt)
	love.graphics.print(self.name, self.x, self.y)
	love.graphics.print('NAUSEA ' .. self.st['nausea'], self.x, self.y+self.line)
	love.graphics.print('IRRITATION ' .. self.st['irritation'], self.x, self.y+self.line*2)
	love.graphics.print('INSOMNIA ' .. self.st['insomnia'], self.x, self.y+self.line*3)
end