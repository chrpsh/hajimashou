function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"

	comm = love.graphics.newFont("trnsgndr.ttf", 14)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	unit = {}
	
	local names = {
	[0]='XÆA-12', 'RX-78-2'}

	for i=0,1 do
		unit[i] = Unit(i, names[i])
	end

	turn = 1

	log = {}
	log.moves = {}
	log.moves.a = {}
	log.moves.b = {}

	showresult = false

	rand_chance = 0

	crit_check = {}
	crit_check_counter = {}
	ch = false

	math.randomseed(os.time())

	--start = false

	--tick.delay(function() start = true end, .6)

	--if start then
		--[[tick.recur(function() 
			if unit[0].hp > 0 and unit[1].hp > 0 then
				if showresult then
					nextturn()
					showresult = false
				end
				if (turn % 2 == 0) then
					attack(1, 0)
				else
					attack(0, 1)
				end
				showresult = true
			end
		 end, .6)]]
	--end
end


function set_color(name)
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


function chance(x)
	rand_chance = math.random()
	if rand_chance < x then
		return 1
	else
		return 0
	end
end

function attack(a, b)
	unit[a].log.hp[turn-1] = unit[a].hp
	unit[a].log.att[turn-1] = unit[a].att
	unit[a].log.def[turn-1] = unit[a].def
	unit[a].log.sad[turn-1] = unit[a].sad

	unit[b].log.hp[turn-1] = unit[b].hp
	unit[b].log.att[turn-1] = unit[b].att
	unit[b].log.def[turn-1] = unit[b].def
	unit[b].log.sad[turn-1] = unit[b].sad
	
	--[[if chance(30) then
		unit[a].att = 99
	end]]	

	--30% then att*3 else att


	
	--att
	--def
	--sad
	--irr
	--anx

	--drone
		--1 note from lsdj

	--tranqualizer
		--oh no it's strong benzodiazepine, %% fall asleep for 2 turns
		--lower irritation and anxiety
		--oh no, it's too easy tranqualizer for you
			--(if one of stats higher than)
			--has no effects
			--sad +1
	--antidepressant
		--oh no, it's not your class of antitepressants, you have syrotonine syndrom already
			--all negative stats maximazed
		--cool, u got antidepressant, it'll work in 3 months, or maybe not



	--yesterday
		--possibility of attack (% that attack landed)
		--chance of crit
		--sadness (−.5 atta)
		--dexterity (possible baff? or debaff?)
		--

		--attack
			--strength
			--accuracy
			--motivation / will to perform
				--sadness (unwill to perform)
				--love (will to not do war)
				--hatred (will to war)
				--tiredness (unwill to perform)
			--defence of opponnent

		--level
			--up stats

		--events
			--sadness overflow
				--no motivation
				--disabled
			--love prevails
				--no motivation to war
				--no counters
				--no attacks
				--high defense (all stats go to defense)
			--hatred rules
				--no love (+motivation to those with high love)
				--high attack
				--no defence (all defence go to attack)
				--accuracy /2
			--if two with love make move to each other, game won by peace
			--if two by war/hatred attack each other, game over by extinction
			--if all units disabled, game ends due to meaningless
			--if two tired units make turn against each other, they just go home and turn delayed for somethung later sometime
	
	if not crit_check[turn] then
		ch = chance(.2)
		crit_check[turn] = true
	end

	if not crit_check_counter[turn] then
		ch_c = chance(.2)
		crit_check_counter[turn] = true
	end

	--if ch then
	--	unit[a].att = 66
	--end

	local dmg = unit[a].att + unit[a].att*2*ch - unit[b].def - unit[a].sad--math.floor(unit[a].sad*.5)

	if dmg < 0 then
		dmg = 0
	end

	unit[b].hp = unit[b].hp - dmg


	if unit[b].def >= unit[a].def then
		local dmg_c = unit[b].att + unit[b].att--[[*2*ch_c]] - unit[a].def - unit[b].sad--math.floor(unit[a].sad*.5)

		if dmg_c < 0 then
			dmg_c = 0
		end

		unit[a].hp = unit[a].hp - dmg_c
	end


	--unit[a].att = unit[a].att + math.random(0,7)

	unit[a].log.hp[turn] = unit[a].hp
	unit[a].log.def[turn] = unit[a].def	
	unit[a].log.att[turn] = unit[a].att
	unit[a].log.sad[turn] = unit[a].sad

	unit[b].log.hp[turn] = unit[b].hp
	unit[b].log.def[turn] = unit[b].def
	unit[b].log.att[turn] = unit[b].att
	unit[b].log.sad[turn] = unit[b].sad

	--if chance(30) then
	--	unit[a].att = unit[a].log.att[turn-1]
	--end	

	--unit[b].def = unit[b].def + math.random(0,7)

	log.moves.a[turn] = a
	log.moves.b[turn] = b
