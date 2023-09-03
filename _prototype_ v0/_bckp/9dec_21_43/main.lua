function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"

	comm = love.graphics.newFont("trnsgndr.ttf", 14)
	jap = love.graphics.newFont("noto.otf", 14)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	unit = {}
	
	for i=0,1 do
		unit[i] = Unit(i)
	end

	turn = 1

	log = {}
	log.moves = {}
	log.moves.a = {}
	log.moves.b = {}

	showresult = false

	phrase_num = 0

	math.randomseed(os.time())

	tick.recur(function() 
		if unit[0].hp > 0 and unit[1].hp > 0 then
			if showresult then
				nextturn()
				showresult = false
			end
			if (turn % 2 == 0) then
				--attack(first, second)
				attack(1, 0)
			else
				--attack(second, first)
				attack(0, 1)
			end
			showresult = true
		end
	 end, .6)

	--local first = math.random(0,1)
	--local second = 0
	--if first == 1 then second = 0 else second = 1 end
end


--[[
	проблемы
	— я не понимаю, как пишутся логи
	— изменения переменной ситаются третьей переменной
		— новый уровень и xp хуй определишь относительно хода
	— начинается с хода 0
	— хуёво выводятся логи, путанно
	— очень длинные переменные (иногда в переменных)
	— логи слишком сложные
	— слишком много переменных
	— все действия и раскиданы и засунуты в атаку
	— непонятно как происходит ход и как он меняется (почему до логов?)
	— всегда показываем предыдущий ход, а почему не этот?
	— много мусора и комментариев
	— слишком сложно и непрозрачно
	]]


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
    end
end


function attack(a, b)
	unit[b].log.hp[turn-1] = unit[b].hp
	--unit[b].hp = unit[b].hp - 1
	unit[b].hp = unit[b].hp - unit[a].attack
	unit[b].log.hp[turn] = unit[b].hp
	unit[a].attack = unit[a].attack + 2
	log.moves.a[turn] = a
	log.moves.b[turn] = b

	local tb = table.getn(unit[b].talk)
	phrase_num = math.random(1,tb)

end

function nextturn()
	turn = turn + 1
end


function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		--[[if not showresult then
			if (turn % 2 == 0) then
				attack(0, 1)
			else
				attack(1, 0)
			end
			showresult = true
		else
			nextturn()
			showresult = false]]

		if showresult then
			nextturn()
			showresult = false
		end

		if unit[0].hp > 0 and unit[1].hp > 0 then
			if (turn % 2 == 0) then
				--attack(first, second)
				attack(1, 0)
			else
				--attack(second, first)
				attack(0, 1)
			end
			showresult = true
		end
		--end
	end
end


function love.update(dt)
	tick.update(dt)
end


function love.draw()
	for i=0,table.getn(unit) do
		unit[i]:draw()
	end

	--love.graphics.print('TURN: ' .. turn, 0, 14*5)
	--[[if (turn % 2 == 0) then
		love.graphics.print('%2 == true ', 0, 14*6)
	else
		love.graphics.print('%2 == false ', 0, 14*6)
	end]]

	if showresult then
		local a = log.moves.a[turn]
		local b = log.moves.b[turn]
		local hp_diff = 0

		if unit[b].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
			--local hp_width = comm:getWidth('HP' .. unit[b].hp)
			hp_diff = unit[b].log.hp[turn-1] - unit[b].log.hp[turn]
		end

		love.graphics.print('TURN ' .. turn, 0, window_height/2+14*1)
		--love.graphics.print('#' .. a .. ' →→ ' .. hp_diff .. ' DMG →→ #' .. b, 0, 14*9)
		love.graphics.print('__' .. a .. ' HURTS __' .. b .. ' WITH ' .. hp_diff, 0, window_height/2+14*2)
		local per = math.floor(hp_diff * 100 / unit[b].log.hp[turn])
		love.graphics.print('(LOSES ' .. per .. '% OF SELF)', 0, window_height/2+14*3)
		
		--love.graphics.print('_' .. b .. ': ' .. unit[b].talk[phrase_num], 0, 14*11)
		

		--[[love.graphics.print('_' .. b .. ': KISAMA', 0, 14*11)
		love.graphics.print('_' .. b .. ': TATAKAE', 0, 14*11)
		love.graphics.print('_' .. b .. ': MASAKA', 0, 14*11)]]
		
		if not (unit[0].hp > 0 and unit[1].hp > 0) then
			love.graphics.print('>OMAE WA MO', unit[a].x, 14*8)
			love.graphics.print('>SHINDEIRU.', unit[a].x, 14*9)
			
			--[[local w = comm:getWidth('#' .. a .. ' SAYS: ')
			love.graphics.setFont(jap)
			love.graphics.print('おまえはもうしんでいる', w, 14*10)
			love.graphics.setFont(comm)]]
		end

		--love.graphics.print('#' .. a .. ' HURTS ' .. b .. ' WITH ' .. hp_diff .. ' DMG', 0, 14*7)
		
		

		--love.graphics.print(unit[a].attack .. 'DM', 0, 14*7)
		--love.graphics.print('LOG_PR ' .. unit[b].log.hp[turn-1], 100, window_height/2+14*3)
		--love.graphics.print('/ LOG ' .. unit[b].log.hp[turn], 300, window_height/2+14*3)
		--[[if unit[b].log.hp[turn-1] == nil then
			love.graphics.print('nil ', 100, window_height/2+14*4)
		else
			love.graphics.print('ok ', 100, window_height/2+14*4)
		end
		if unit[b].log.hp[turn] == nil then
			love.graphics.print('nil ', 300, window_height/2+14*4)
		else
			love.graphics.print('ok ', 300, window_height/2+14*4)
		end]]
	end
end