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
	--log
	unit[a].log.hp[turn-1] = unit[a].hp
	unit[a].log.att[turn-1] = unit[a].att
	unit[a].log.def[turn-1] = unit[a].def
	unit[a].log.sad[turn-1] = unit[a].sad

	unit[b].log.hp[turn-1] = unit[b].hp
	unit[b].log.att[turn-1] = unit[b].att
	unit[b].log.def[turn-1] = unit[b].def
	unit[b].log.sad[turn-1] = unit[b].sad
	--/log

	--chance of crit
	if not crit_check[turn] then
		ch = chance(.2)
		crit_check[turn] = true
	end
	--/

	--calculating damage
	local dmg = unit[a].att + unit[a].att*2*ch - unit[b].def - unit[a].sad

	if dmg < 0 then
		dmg = 0
	end
	--/

	--doing attack on victim's hp
	unit[b].hp = unit[b].hp - dmg
	--/



	--counter
	if not crit_check_counter[turn] then
		ch_c = chance(.2)
		crit_check_counter[turn] = true
	end

	if unit[b].def >= unit[a].def then
		local dmg_c = unit[b].att + unit[b].att--[[*2*ch_c]] - unit[a].def - unit[b].sad--math.floor(unit[a].sad*.5)

		if dmg_c < 0 then
			dmg_c = 0
		end

		unit[a].hp = unit[a].hp - dmg_c
	end
	--/


	--log
	unit[a].log.hp[turn] = unit[a].hp
	unit[a].log.def[turn] = unit[a].def	
	unit[a].log.att[turn] = unit[a].att
	unit[a].log.sad[turn] = unit[a].sad

	unit[b].log.hp[turn] = unit[b].hp
	unit[b].log.def[turn] = unit[b].def
	unit[b].log.att[turn] = unit[b].att
	unit[b].log.sad[turn] = unit[b].sad

	log.moves.a[turn] = a
	log.moves.b[turn] = b
end

function old_attack(a, b)
	unit[a].log.hp[turn-1] = unit[a].hp
	unit[a].log.att[turn-1] = unit[a].att
	unit[a].log.def[turn-1] = unit[a].def
	unit[a].log.sad[turn-1] = unit[a].sad

	unit[b].log.hp[turn-1] = unit[b].hp
	unit[b].log.att[turn-1] = unit[b].att
	unit[b].log.def[turn-1] = unit[b].def
	unit[b].log.sad[turn-1] = unit[b].sad
	
	--comms about stuf (tranq etc)
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

function showstatus()
	if showresult then
		local a = log.moves.a[turn]
		local b = log.moves.b[turn]
	
		local hp_diff = 0

		if unit[b].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
			hp_diff = unit[b].log.hp[turn-1] - unit[b].log.hp[turn]
		end

		local t_str = 'TURN ' .. turn
		local t_x = getcenter(t_str)
		love.graphics.print(t_str, t_x, window_height-14*3)
		
		local n_str = unit[a].name .. ' →→ ' .. unit[b].name
		local n_x = getcenter(n_str)
		love.graphics.print(n_str, n_x, 0)

		if unit[a].log.att[turn-1] ~= nil and unit[b].log.def[turn-1] ~= 0 and unit[a].log.sad[turn-1] ~= nil then
		
			local dmg_str = hp_diff .. ' DMG'
			local dmg_str_cr = hp_diff .. ' DMG (CRITICAL)'

			local dmg_x = getcenter(dmg_str)
			local dmg_x_cr = getcenter(dmg_str_cr)

			if ch == 1 then
				love.graphics.print(dmg_str_cr, dmg_x_cr, 14)
			else
				love.graphics.print(dmg_str, dmg_x, 14)
			end

			if unit[b].def >= unit[a].def and unit[b].hp > 0 and unit[a].hp > 0 then
				local c_str = '←← COUNTER ←←'
				local c_x = getcenter(c_str)
				love.graphics.print(c_str, c_x, 14*3)
				
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

			local f_str_cr = '→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'
			local f_str = '→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'

			local f_x_cr = getcenter(f_str_cr)
			local f_x = getcenter(f_str)

			if ch == 1 then
				love.graphics.print(f_str_cr, f_x_cr, window_height-14*2)
			else
				love.graphics.print(f_str, f_x, window_height-14*2)
			end
		end

		local att_diff = 0
		local def_diff = 0

		if unit[a].log.att[turn-1] ~= nil and unit[a].log.att[turn] ~= nil then
			att_diff = unit[a].log.att[turn] - unit[a].log.att[turn-1]
		end

		if unit[b].log.def[turn-1] ~= nil and unit[b].log.def[turn] ~= nil then
			def_diff = unit[b].log.def[turn] - unit[b].log.def[turn-1]
		end

		local d_str = unit[b].name .. ' DIED'
		local d_2_str = unit[b].name .. ' DIED'
		local d_x = (window_width - comm:getWidth(d_str))/2
		local d_2_x = (window_width - comm:getWidth(d_str))/2
		if unit[b].hp <= 0 then
			love.graphics.print(d_str, d_x, 14*2)
		elseif unit[b].hp <= 0 then
			love.graphics.print(d_2_str, d_2_x, 14*2)
		end
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

	showstatus()
end