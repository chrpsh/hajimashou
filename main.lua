function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	require "actions"
	
	txt = love.graphics.newFont("trnsgndr.ttf", 22)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    unit = {}
    unit[0] = Unit(0,'FUJ1N0')
    unit[1] = Unit(1,'KY0M070')

    actions = Actions() 
	
	--[[actions = {}
    actions[0] = Actions(0) 
    actions[1] = Actions(1)]]

    log = {}
    log.str = {}
    log.count = 0
    log.magic = 0
    log.work = 0

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
		
		--if actions.show and not console_show then
			actions.show = false
			console_show = true
			

			--log update
				local hov = actions.hov
				local name = unit[turn].name
				local act = {'TAKES MEDS', 'USES PREGABALIN', 'USES SEDATIVE', 'TRIES TO CRY'}
				local stat = {'NAUSEA', 'CONFUSION', 'INSOMNIA'}

				log.count = log.count + 1
				log.str[log.count] = name .. ' ' .. act[hov]
				
				log.count = log.count + 1

				if hov == 1 then
					--confusion -1, nausea -1
					--log.str[log.count] = stat[2] .. ' −1 ' .. stat[1] .. ' −1 '
					--if unit[turn].st['nausea'] > 0 then
					--	unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
					--end
					--if unit[turn].st['confusion'] > 0 then
					--	unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
					--end

					--work
					--[[	log.str[log.count] = stat[2] .. ' −1 ' .. stat[1] .. ' −1 '
						unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
						unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1 		]]
					--/work

					if log.work < 2 then
					--if unit[turn].work < 2 then
						--just you see
						--they'll work
						--just wait
						--it needs some time
						--you need to wait
						--be patient
						--not everything happens overnight
						--take it for some months and we'll see
						--or not

						--you need to wait
						log.str[log.count] = 'NOTHING HAPPENS'
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' +1 '
						unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1 
						--unit[turn].work = unit[turn].work + 1
						log.work = log.work + 1
					else
						if chance(.3) == 1 then
							log.str[log.count] = 'THEY WORK FOR SOME REASON'
							--they work
							--confusion -1, nausea -1
							log.count = log.count + 1
							log.str[log.count] = stat[1] .. ' −1 ' .. stat[2] .. ' −1 '
							unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
							unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1 
						--log.count = log.count + 1
						else
							if chance(.5) == 1 then
								log.str[log.count] = 'GOT SEROTONINE SYNDROME'
								--serotonine syndrome
								--nausea +1, insomnia +1
								log.count = log.count + 1
								log.str[log.count] = stat[1] .. ' +1 ' .. stat[3] .. ' +1 '
								unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
								unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1 
							else
								log.str[log.count] = 'IS TOLERANT'
								--tolerance
								--confusion +1
								log.count = log.count + 1
								log.str[log.count] = stat[2] .. ' +1 '
								unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1 
							end
						end
					end

					--→→→→→→→→→→→→→→→→→→→→→→→→
					
					--→→→→→→→→→→→→→→→→→→→→→→→→

				elseif hov == 2 then
					--actually feels really good
					--log.str[log.count] = 'IT FEELS REALLY GOOD'
					--log.str[log.count] = 'OK'

					--→→→→→→→→→→→→→→→→→→→→→→→→
					--first 2 times
					if log.magic < 2 then
					--if unit[turn].magic < 2 then
						log.str[log.count] = 'SURPRISINGLY FEELS GOOD'
						--it feels good
						--confusion +1
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' +1 '
						unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1
						--unit[turn].magic = unit[turn].magic + 1
						log.magic = log.magic + 1
					else
						log.str[log.count] = 'OH IT WAS JUST A SIDE EFFECT'
						--it feels good
						--confusion +1
						log.count = log.count + 1
						log.str[log.count] = 'FEELS NOTHING'
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' +1 ' .. stat[1] .. ' +1 '
						unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1
						unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
						--log.count = log.count + 1
						--log.str[log.count] = '&&&&&&&SURPRISINGLY FEELS GOOD'
						--log.count = log.count + 1
						--log.str[log.count] = stat[2] .. ' +1 '
						--unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1
						--unit[turn].magic = unit[turn].magic + 1
					end
					--after
						--miss
						--log.str[log.count] = 'MISS'
						--confusion +1
					--→→→→→→→→→→→→→→→→→→→→→→→→

				elseif hov == 3 then

					--→→→→→→→→→→→→→→→→→→→→→→→→
					if chance(.3) == 1 then
						log.str[log.count] = 'NO SUFFER BUT FOR HOW LONG'
						--log.count = log.count + 1
						--log.str[log.count] = 'BUT FOR HOW LONG'
						--eases pain
						--confusion -1, insomina -1
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
						unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
					else
						if chance(.5) == 1 then
							log.str[log.count] = 'SUDDENLY HECKING STRONG'
							log.count = log.count + 1
							log.str[log.count] = 'FELL ASLEEP'
							--oh no, it's benzodiazepine
							--fell asleep
							--confusion +1, insomnia -1
							log.count = log.count + 1
							log.str[log.count] = stat[2] .. ' +1 ' .. stat[3] .. ' −1 '
							unit[turn].st['confusion'] = unit[turn].st['confusion'] + 1
							unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
						else
							log.str[log.count] = 'FEELS NOTHING AS EXPECTED'
							--feel nothing
							--insomnia +1
							log.count = log.count + 1
							log.str[log.count] = stat[3] .. ' +1 '
							unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1
						end
					end
					--→→→→→→→→→→→→→→→→→→→→→→→→

					--[[	work stuff coll good %%%%
					log.str[log.count] = stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
					unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
					unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
					]]--

					--→→→→→→→→→→→→→→→→→→→→→→→→


					--↓↓↓ delete↓↓↓↓--

					--confusion -1, insomnia -1
					--log.str[log.count] = stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
					--if unit[turn].st['confusion'] > 0 then
					--	unit[turn].st['confusion'] = unit[turn].st['confusion'] - 1
					--end
					--if unit[turn].st['insomnia'] > 0 then
					--	unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
					--end

					--↑↑↑↑--


				elseif hov == 4 then
					--can't
					--just can't
					log.str[log.count] = 'CAN’T JUST CAN’T'
					log.count = log.count + 1
					log.str[log.count] = stat[1] .. ' +1 '
					unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
					
					---↓↓↓ unnecessary ↓↓↓---
					
						--log.count = log.count + 1
						--log.str[log.count] = 'JUST CANT'
					
					--↑↑↑↑↑↑--
				end

				--log.count = log.count + 1
				--log.str[log.count] = '——————————————————————'
				--log.count = log.count + 1
			
			--/log update

		--else
			--[[if turn == 0 then turn = 1 
			elseif turn == 1 then turn = 0 
			end]]

			actions:changed(turn)
			change_turn()

			--actions:changed(turn)
			--actions.show = true
			--console_show = false
		--end
		--end

		--show console

		
		
		--actions[1]:changed(turn)
	end
