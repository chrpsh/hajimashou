function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	require "actions"
	require "gradientmesh"
	txt = love.graphics.newFont("trnsgndr.ttf", 22)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()
    unit = {}
    unit[0] = Unit(0,'SASHA')
    unit[1] = Unit(1,'SASHA')
    actions = Actions() 
    bistro = love.audio.newSource("16feb_cut.mp3", "stream")
    bistro:setLooping(true)
    log = {}
    log.str = {}
    log.count = 0
    log.magic = 0
    log.work = 0
    log.magic_comm_isshown = false
    log.turn = 0
    turn = 0
    console_show = false
    tmp_show = 0
	math.randomseed(os.time())
	tmp_void = 0
	tmp_mul = .5
end

function love.keypressed(key)
	actions:keyPressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		if log.count < 74 then
			actions.show = false
			console_show = true
			local hov = actions.hov
			local name = unit[turn].name
			local act = {'TAKES MEDS', --[['USES PREGABALIN', ]]'USES SEDATIVE', 'TRIES TO CRY'}
			local stat = {'NAUSEA', 'IRRITATION', 'INSOMNIA'}
			log.count = log.count + 1
			log.str[log.count] = --[['	' ..]] name .. ' ' .. act[hov]
			log.count = log.count + 1
			if hov == 1 then
				if chance(.5) == 1 then
					log.str[log.count] = 'NOTHING HAPPENS'
					if log.work < 4 then
						log.work = log.work + 1
					end
					log.count = log.count + 1
					log.str[log.count] = '' .. stat[1] .. ' −1 ' .. stat[2] .. ' −1 '
					unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
					unit[turn].st['irritation'] = unit[turn].st['irritation'] - 1 
				else
					log.str[log.count] = 'GOT SEROTONINE SYNDROME'
					log.count = log.count + 1
					log.str[log.count] = stat[1] .. ' +1 ' .. stat[3] .. ' +1 '
					unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
					unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1
				end
			elseif hov == 2 then
				if chance(.3) == 1 then
					log.str[log.count] = 'EASES PAIN'
					log.count = log.count + 1
					log.str[log.count] = '' .. stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
					unit[turn].st['irritation'] = unit[turn].st['irritation'] - 1
					unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
				else
					if chance(.5) == 1 then
						log.str[log.count] = 'SUDDENLY FALLS ASLEEP'
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' +1 ' .. stat[3] .. ' −1 '
						unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
					else
						log.str[log.count] = 'FEELS NOTHING'
						log.count = log.count + 1
						log.str[log.count] = stat[3] .. ' +1 '
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1
					end
				end
			elseif hov == 3 then
				log.str[log.count] = 'CAN’T JUST CAN’T'
				log.count = log.count + 1
				log.str[log.count] = stat[1] .. ' +1 '
				unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
			end
			if chance(.7) == 1 and hov ~= 3 then
				randomevent()
			end
			actions:changed(turn)		
			change_turn()
			if not bistro:isPlaying() then
				bistro:play()
			end
			if log.count >= 30 then
				tmp_void = tmp_void + 1
				tmp_mul = tmp_mul * 1.9
			end
		elseif log.count >= 74 then
			love.load()
		end
	end
end

function randomevent(tookmeds)
	local stat = {'NAUSEA', 'IRRITATION', 'INSOMNIA'}
	log.count = log.count + 1
	local event
	if actions.hov == 1 then
		event = math.random(1,3)
	else
		event = math.random(1,4)
	end
	if event == 1 then
		log.str[log.count] = 'ENCOUNTERS DIZZINESS'
		log.count = log.count + 1
		log.str[log.count] = stat[1] .. ' +3 ' .. stat[2] .. ' +2 '
		unit[turn].st['irritation'] = unit[turn].st['irritation'] +2
		unit[turn].st['insomnia'] = unit[turn].st['insomnia'] +3
	elseif event == 2 then
		log.str[log.count] = 'GOT RANDOMLY IRRITATED'
		log.count = log.count + 1
		log.str[log.count] = stat[2] .. ' +3 '
		unit[turn].st['irritation'] = unit[turn].st['irritation'] + 3
	elseif event == 3 then
		log.str[log.count] = 'SLEPT FOR SIXTEEN HOURS'
		log.count = log.count + 1
		log.str[log.count] = '' .. stat[1] .. ' +1 ' .. stat[2] .. ' +1 '
		unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
		unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1 
	elseif event == 4 then
		log.str[log.count] = 'FORGOT TO TAKE THEY’RE MEDS'
		log.count = log.count + 1
		log.str[log.count] = 'GOT SEROTONINE SYNDROME'
		log.count = log.count + 1
		log.str[log.count] = stat[1] .. ' +1 ' .. stat[3] .. ' +1 '
		unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
		unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1 
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
	unit[turn].st.last['irritation'] = unit[turn].st['irritation']
	unit[turn].st.last['insomnia'] = unit[turn].st['insomnia']
	if turn == 0 then 
		turn = 1 
	elseif turn == 1 then 
		turn = 0 
	end
	log.turn = log.turn + 1
end

function console()
	local line = unit[turn].line
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
	end
end

function love.update(dt)
	tick.update(dt)
	actions:update(dt)
	if turn == 1 then
		unit[1].arrw = '	'
		unit[0].arrw = ''
	elseif turn == 0 then
		unit[0].arrw = '	'
		unit[1].arrw = ''
	end
end

function void(num)
	local into = gradientMesh("vertical", {0, 0, 0, 0}, {0, 0, 0, 1})
	local part = window_height / 8
	local w = window_width
	local h = part * num
	local y = window_height - part * num
	love.graphics.draw(into, 0, y, 0, w, h)
end

function love.draw()
	love.graphics.setFont(txt)
	unit[0]:draw()
	unit[1]:draw()
	actions:draw()
	if log.str[log.count] ~= nil then
		console()
	end
	if log.count >= 30 then
		void(tmp_void+tmp_mul)
	end
	if log.count >= 74 then
		bistro:stop()
	end
end