end

function getcenter(str)
	return (window_width - comm:getWidth(str))/2
end

function nextturn()
	turn = turn + 1
end

function autoplay()
	tick.recur(function() 
		if unit[0].hp > 0 and unit[1].hp > 0 then
			if showresult then
				nextturn()
				showresult = false
			end
			if (turn % 2 == 0) then
				attack(1, 0)
			else
				attack(0, 1)
			end
			showresult = true
		end
	end, .6)
end

function displayinfo ()
	if showresult then
		local a = log.moves.a[turn]
		local b = log.moves.b[turn]
		--local a_name = ''
		--local b_name = ''

		--[[if turn % 2 == 0 then
			a_name = 'UH'
			b_name = 'MEH'
		else
			a_name = 'MEH'
			b_name = 'UH'
		end]]

		local hp_diff = 0

		if unit[b].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
			hp_diff = unit[b].log.hp[turn-1] - unit[b].log.hp[turn]
		end

		local t_str = 'TURN ' .. turn
		local t_x = getcenter(t_str)
		--local t_x = (window_width-comm:getWidth(t_str))/2
		love.graphics.print(t_str, t_x, window_height-14*3)

		--[[love.graphics.print('__' .. a .. ' HURTS __' .. b .. ' WITH ' .. hp_diff, 0, window_height/2+14*2)
		local per = math.floor(hp_diff * 100 / unit[b].log.hp[turn])
		love.graphics.print('(LOSES ' .. per .. '% OF SELF)', 0, window_height/2+14*3)]]

		--love.graphics.print(unit[a].name .. ' HURTS ' .. unit[b].name .. ' (HAS ' .. unit[b].def .. ' DEF) WITH ' .. hp_diff, 0, window_height/2+14*2)
		--love.graphics.print(unit[a].name .. ' →→ ' .. unit[b].name, 0, window_height/2+14*2)
		
		local n_str = unit[a].name .. ' →→ ' .. unit[b].name
		--local n_w = comm:getWidth(unit[a].name .. ' →→ ' .. unit[b].name)
		--local n_w = comm:getWidth(n_str)
		--local n_p = (window_width - n_w)/2
		local n_x = getcenter(n_str)
		--local n_x = (window_width - comm:getWidth(n_str))/2

		love.graphics.print(n_str, n_x, 0)

		--love.graphics.print(unit[a].name .. ' →→ ' .. unit[b].name, 0, 0)
		
		if unit[a].log.att[turn-1] ~= nil and unit[b].log.def[turn-1] ~= 0 and unit[a].log.sad[turn-1] ~= nil then
		
		local dmg_str = hp_diff .. ' DMG'
		local dmg_str_cr = hp_diff .. ' DMG (CRITICAL)'

		local dmg_x = getcenter(dmg_str)
		--local dmg_x = (window_width - comm:getWidth(dmg_str))/2
		local dmg_x_cr = getcenter(dmg_str_cr)
		--local dmg_x_cr = (window_width - comm:getWidth(dmg_str_cr))/2

		if ch == 1 then
			love.graphics.print(dmg_str_cr, dmg_x_cr, 14)
		else
			love.graphics.print(dmg_str, dmg_x, 14)
		end

		if unit[b].def >= unit[a].def and unit[b].hp > 0 and unit[a].hp > 0 then
			--[[local c_s_str = '/'
			local c_s_x = getcenter(c_s_str)			
			love.graphics.print(c_s_str, c_s_x, 14*2)]]

			local c_str = '←← COUNTER ←←'
			local c_x = getcenter(c_str)
			love.graphics.print(c_str, c_x, 14*3)
			

			--[[local c_n_str = ' ←← '--unit[a].name .. ' ←← ' .. unit[b].name
			local c_n_x = getcenter(c_n_str)
			love.graphics.print(c_n_str, c_n_x, 14*4)]]

			local c_hp_diff = 0
			if unit[a].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
				c_hp_diff = unit[a].log.hp[turn-1] - unit[a].log.hp[turn]
			end

			local c_dmg_str = c_hp_diff .. ' DMG'
			local c_dmg_x = getcenter(c_dmg_str)

			love.graphics.print(c_dmg_str, c_dmg_x, 14*4)


			local c_f_str = '← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. unit[b].log.sad[turn-1] .. ' SAD'
			local c_f_x = getcenter(c_f_str) 
			love.graphics.print(c_f_str, c_f_x, window_height-14)
		end
			--[[if ch then
				love.graphics.print(unit[a].log.att[turn-1]*3 .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF →→ ' .. hp_diff .. ' DMG', 0, window_height/2+14*3)
			else]]

		--local f_str_cr = unit[a].log.att[turn-1]*3 .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF -- ' .. unit[a].log.sad[turn-1] .. ' SAD →→ ' .. hp_diff .. ' DMG (CRITICAL)'
		local f_str_cr = '→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'
		--local f_str = unit[a].log.att[turn-1]*3 .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF -- ' .. unit[a].log.sad[turn-1] .. ' SAD →→ ' .. hp_diff .. ' DMG'
		local f_str = '→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'

		local f_x_cr = getcenter(f_str_cr)
		--local f_x_cr = (window_width - comm:getWidth(f_str_cr))/2
		local f_x = getcenter(f_str)
		--local f_x = (window_width - comm:getWidth(f_str))/2

		if ch == 1 then
			love.graphics.print(f_str_cr, f_x_cr, window_height-14*2)
		else
			love.graphics.print(f_str, f_x, window_height-14*2)
		end

				--[[love.graphics.print(unit[a].log.att[turn-1] .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF →→ ' .. hp_diff .. ' DMG', 0, window_height/2+14*3)
				local ww = comm:getWidth(unit[a].log.att[turn-1] .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF →→ ' .. hp_diff .. ' DMG ')
				
				if ch then
					love.graphics.print('!!! CRIT', ww, window_height/2+14*3)
				end]]
			--end
		end

		--[[if unit[b].log.hp[turn-1] == 100 and unit[b].log.hp[turn] < 100 then
			local ww = comm:getWidth(unit[a].log.att[turn-1] .. ' ATT −− ' .. unit[b].log.def[turn-1] .. ' DEF →→ ' .. hp_diff .. ' DMG')
			love.graphics.print(' :: FIRST HIT', ww, window_height/2+14*3)
		end]]


		--with 30% chance damage is ×3
		--

		local att_diff = 0
		local def_diff = 0

		if unit[a].log.att[turn-1] ~= nil and unit[a].log.att[turn] ~= nil then
			att_diff = unit[a].log.att[turn] - unit[a].log.att[turn-1]
		end

		if unit[b].log.def[turn-1] ~= nil and unit[b].log.def[turn] ~= nil then
			def_diff = unit[b].log.def[turn] - unit[b].log.def[turn-1]
		end

		
		--[[if unit[b].hp > 0 then
			love.graphics.print(unit[a].name .. ' +' .. att_diff .. ' ATT // ' .. unit[b].name .. ' +' .. def_diff .. ' DEF', 0, window_height/2+14*5)
		else
			love.graphics.print(unit[a].name .. ' +' .. att_diff .. ' ATT', 0, window_height/2+14*5)
		end]]

		local d_str = unit[b].name .. ' DIED'
		local d_2_str = unit[b].name .. ' DIED'
		local d_x = (window_width - comm:getWidth(d_str))/2
		local d_2_x = (window_width - comm:getWidth(d_str))/2
		if unit[b].hp <= 0 then
			love.graphics.print(d_str, d_x, 14*2)
			--love.graphics.print(unit[a].name .. ' WINS IN ' .. turn .. ' TURNS', 0, window_height/2+14*6)
		elseif unit[b].hp <= 0 then
			love.graphics.print(d_2_str, d_2_x, 14*2)
		end


		--if chance(30) then
		

		--local ch = 0

		--[[if not crit_check[turn] then
			ch = chance(.3)
			crit_check[turn] = true
		end]]

		--local ch = chance(.3)

		--love.graphics.print(rand_chance, 0, window_height/2+14*8)
		
		--if chance(30) then
		--[[if rand_chance < .3 then
			love.graphics.print('true', 100, window_height/2+14*9)
		else
			love.graphics.print('false', 1000, window_height/2+14*9)
		end]]

		--love.graphics.print(ch, 0, window_height/2+14*10)




			--love.graphics.print('CRIT', 0, window_height/2+14*8)
		--end
		

		--[[local sum_w = {}

		set_color('cyan')
		love.graphics.print(a_name, 0, window_height/2+14*3)
		set_color('white')

		sum_w[0] = comm:getWidth(a_name)
		love.graphics.print(' DO ', sum_w[0], window_height/2+14*3)

		sum_w[1] = comm:getWidth(' DO ')
		set_color('yellow')
		love.graphics.print(unit[a].att .. ' ATT', sum_w[0]+sum_w[1], window_height/2+14*3)
		set_color('white')

		sum_w[2] = comm:getWidth(unit[a].att .. ' ATT')
		love.graphics.print('/ ', sum_w[0]+sum_w[1]+sum_w[2], window_height/2+14*3)

		sum_w[3] = comm:getWidth('/ ')
		set_color('cyan')
		love.graphics.print(b_name, sum_w[0]+sum_w[1]+sum_w[2]+sum_w[3], window_height/2+14*3)
		set_color('white')

		sum_w[4] = comm:getWidth(b_name)
		love.graphics.print(' HAVE ', sum_w[0]+sum_w[1]+sum_w[2]+sum_w[3]+sum_w[4], window_height/2+14*3)

		sum_w[5] = comm:getWidth(' HAVE ')
		set_color('green')
		love.graphics.print(unit[b].def .. ' DEF', sum_w[0]+sum_w[1]+sum_w[2]+sum_w[3]+sum_w[4]+sum_w[5], window_height/2+14*3)
		set_color('white')

		sum_w[6] = comm:getWidth(unit[b].def .. ' DEF')
		love.graphics.print(' →→ GET ', sum_w[0]+sum_w[1]+sum_w[2]+sum_w[3]+sum_w[4]+sum_w[5]+sum_w[6], window_height/2+14*3)

		sum_w[7] = comm:getWidth(' →→ GET ')
		set_color('red')
		love.graphics.print(hp_diff .. ' DMG', sum_w[0]+sum_w[1]+sum_w[2]+sum_w[3]+sum_w[4]+sum_w[5]+sum_w[6]+sum_w[7], window_height/2+14*3)
		set_color('white')]]

		--love.graphics.print('__' .. a .. ' DO ' .. unit[a].att .. ' ATT, __' .. b .. ' HAVE ' .. unit[b].def .. ' DEF, GET ' .. hp_diff .. ' DMG', 0, window_height/2+14*5)

		--love.graphics.print('__' .. b .. ' SECRETLY IN LOVE WITH __' .. b, 0, window_height/2+14*6)
		--love.graphics.print('__' .. a .. ' →→ HATES →→ __' .. b, 0, window_height/2+14*8)
		--love.graphics.print('__' .. b .. ' HAVE A BOMB', 0, window_height/2+14*9)
		--[[love.graphics.print('__' .. a .. ' [HAVE A BOMB]', 0, window_height/2+14*6)
		love.graphics.print('__' .. b .. ' [SECRETLY IN LOVE]', 0, window_height/2+14*7)
		love.graphics.print('__' .. a .. ' [DECLARES WAR]', 0, window_height/2+14*8)
		love.graphics.print('__' .. b .. ' [IN A NICE MOOD]', 0, window_height/2+14*9)
		love.graphics.print('__' .. a .. ' [IN A BAD MOOD]', 0, window_height/2+14*10)]]
	end
end

function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		--start = true
		--autoplay()
		if showresult then
			nextturn()
			showresult = false
		end
		if unit[0].hp > 0 and unit[1].hp > 0 then
			if (turn % 2 == 0) then
				attack(1, 0)
			else
				attack(0, 1)
			end
			showresult = true
		end
	end
end


function love.update(dt)
	tick.update(dt)
end


function love.draw()
	for i=0,table.getn(unit) do
		unit[i]:draw()
	end
end