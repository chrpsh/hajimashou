function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	
	txt = love.graphics.newFont("trnsgndr.ttf", 24)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    --'74K3M1'	--'K45UM1'

    unit = {}
    unit[0] = Unit(0,'74K3M1')
    unit[1] = Unit(1,'K45UM1')

	math.randomseed(os.time())
end

function setColor(name)
    if name == 'white' then
        love.graphics.setColor(255,255,255)
    elseif name == 'black' then
        love.graphics.setColor(0,0,0)
    elseif name == 'red' then
        love.graphics.setColor(255,0,0)
    elseif name == 'blue' then
        love.graphics.setColor(0,0,255)
    elseif name == 'green' then
        love.graphics.setColor(0,255,0)
    elseif name == 'yellow' then
        love.graphics.setColor(255,255,0)
    elseif name == 'cyan' then
    	love.graphics.setColor(0,255,255)
    end
end

function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then

	end
end


function love.update(dt)
	tick.update(dt)
end


function love.draw()
	setColor('blue')
	love.graphics.rectangle('fill', 0, 0, window_width/3, window_height)
	setColor('white')
	unit[0]:draw()
	unit[1]:draw()
	local width = window_width/2
	local x = window_width/3
	local y = 0
	local lh = 22
	local dmg = math.random(1,5)
	--love.graphics.printf(unit[0].name .. ' IS DIZZY, DEALS ' .. dmg .. ' pain', x, y, width)
	love.graphics.print(unit[0].name .. ' TIRED OF THEMSELF', x, y)
	love.graphics.print('DEALS ' .. dmg .. ' PAIN', x, y+lh*1)

	love.graphics.print(unit[1].name .. ' NAUSEOUS', x, y+lh*3)
	--love.graphics.print('VOMITS', x, y+lh*4)
	love.graphics.print('RECIEVES ' .. dmg .. ' PAIN', x, y+lh*4)
	--love.graphics.print(unit[1].name .. ' NAUSEOUS / DEALS ' .. dmg .. ' PAIN', x, y+lh*2)
	--love.graphics.printf('DEALS ' .. dmg .. ' PAIN', x, y+lh, width)
end