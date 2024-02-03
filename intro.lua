Intro = Object:extend()

function Intro:new()
	self.line = unit[0].line
	self.img = {}
	self.img[1] = ''
	self.img[2] = ''
	self.text = {}
	self.text[1] = 'DEVELOPED BY'
	self.text[2] = 'PUBLISHED BY'
	self.width = {}
	self.width.text = txt:getWidth(self.text[1])
	self.x = (window_width - self.width.text) / 2
	self.y = window_height - self.line -2
	self.show = 1
	self.n = 1
	self.image = {}
	self.image[1] = love.graphics.newImage('logo_1_140px.png')
	self.image[2] = love.graphics.newImage('logo_2.png')
	self.height = 0

end


function Intro:update(dt)
end

function Intro:keyPressed(key)
	--local n = 1
	if key == "return" then
		if self.n == 1 then
			self.n = self.n+1
			self.width = txt:getWidth(self.text[self.n])
			self.x = (window_width - self.width) / 2
			self.show = self.show + 1
		elseif self.n == 2 then
			self.show = self.show + 1
		end
	end
end


function Intro:draw()
	local x = (window_width - self.image[self.n]:getWidth())/2
	local y = (window_height - self.image[self.n]:getHeight())/2
	love.graphics.draw(self.image[self.n], x, y)
	love.graphics.print(self.text[self.n], self.x, self.y)
	--[[if self.show then
		love.graphics.print('TRUE', self.x, self.y-self.line)
	else
		love.graphics.print('FALSE', self.x, self.y-self.line)
	end]]
end