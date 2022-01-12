function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	require "tts"

	--ffi = require("ffi")
	--ffi.cdef[[
	--int printf(const char *fmt, ...);
	--]]
	--ffi.C.printf("Hello %s!", "world")

	comm = love.graphics.newFont("trnsgndr.ttf", 14)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	unit = {}
	
	--[[for i=0,1 do
		unit[i] = Unit(i, givemename())
	end]]

	unit[0] = Unit(0, 'M1s7Y')
	unit[1] = Unit(1, '8R0CK')
	

	--[[for i=0,7 do
		unit[i] = Unit(i, givemename())
	end]]

	said = {}

	--nowplaying = false

	turn = 1
	showresult = false

	math.randomseed(os.time())
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
	--rand_chance = math.random()
	--if rand_chance < x then
	if math.random() < x then
		return 1
	else
		return 0
	end
end

function writelogs_before(a,b)
	unit[a].log['att'][turn-1] = unit[a].stat['att']
	unit[a].log['sad'][turn-1] = unit[a].stat['sad']
	unit[b].log['hp'][turn-1] = unit[b].stat['hp']	
	unit[b].log['def'][turn-1] = unit[b].stat['def']

	unit[b].log['hp'][turn-1] = unit[b].stat['hp']
	unit[a].log['att'][turn-1] = unit[a].stat['att']

	--[[unit[a].log['att'][turn-1] = unit[a].stat['att']
	unit[a].log['sad'][turn-1] = unit[a].stat['sad']
	unit[b].log['hp'][turn-1] = unit[b].stat['hp']	
	unit[b].log['def'][turn-1] = unit[b].stat['def'] ]]
end

function writelogs_after(a,b)
	unit[a].log['att'][turn] = unit[a].stat['att']
	unit[a].log['sad'][turn] = unit[a].stat['sad']
	unit[b].log['hp'][turn] = unit[b].stat['hp']
	unit[b].log['def'][turn] = unit[b].stat['def']

	unit[b].log['hp'][turn] = unit[b].stat['hp']
	unit[a].log['att'][turn] = unit[a].stat['att']

	--[[unit[a].log['att'][turn] = unit[a].stat['att']
	unit[a].log['sad'][turn] = unit[a].stat['sad']
	unit[b].log['hp'][turn] = unit[b].stat['hp']	
	unit[b].log['def'][turn] = unit[b].stat['def'] ]]
end

