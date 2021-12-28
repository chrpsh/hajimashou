function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"

	comm = love.graphics.newFont("trnsgndr.ttf", 14)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	unit = {}
	
	for i=0,1 do
		unit[i] = Unit(i, givemename())
	end

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
	unit[a].log.att[turn-1] = unit[a].att
	unit[a].log.sad[turn-1] = unit[a].sad
	unit[b].log.hp[turn-1] = unit[b].hp
	unit[b].log.def[turn-1] = unit[b].def
end

function writelogs_after(a,b)
	unit[a].log.att[turn] = unit[a].att
	unit[a].log.sad[turn] = unit[a].sad
	unit[b].log.hp[turn] = unit[b].hp
	unit[b].log.def[turn] = unit[b].def
end

function attack(a, b)
	--chance of crit
	if not unit[a].log.crit[turn] and not unit[a].log['crit'][turn] then
		unit[a].crit = chance(.2)
		unit[a].log.crit[turn] = true
		unit[a].log['crit'][turn] = true
	end
	--/

	--calculating damage
	local dmg = unit[a].att + unit[a].att*2*unit[a].crit - unit[b].def - math.floor(unit[a].sad)

	if dmg < 0 then
		dmg = 0
	end
	--/

	--doing attack on victim's hp
	unit[b].hp = unit[b].hp - dmg

	if unit[a].crit == 1 then
		getirritated(b)
	end
end


function getsad(x)
	unit[x].log.sad[turn-1] = unit[x].sad
	unit[x].sad = unit[x].sad + .2
	unit[x].log.sad[turn] = unit[x].sad
end

function getanxious(a,b)
	unit[b].log.anx[turn-1] = unit[b].anx
	unit[b].anx = unit[b].anx + 1
	unit[b].log.anx[turn] = unit[b].anx
end

function getirritated(b)
	unit[b].log.irr[turn-1] = unit[b].irr
	unit[b].irr = unit[b].irr + .2
	unit[b].log.irr[turn] = unit[b].irr
end

function randomevent()
	local a,b = whosemove()
	if unit[a].def ~= nil and unit[a].att ~= nil and unit[a].irr ~= nil and unit[a].sad ~= nil then
		unit[a].def = unit[a].def - 1
		unit[a].att = unit[a].att - 1
		unit[a].irr = unit[a].irr + 1
		unit[a].sad = unit[a].sad + 1
	end
end

function getcenter(str)
	return (window_width - comm:getWidth(str))/2
end

function nextturn()
	turn = turn + 1
end

function whosemove()
	--local a = math.random(0,3)
	--local b = math.random(4,7)
	if (turn % 2 == 0) then
		--return a,b
		--return math.random(0,3), math.random(4,7)
		return 1, 0
	else
		--return math.random(4,7), math.random(0,3)
		--return b,a
		return 0, 1
	end
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
	return unit[a].log.att[turn-1] ~= nil, unit[b].log.def[turn-1] ~= nil, unit[a].log.sad[turn-1] ~= nil
end

function showstatus()
	if showresult then	
		local a,b = whosemove()
		local hp_diff = 0

		if unit[b].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
			hp_diff = unit[b].log.hp[turn-1] - unit[b].log.hp[turn]
		end

		--top
		printstr(unit[a].name .. ' →→ ' .. unit[b].name, 0, 'top')
		--if unit[a].log.att[turn-1] ~= nil and unit[b].log.def[turn-1] ~= 0 and unit[a].log.sad[turn-1] ~= nil then
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

				if iscounter() and unit[b].hp > 0 and unit[a].hp > 0 then
					printstr('←← COUNTER ←←', 3, 'top')
					local hp_diff_2 = 0
					if unit[a].log.hp[turn-1] ~= nil and unit[a].log.hp[turn] ~= nil then
						hp_diff_2 = unit[a].log.hp[turn-1] - unit[a].log.hp[turn]
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
		if unit[b].hp <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
		elseif unit[a].hp <= 0 then
			printstr(unit[a].name .. ' DIED', 2, 'top')
		end
		--/top

		--bottom
		printstr('TURN ' .. turn, 3, 'bttm')

		if ismissed(a) == 0 then
			if unit[a].crit == 0 then
				printstr('→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. math.floor(unit[a].log.sad[turn-1]) .. ' SAD', 2, 'bttm')
			else
				printstr('→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. math.floor(unit[a].log.sad[turn-1]) .. ' SAD', 2, 'bttm')
			end
			if iscounter() and unit[b].hp > 0 and unit[a].hp > 0 then
				if ismissed(b) == 0 then
					if unit[b].crit == 0 then
						printstr('← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. math.floor(unit[b].log.sad[turn-1]) .. ' SAD', 1, 'bttm')
					else
						printstr('← ' .. unit[b].log.att[turn-1]*3 .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. math.floor(unit[b].log.sad[turn-1]) .. ' SAD', 1, 'bttm')
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
	return unit[b].def >= unit[a].def
end

function ismissed(num)
	--local a,b = whosemove()
	if not unit[num].log.miss[turn] then
		local irr = unit[num].irr / 10
		unit[num].miss = chance(irr)
		unit[num].log.miss[turn] = true
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
		if unit[a].hp > 0 and unit[b].hp > 0 then
			if ismissed(a) == 0 then
				writelogs_before(a,b)
				attack(a,b)
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
			if turn == 7 then
				--until later
				--randomevent()
			end
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

	local a,b = whosemove()

	love.graphics.print('logs', 20, 180-14)
	for i,v in ipairs(unit[a].log['crit']) do
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
	end

	--printstr('stat.att: '..unit[a].stat['att']..' ; log.turn-1: ' .. unit[a].log['att'][1], 9, 'top')

	--[[if turn == 7 then
		printstr(unit[a].name .. 'FORGOT TO TAKE MEDICATIONS', 14, 'top')
		printstr('ALL STATS DEBUFFED FOR 3 TURNS', 15, 'top')
		
		if unit[a].log.def[turn] ~= unit[a].log.def[turn-1] then
			printstr('log ~=', 16, 'top')
		end

		if unit[a].def ~= unit[a].log.def[turn-1] then
			printstr('def ~=', 17, 'top')
		end

		if unit[a].irr ~= unit[a].log.irr[turn-1] then
			printstr('irr not ==', 19, 'top')
		end
	end]]

	showstatus()
end