end

function chance(x)
	if math.random() < x then
		return 1
	else
		return 0
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


	--↓↓↓↓ work

	--[[for i,v in ipairs(log.str) do
		love.graphics.print(log.str[i], window_width/3, -2+line*(i-1))
	end]]

	--↑↑↑↑


	--1—30
	--4—34
	--16--46

	--log_count - 30

	--start == max - 30
	--from start to max

	local min
	local max

	local check_i = ''
	
	if log.count < 30 then
		max = table.getn(log.str)
		min = 1
	else
		 min = table.getn(log.str) - 29
		 max = table.getn(log.str)
	end

	for i=min,max do
		love.graphics.print(log.str[i], window_width/3, -2+line*(i-min))
		--check_i = check_i .. ', ' .. i
	end

	--love.graphics.print('min	' .. min, window_width/12, window_height/2+22*2)
	--love.graphics.print('max	' .. max, window_width/12, window_height/2+22*3)
	--love.graphics.print('i	' .. check_i, window_width/12, window_height/2+22*4)

	--love.graphics.print(table.getn(log.str), window_width/12, window_height/2+22)
	love.graphics.print(table.getn(log.str), window_width/12, window_height/2+22*6)
	love.graphics.print(log.count, window_width/12, window_height/2+22*7)
	
	love.graphics.print(log.magic, window_width/12, window_height/2+22*8)
	love.graphics.print(log.work, window_width/12, window_height/2+22*9)

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
		unit[1].arrw = '→ '
		unit[0].arrw = ''
	elseif turn == 0 then
		unit[0].arrw = '→ '
		unit[1].arrw = ''
	end
end


function love.draw()
	setColor('blue')
	love.graphics.rectangle('fill', 0, 0, window_width/3, window_height)
	setColor('white')
	unit[0]:draw()
	unit[1]:draw()
	
	--if actions.show then
		actions:draw()
	--end

	--love.graphics.print(log.count, window_width/12, window_height/2)
	--love.graphics.print(table.getn(log.str), window_width/12, window_height/2+22)

	--actions[turn]:draw()

	--local hov = actions.hov
	--if console_show then
	--	console(turn, hov)
	if log.str[log.count] ~= nil then
		console()
	end
	--end

	--local line = unit[0].line

	--[[if tmp_show == 1 then
		love.graphics.print(unit[0].name .. ' TAKES MEDS, THEY WORK', 0, window_height - line*2-4)
		love.graphics.print('CONFUSION −1, NAUSEA −1', 0, window_height - line*1-4)

		local w = txt:getWidth('ENTER')
		love.graphics.print('ENTER', window_width-w, window_height - line*1-4)
	end]]
end