function attack(a, b)
	--chance of crit
	if not unit[a].log['crit'][turn] --[[and not unit[a].log['crit'][turn]] then
		unit[a].crit = chance(.2)
		unit[a].log['crit'][turn] = true
		--unit[a].log['crit'][turn] = true
	end
	--/

	--calculating damage
	local dmg = unit[a].stat['att'] + unit[a].stat['att']*2*unit[a].crit - unit[b].stat['def'] - math.floor(unit[a].stat['sad'])

	if dmg < 0 then
		dmg = 0
	end
	--/

	--doing attack on victim's hp
	unit[b].stat['hp'] = unit[b].stat['hp'] - dmg

	--unit[b].stat['hp'] = unit[b].stat['hp'] - dmg

	if unit[a].crit == 1 then
		getirritated(b)
	end
end


function getsad(x)
	unit[x].log['sad'][turn-1] = unit[x].stat['sad']
	unit[x].stat['sad'] = unit[x].stat['sad'] + .2
	unit[x].log['sad'][turn] = unit[x].stat['sad']
end

function getanxious(a,b)
	--need only one argument
	unit[b].log['anx'][turn-1] = unit[b].stat['anx']
	unit[b].stat['anx'] = unit[b].stat['anx'] + 1
	unit[b].log['anx'][turn] = unit[b].stat['anx']
end

function getirritated(b)
	unit[b].log['irr'][turn-1] = unit[b].stat['irr']
	unit[b].stat['irr'] = unit[b].stat['irr'] + .2
	unit[b].log['irr'][turn] = unit[b].stat['irr']
end

function randomevent()
	local a,b = whosemove()
	if unit[a].stat['def'] ~= nil and unit[a].stat['att'] ~= nil and unit[a].stat['irr'] ~= nil and unit[a].stat['sad'] ~= nil then
		unit[a].stat['def'] = unit[a].stat['def'] - 1
		unit[a].stat['att'] = unit[a].stat['att'] - 1
		unit[a].stat['irr'] = unit[a].stat['irr'] + 1
		unit[a].stat['sad'] = unit[a].stat['sad'] + 1
	end
end

function getcenter(str)
	return (window_width - comm:getWidth(str))/2
end

function nextturn()
	turn = turn + 1
end

function whosemove()
	--[[local a = math.random(0,1)
	local b = math.random(2,3)
	
	if (turn % 2 == 0) then
		return a, b
	else
		return b, a
	end]]

	--[[if (turn % 2 == 0) then
		return 4, 0
	else
		return 0, 4
	end]]

	if (turn % 2 == 0) then
		return 1, 0
	else
		return 0, 1
	end
end

function autoplay()
	tick.recur(function()
		if unit[0].stat['hp'] > 0 and unit[1].stat['hp'] > 0 then
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

function printstr(str, num, pos)
	if pos == 'top' then
		local x = (window_width - comm:getWidth(str))/2
		love.graphics.print(str, x, 0+14*num)
	elseif pos == 'bttm' then
		local x = (window_width - comm:getWidth(str))/2
		love.graphics.print(str, x, window_height-14*num)
	end
end

function isnill()
	local a,b = whosemove()
	return unit[a].log['att'][turn-1] ~= nil, unit[b].log['def'][turn-1] ~= nil, unit[a].log['sad'][turn-1] ~= nil
end

function showstatus()
	if showresult then	
		local a,b = whosemove()
		local hp_diff = 0

		if unit[b].log['hp'][turn-1] ~= nil and unit[b].log['hp'][turn] ~= nil then
			hp_diff = unit[b].log['hp'][turn-1] - unit[b].log['hp'][turn]
		end

		--top
		printstr(unit[a].name .. ' →→ ' .. unit[b].name, 0, 'top')
		--if unit[a].log['att'][turn-1] ~= nil and unit[b].log['def'][turn-1] ~= 0 and unit[a].log['sad'][turn-1] ~= nil then
		local nill1, nill2, nill3 = isnill()
		local nillsum = nill1 and nill2 and nill3
		if nillsum then
			if ismissed(a) == 0 then
				--show attack
				if unit[a].crit ~= 1 then
					printstr(hp_diff .. ' DMG', 1, 'top')
				else
					set_color('red')
					printstr(hp_diff .. ' DMG (CRITICAL)', 1, 'top')
					set_color('white')
				end

				--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage')

				if (iscounter() and unit[b].stat['hp'] > 0) or (iscounter() and unit[a].stat['hp'] > 0) then
					printstr('←← COUNTER ←←', 3, 'top')
					local hp_diff_2 = 0
					if unit[a].log['hp'][turn-1] ~= nil and unit[a].log['hp'][turn] ~= nil then
						hp_diff_2 = unit[a].log['hp'][turn-1] - unit[a].log['hp'][turn]
					end

					if ismissed(b) == 0 then
						if unit[b].crit ~= 1 then
							printstr(hp_diff_2 .. ' DMG', 4, 'top')
						else
							set_color('red')
							printstr(hp_diff_2 .. ' DMG (CRITICAL)', 4, 'top')
							set_color('white')
						end
						--show counter dmg
					else
						set_color('yellow')
						printstr('MISS', 4, 'top')
						set_color('white')
						--show miss
					end
				end
			else
				set_color('yellow')
				printstr('MISS', 1, 'top')
				set_color('white')
				--printstr(hp_diff .. ' DMG', 2, 'top')
			end
		else
			if nill1 then
				printstr('OK', 2, 'top') else printstr('NIL', 2, 'top')
			end
			if nill2 then
				printstr('OK', 3, 'top') else printstr('NIL', 3, 'top')
			end
			if nill3 then
				printstr('OK', 4, 'top') else printstr('NIL', 4, 'top')
			end
		end
		if unit[b].stat['hp'] <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
		elseif unit[a].stat['hp'] <= 0 then
			printstr(unit[a].name .. ' DIED', 2, 'top')
		end
		--/top

		--bottom
		printstr('TURN ' .. turn, 3, 'bttm')

		if ismissed(a) == 0 then
			if unit[a].crit == 0 then
				printstr('→ ' .. unit[a].log['att'][turn-1] .. ' ATT − ' .. unit[b].log['def'][turn-1] .. ' DEF − ' .. math.floor(unit[a].log['sad'][turn-1]) .. ' SAD', 2, 'bttm')
			else
				printstr('→ ' .. unit[a].log['att'][turn-1]*3 .. ' ATT − ' .. unit[b].log['def'][turn-1] .. ' DEF − ' .. math.floor(unit[a].log['sad'][turn-1]) .. ' SAD', 2, 'bttm')
			end
			if iscounter() and unit[b].stat['hp'] > 0 and unit[a].stat['hp'] > 0 then
				if ismissed(b) == 0 then
					if unit[b].crit == 0 then
						printstr('← ' .. unit[b].log['att'][turn-1] .. ' ATT − ' .. unit[a].log['def'][turn-1] .. ' DEF − ' .. math.floor(unit[b].log['sad'][turn-1]) .. ' SAD', 1, 'bttm')
					else
						printstr('← ' .. unit[b].log['att'][turn-1]*3 .. ' ATT − ' .. unit[a].log['def'][turn-1] .. ' DEF − ' .. math.floor(unit[b].log['sad'][turn-1]) .. ' SAD', 1, 'bttm')
					end
				end
			end
		end	
		--/bottom	
	end
end

function givemename()
	--XÆA-12
	--RX-78-2

	local char = string.char(math.random(65,90))
	local char = char .. string.char(math.random(65,90))
	local num = math.random(0,9)
	local num = num .. math.random(0,9)
	local num_last = math.random(0,9)

	return char .. '-' .. num .. '-' .. num_last


	--caps letter
	--string.char(math.random(65,90))
	--
end

function iscounter()
	local a,b = whosemove()
	return unit[b].stat['def'] >= unit[a].stat['def']
end

function ismissed(num)
	--local a,b = whosemove()
	if not unit[num].log['miss'][turn] then
		local irr = unit[num].stat['irr'] / 10
		unit[num].miss = chance(irr)
		unit[num].log['miss'][turn] = true
	end
	return unit[num].miss
end

function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		if showresult then
			nextturn()
			showresult = false
		end
		local a,b = whosemove()
		if unit[a].stat['hp'] > 0 and unit[b].stat['hp'] > 0 then
			if ismissed(a) == 0 then
				writelogs_before(a,b)
				attack(a,b)
				--saythething()
				writelogs_after(a,b)
				if iscounter() then
					if ismissed(b) == 0 then
						writelogs_before(b,a)
						attack(b, a)
						getanxious(b, a)
						writelogs_after(b,a)
					else
						writelogs_before(b,a)
						getsad(b)
						writelogs_after(b,a)
					end
				end
			else
				writelogs_before(a,b)
				getsad(a)
				writelogs_after(a,b)
			end
			showresult = true
			--if not said[turn] then 
				--saythething()
			--	said[turn] = true
			--end
			--if turn == 7 then
				--until later
				--randomevent()
			--end
		end
		say_make()
		--tts:say(say_make())
		--saythething()
	end
end


function love.update(dt)
	tick.update(dt)
	--ffi.C.printf("Hello %s!", "world")
end

function say_make()
	local a,b = whosemove()
	local str = ''
	local str_2 = ''
	str = say_att(a,b,str)
	local ismakesense = ismissed(a) == 0 and iscounter() and unit[b].stat['hp'] > 0
	if ismakesense then
		str = str .. ' however ' .. say_att(b,a,str_2,true)
	end
	--tts:say(str)
	wha = tts:say(str, true)
end

function say_att(a,b,str,dodge)
	local dmg = 0
	if unit[b].log['hp'][turn-1] ~= nil and unit[b].log['hp'][turn] ~= nil then
		dmg = unit[b].log['hp'][turn-1] - unit[b].log['hp'][turn]
	end
	str = str .. unit[a].name	
	if ismissed(a) == 0 then
		if not dodge then
			str = str .. ' attacks '
			str = str .. unit[b].name
		else
			str = str .. ' counters '
		end
		str = str .. ' and deals ' .. dmg .. ' damage '
		if unit[a].crit == 1 then
			str = str .. ' and its critical '
		end
		if unit[b].stat['hp'] <= 0 then
			str = str .. unit[b].name
			str = str .. ' dies, his life is over now '
		end
	else
		if dodge then
			str = str .. ' counters '
		end
		str = str .. ' misses '
	end
	return str

--novelty 2
	--[[if ismissed(a) == 0 then
		if not dodge then
			str = str .. ' attacks '
			str = str .. unit[b].name
		else
			str = str .. ' hit back '
		end
		str = str .. ' and deals ' .. dmg .. ' damage '
		if unit[a].crit == 1 then
			str = str .. ' and with a miserable chance its critical, which makes it three times stronger '
			str = str .. unit[b].name .. ' is more irritated now, he probably gonna mess up next one '
		end
		if unit[b].stat['hp'] <= 0 then
			str = str .. unit[b].name
			str = str .. ' dies, his life is over now '
		end
	else
		if dodge then
			str = str .. ' defends himself and hit ass in returnб иге '
		end
		str = str .. ' misses, he sad and weak now'
	end]]

--novelty
	--[[
	if ismissed(a) == 0 then
		if not dodge then
			str = str .. ' attacks '
			str = str .. unit[b].name
		else
			str = str .. ' hit back cause now they are strong and can defend themselves as lot as this agressive asshole in front of them '
		end
		if unit[a].crit == 1 then
			str = str .. ' and so lucky that with a miserable chance of some percent it is critical and hecking lot, like thrice more lot '
			str = str .. ' still '
			--str = str .. ' and its critical '
		end
		if not dodge then
			str = str .. ' they use all their power to neglect the blow, but still recieve ' .. dmg .. ' damage which is a lot of pain but could be worse if ' .. unit[a].name .. ' wouldnt be so sad '
		else
			str = str .. ' they use all their power and anger to feal ' .. dmg .. ' damage, but can you be like a little less that sad ass '
		end
		--str = str .. ' with ' .. dmg .. ' damage '
		--str = str .. ' wich could be better if they would have been not that sad'
		if unit[b].stat['hp'] <= 0 then
			str = str .. unit[b].name
			str = str .. ' dies, his life is over now '
		end
	else
		if dodge then
			str = str .. ' tried to hit in return '
			str = str .. ' but so irritated, that they miss '
		else
			str = str .. ' tried to perform an attack, but they are so irritated, that they miss '
		end
	end
	]]
end

function saythething()
	--if said[turn] == nil then
		local a,b = whosemove()
		local hp_diff = 0
		if unit[b].log['hp'][turn-1] ~= nil and unit[b].log['hp'][turn] ~= nil then
			hp_diff = unit[b].log['hp'][turn-1] - unit[b].log['hp'][turn]
		end

		local hp_diff_2 = 0
		if unit[a].log['hp'][turn-1] ~= nil and unit[a].log['hp'][turn] ~= nil then
			hp_diff_2 = unit[a].log['hp'][turn-1] - unit[a].log['hp'][turn]
		end

		local str

		if ismissed(a) == 0 then
			if unit[a].crit ~= 1 then
				if iscounter() then
					if ismissed(b) == 0 then
						if unit[b].crit ~= 1 then
							str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage, however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage'
							--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage, however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage')
						else
							str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage, however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage which is really darn lot if you ask me'
							--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage, however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage which is really darn lot if you ask me')
						end
					else
						str = unit[b].name .. ' misses, what a pitty lil creature'
						--tts:say(unit[b].name .. ' misses, what a pitty lil creature')
					end
				else
					str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage'
					--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage')
				end
			else
				if iscounter() then
					if ismissed(b) == 0 then
						if unit[b].crit ~= 1 then
							str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which hecking lot), however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage'
							--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which hecking lot), however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage')
						else
							str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which hecking lot), however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage which is also a hecking heck lot of hecking heck darn pain'
							--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which hecking lot), however, ' .. unit[b].name .. ' counters with ' .. hp_diff_2 .. 'damage which is also a hecking heck lot of hecking heck darn pain')
						end
					else
						str = unit[b].name .. ' misses, such a loser you say, cant handle a single blow like what the heck'
						--tts:say(unit[b].name .. ' misses, such a loser you say, cant handle a single blow like what the heck')
					end
				else
					str = unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which is much as heck)'
					--tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage (critical, which is much as heck)')
				end
			end
			--[[if not said[turn] then
			tts:say(unit[a].name .. ' attacks ' .. unit[b].name .. ' and deals ' .. hp_diff .. 'damage')
			said[turn] = true
			end]]
			--[[if iscounter() then
				if unit[b].crit ~= 1 then
					tts:say('however, ' .. unit[b].name .. ' counters')
				else
					tts:say(unit[b].name .. ' attacks ' .. unit[a].name .. ' and deals ' .. hp_diff_2 .. 'damage (critical)')
				end
			end]]
		else
			str = unit[a].name .. ' misses'
			--tts:say(unit[a].name .. ' misses')
		end
		--said[turn] = true
	--end

	tts:say(str)
