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

    log = {}
    log.str = {}
    log.count = 1

    turn = 0

    console_show = false
    
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

		--showing actions
		--choosing action
		--hide actions
		--show result
		--enter
		--showing actions

		--if actions.active then
		if actions.show and not console_show then
			actions.show = false
			console_show = true

			--log update
				local hov = actions.hov
				local name = unit[turn].name
				local act = {'TAKES MEDS', 'USES PREGABALIN', 'USES SEDATIVE', 'TRIES TO CRY'}
				local stat = {'NAUSEA', 'CONFUSION', 'INSOMNIA'}

				log.str[log.count] = name .. ' ' .. act[hov]
				log.count = log.count + 1

				if hov == 1 then
					--confusion -1, nausea -1
					log.str[log.count] = stat[2] .. ' −1 ' .. stat[1] .. ' −1 '
					--if unit[turn].st['nausea'] > 0 then
						unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
					--end
					--if unit[turn].st['confusion'] > 0 then
						unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
					--end
				elseif hov == 2 then
					--actually feels really good
					log.str[log.count] = 'IT FEELS REALLY GOOD'
				elseif hov == 3 then
					--confusion -1, insomnia -1
					log.str[log.count] = stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
					--if unit[turn].st['confusion'] > 0 then
						unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
					--end
					--if unit[turn].st['insomnia'] > 0 then
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
					--end
				elseif hov == 4 then
					--can't
					--just can't
					log.str[log.count] = 'CAN’T, JUST CAN’T'
					--log.count = log.count + 1
					--log.str[log.count] = 'JUST CANT'
				end

				log.count = log.count + 1
				--log.str[log.count] = '——————————————————————'
				--log.count = log.count + 1
			
			--/log update

		else
			--[[if turn == 0 then turn = 1 
			elseif turn == 1 then turn = 0 
			end]]

			change_turn()

			actions:changed(turn)
			actions.show = true
			console_show = false
		end
		--end

		--show console

		
		
		--actions[1]:changed(turn)
	end
end

function change_turn()
	unit[turn].st.last['nausea'] = unit[turn].st['nausea']
	unit[turn].st.last['confusion'] = unit[turn].st['confusion']
	unit[turn].st.last['insomnia'] = unit[turn].st['insomnia']

	if turn == 0 then 
		turn = 1 
	elseif turn == 1 then 
		turn = 0 
	end
end

function console()--num, hov)
	local line = unit[turn].line

	--action_1
		--name
		--action
	--log_1
		--name -- action

	--unit_num --hov_num

	for i,v in ipairs(log.str) do
		love.graphics.print(log.str[i], window_width/3, -2+line*(i-1))
	end



	--local name = unit[num].name
	--local str = {'TOOK MEDS', 'USED PREGABALIN', 'USED SEDATIVE', 'TRIED TO CRY'}

	--love.graphics.print(name .. ' ' .. str[hov], window_width/3, -2)--window_height - line*1-4)

	--local w = txt:getWidth('ENTER')
	--love.graphics.print('ENTER', window_width-w, window_height - line*1-4)
end

function love.update(dt)
	tick.update(dt)
	actions:update(dt)
	--actions[0]:update(dt)
	--actions[1]:update(dt)
	if turn == 1 then
		unit[1].arrw = '→'
		unit[0].arrw = ''
	elseif turn == 0 then
		unit[0].arrw = '→'
		unit[1].arrw = ''
	end
end


function love.draw()
	setColor('blue')
	love.graphics.rectangle('fill', 0, 0, window_width/3, window_height)
	setColor('white')
	unit[0]:draw()
	unit[1]:draw()
	
	if actions.show then
		actions:draw()
	end
	--actions[turn]:draw()

	--local hov = actions.hov
	--if console_show then
	--	console(turn, hov)
		console()
	--end

	--local line = unit[0].line

	--[[if tmp_show == 1 then
		love.graphics.print(unit[0].name .. ' TAKES MEDS, THEY WORK', 0, window_height - line*2-4)
		love.graphics.print('CONFUSION −1, NAUSEA −1', 0, window_height - line*1-4)

		local w = txt:getWidth('ENTER')
		love.graphics.print('ENTER', window_width-w, window_height - line*1-4)
	end]]
end