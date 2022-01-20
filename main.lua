function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	require "actions"
	
	txt = love.graphics.newFont("trnsgndr.ttf", 22)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    unit = {}
    unit[0] = Unit(0,'M1ZUH0')
    unit[1] = Unit(1,'N0Z0M1')

    actions = Actions() 
	
	--[[actions = {}
    actions[0] = Actions(0) 
    actions[1] = Actions(1)]]

    turn = 0
    
    tmp_show = 0

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
	actions:keyPressed(key)
	--actions[0]:keyPressed(key)
	--actions[1]:keyPressed(key)

	if key == "space" then
		love.load()
	elseif key == "return" then
		--console(1)
		--tmp_show = 1
		if turn == 0 then turn = 1 
		elseif turn == 1 then turn = 0 
		end
		actions:changed(turn)
		--actions[1]:changed(turn)
	end
end

function console(unit, hov)
	local line = unit[0].line

	--unit_num --hov_num

	local name = unit[unit].name
	local str = {'TOOK MEDS', 'USED PREGABALIN', 'USED SEDATIVE', 'TRIED TO CRY'}

	love.graphics.print(name .. ' ' .. str[hov], 0, window_height - line*2-4)

	local w = txt:getWidth('ENTER')
	love.graphics.print('ENTER', window_width-w, window_height - line*1-4)
end

function love.update(dt)
	tick.update(dt)
	actions:update(dt)
	--actions[0]:update(dt)
	--actions[1]:update(dt)
end


function love.draw()
	unit[0]:draw()
	unit[1]:draw()
	actions:draw()
	--actions[turn]:draw()

	--local hov = unit[turn].hov
	--console(turn, hov)

	--local line = unit[0].line

	--[[if tmp_show == 1 then
		love.graphics.print(unit[0].name .. ' TAKES MEDS, THEY WORK', 0, window_height - line*2-4)
		love.graphics.print('CONFUSION −1, NAUSEA −1', 0, window_height - line*1-4)

		local w = txt:getWidth('ENTER')
		love.graphics.print('ENTER', window_width-w, window_height - line*1-4)
	end]]
end