end

function love.draw()
	for i=0,table.getn(unit) do
		unit[i]:draw()
	end

	local a,b = whosemove()

	if wha then 
			love.graphics.print('yes', 300, 400)
		else
			love.graphics.print('no', 300, 400)
		end

	--[[if tts.active ~= nil then
		if tts.active then 
			love.graphics.print('yes', 300, 400)
		else
			love.graphics.print('no', 300, 400)
		end
	end]]
	--[[for i,v in ipairs(unit[a].log['att']) do
		love.graphics.print('att.[' .. a .. '][' .. turn-i .. ']: ' .. unit[a].log['att'][i], 20, 180+14*i)
	end]]

	--[[if (5%1==0) then
		love.graphics.print('1%1 ; true', 200, 180-14*3)
	else
		love.graphics.print('1%1 ; false', 200, 180-14*3)
	end

	if (6%2==0) then
		love.graphics.print('2%2 ; true', 200, 180-14*2)
	else
		love.graphics.print('2%2 ; false', 200, 180-14*2)
	end

	if (7%3==0) then
		love.graphics.print('3%3 ; true', 200, 180-14*1)
	else
		love.graphics.print('3%3 ; false', 200, 180-14*1)
	end

	if (8%4==0) then
		love.graphics.print('4%4 ; true', 200, 180)
	else
		love.graphics.print('4%4 ; false', 200, 180)
	end]]
	--love.graphics.print(unit[a].name, 20, 180-14*3)
	--[[for i,v in ipairs(unit[a].log['hp']) do
		love.graphics.print('hp.[' .. a .. '][' .. i .. ']: ' .. unit[a].log['hp'][i], 20, 180+14*i)
	end

	for i,v in ipairs(unit[a].log['hp']) do
		love.graphics.print('/hp.[' .. a .. '][' .. i .. ']: ' .. unit[a].log['hp'][i], 180, 180+14*i)
	end]]

	--[[love.graphics.print('att: ' .. unit[a].stat['att'], 20, 180-14)

	for i,v in ipairs(unit[a].log['att']) do
		love.graphics.print('log[' .. i .. ']: ' .. unit[a].log['att'][i], 20, 180+14*i)
	end

	love.graphics.print('/att: ' .. unit[a].stat['att'], 180, 180-14)

	for i,v in ipairs(unit[a].log['att']) do
		love.graphics.print('/log[' .. i .. ']: ' .. unit[a].log['att'][i], 180, 180+14*i)
	end




	love.graphics.print(unit[b].name, 20+400, 180-14*3)

	love.graphics.print('att: ' .. unit[b].stat['att'], 20+400, 180-14)

	for i,v in ipairs(unit[b].log['att']) do
		love.graphics.print('log[' .. i .. ']: ' .. unit[b].log['att'][i], 20+400, 180+14*i)
	end

	love.graphics.print('/att: ' .. unit[b].stat['att'], 180+400, 180-14)

	for i,v in ipairs(unit[b].log['att']) do
		love.graphics.print('/log[' .. i .. ']: ' .. unit[b].log['att'][i], 180+400, 180+14*i)
	end]]

	--for i,v in ipairs(unit[a].stat['att']) do
		--love.graphics.print('att.[' .. a .. ']: ' .. unit[a].stat['att'], 20+200, 180+14)
	--end

	--for i,v in ipairs(unit[a].stat['att']) do
		--love.graphics.print('/att.[' .. a .. ']: ' .. unit[a].stat['att'], 180+200, 180+14)
	--end

	--love.graphics.print('logs', 20, 180-14)
	--[[for i,v in ipairs(unit[a].log['crit']) do
		if unit[a].log['crit'][turn] == true then
			love.graphics.print('crit.[' .. a .. '][' .. turn-i .. ']: true', 20, 180+14*i)
		else
			love.graphics.print('crit.[' .. a .. '][' .. turn-i .. ']: false', 20, 180+14*i)
		end
	end

	for i,v in ipairs(unit[b].log['crit']) do
		if unit[a].log['crit'][turn] == true then
			love.graphics.print('crit.[' .. b .. '][' .. turn-i .. ']: true', 200, 180+14*i)
		else
			love.graphics.print('crit.[' .. b .. '][' .. turn-i .. ']: false', 200, 180+14*i)
		end
	end]]

	--printstr('stat.att: '..unit[a].stat['att']..' ; log.turn-1: ' .. unit[a].log['att'][1], 9, 'top')

	--[[if turn == 7 then
		printstr(unit[a].name .. 'FORGOT TO TAKE MEDICATIONS', 14, 'top')
		printstr('ALL STATS DEBUFFED FOR 3 TURNS', 15, 'top')
		
		if unit[a].log['def'][turn] ~= unit[a].log['def'][turn-1] then
			printstr('log ~=', 16, 'top')
		end

		if unit[a].stat['def'] ~= unit[a].log['def'][turn-1] then
			printstr('def ~=', 17, 'top')
		end

		if unit[a].stat['irr'] ~= unit[a].log['irr'][turn-1] then
			printstr('irr not ==', 19, 'top')
		end
	end]]

	showstatus()
end