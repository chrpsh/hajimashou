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
	
	--[[actions = {}
    actions[0] = Actions(0) 
    actions[1] = Actions(1)]]

    bistro = love.audio.newSource("16feb_cut.mp3", "stream")
    bistro:setLooping(true)
    --bistro:setVolume(0.4)
	--bistro:setPitch(.07)
	--bistro:play()

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

	--tst gradient

	--void = gradientMesh("vertical", {0, 0, 0, 0}, {0, 0, 0, 1})

--[[	 rainbow = gradientMesh("horizontal",
        {255, 0, 0},
        {255, 255, 0},
        {0, 255, 0},
        {0, 255, 255},
        {0, 0, 255},
        {255, 0, 0}
    )]]


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
		if log.count < 74 then
			actions.show = false
			console_show = true
			local hov = actions.hov
			local name = unit[turn].name
			local act = {'TAKES MEDS', --[['USES PREGABALIN', ]]'USES SEDATIVE', 'TRIES TO CRY'}
			local stat = {'NAUSEA', 'IRRITATION', 'INSOMNIA'}
			--[[if log.turn > 0 then
				log.count = log.count + 1
				log.str[log.count] = ''
			end]]
			log.count = log.count + 1
			log.str[log.count] = --[['	' ..]] name .. ' ' .. act[hov]
			log.count = log.count + 1

			if hov == 1 then
				--[[if log.work < 1 then
					log.str[log.count] = 'NOTHING HAPPENS'
					--[[if turn == 1 then
						log.count = log.count + 1
						log.str[log.count] = 'OH YEAH MUST WAIT'
					end]]
				--[[	log.count = log.count + 1
					log.str[log.count] = stat[1] .. ' +1 ' .. stat[2] .. ' +1 '
					unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
					unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1 
					log.work = log.work + 1
				else]]
					if chance(.5) == 1 then
						log.str[log.count] = 'NOTHING HAPPENS'
						if log.work < 4 then
							log.work = log.work + 1
						end
						--[[if log.work == 4 then
							log.count = log.count + 1
							log.str[log.count] = 'I MEAN THAT WAS UNEXPECTED'
						end]]
						log.count = log.count + 1
						log.str[log.count] = '' .. stat[1] .. ' −1 ' .. stat[2] .. ' −1 '
						unit[turn].st['nausea'] = unit[turn].st['nausea'] - 1
						unit[turn].st['irritation'] = unit[turn].st['irritation'] - 1 
					else
						--if chance(.5) == 1 then
						log.str[log.count] = 'GOT SEROTONINE SYNDROME'
						log.count = log.count + 1
						log.str[log.count] = stat[1] .. ' +1 ' .. stat[3] .. ' +1 '
						unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1
						--[[else
							log.str[log.count] = 'NOTHING HAPPENS'
							log.count = log.count + 1
							log.str[log.count] = stat[2] .. ' +1 '
							unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1 
						end]]
					end
				--end
			--[[elseif hov == 2 then
				if log.magic < 2 then
					log.str[log.count] = 'FEELS GOOD'
					log.count = log.count + 1
					log.str[log.count] = stat[2] .. ' +1 '
					unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1
					log.magic = log.magic + 1
				else
					if not log.magic_comm_isshown then
						log.str[log.count] = 'IT WAS JUST A SIDE EFFECT'
						log.count = log.count + 1
						log.magic_comm_isshown = true
					end
					log.str[log.count] = 'FEELS NOTHING'
					log.count = log.count + 1
					log.str[log.count] = stat[2] .. ' +1 ' .. stat[1] .. ' +1 '
					unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1
					unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
				end]]
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
			--if log.turn > 2 then
			if chance(.7) == 1 and hov ~= 3 then
				randomevent()
			end
			--end
			actions:changed(turn)
			change_turn()

			if not bistro:isPlaying() then
				bistro:play()
			end

			--[[if bistro:getPitch() <= .8 and log.count < 80 then
				local p = bistro:getPitch() + .01 * log.count / 8
				love.graphics.print(p, 10, 200+88)
				bistro:setPitch(p)
			--lpitch == 1 - .5 * log.count/4
			end]]

			--[[if bistro:getVolume() <= 2 and log.count < 80 then
				local p = bistro:getVolume() + .015 * log.count / 8
				love.graphics.print(p, 10, 200+88)
				bistro:setVolume(p)
			--lpitch == 1 - .5 * log.count/4
			end]]

			if log.count >= 30 then
				tmp_void = tmp_void + 1
				--if tmp_void >= 4 then
					tmp_mul = tmp_mul * 1.9
				--end
			end
		--[[elseif key == "p" then
			if love.audio.getActiveSourceCount() ~= 0 then
				bistro:stop()
			else
				bistro:play()
				bistro:setPitch(.05)
			end
		]]
		elseif log.count >= 74 then
			love.load()
		end
	elseif key == "right" then
		local x, y, z = love.audio.getVelocity()
		--bistro:setVelocity( x+.1, y, z )
		local p = bistro:getPitch()
		bistro:setPitch(p+.01)
	elseif key == "left" then
		local x, y, z = love.audio.getVelocity()
		--bistro:setVelocity( x+.1, y, z )
		local p = bistro:getPitch()
		bistro:setPitch(p-.01)
	end
end

function randomevent(tookmeds)
	--local str = {}
	--[[str.def = {'SLEPT FOR 16 HOURS', 'JUST WANNA GO HOME', 'GETS RANDOMLY IRRITATED', 
	'COULDNT SLEEP LAST NIGHT', 'DIZZY CANT EVEN WALK PROPERLY', 'TIRED JUST REALLY TIRED'}]]

	--str.nau = {'VOMITS', 'SPILLS SOME ON THE BEDSHEETS', 'ITS FEELS IN THE THROAT'}
	--str.con = {'COULDNT MOVE', 'FEELS NO GROUND', 'JUST NO', 'SO HEAVY'}
	--str.ins = {'LOOSING GRIP OF REALITY', 'IS SOMETHING WEIRD'}

	--'STRANGLE UNIT[1]', 'SHIVERS', ''


	local stat = {'NAUSEA', 'IRRITATION', 'INSOMNIA'}
	log.count = log.count + 1
	--event 1

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

	--/event 1

	--2
		--slept for16 hours
		--nausea irritation +1
	--3
		--got randomly irritated
		--irritation +3
	--4
		--forgot to take his meds
		--serotonine syndrome
		--nausea insomnia +1
	--/this
	--and through the prism of total nausea, insomnia and irritation
	--simplify
	--jrpg
	--you can do it
	--stats tell more about your game world than narrative
	--fuk narrative
	--higher numbers and a little randomized (1,3)
	--that'll work



	
	--local max = table.getn(str.def)
	--local num = math.random(1,max)

	--log.count = log.count + 1
	--log.str[log.count] = str.def[num]

	--vomits
	--slowly loosing grip of reality
	--strangle person_2
	--couldn't sleep last night
	--couldn't sleep last week
	--slept for 16 hours
	--just wanna go home
	--can't even nothing
	--dizzy/fatigue can't walk properly
	--tired just really tired
	--forget to take meds
	--took the wrong meds / misplaced the med
	--just don't know why doing this anymore
	--endless side effect
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

	--[[love.graphics.print(table.getn(log.str), window_width/12, window_height/2+22*6)
	love.graphics.print(log.count, window_width/12, window_height/2+22*7)
	love.graphics.print(log.magic, window_width/12, window_height/2+22*8)
	love.graphics.print(log.work, window_width/12, window_height/2+22*9)]]
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

	--local hh = 0
--	local part = window_height / 8
--	love.graphics.rectangle("fill", 0, y, w, part*num)	
end


function love.draw()
	--setColor('blue')
	--love.graphics.rectangle('fill', 0, 0, window_width/3, window_height)
	--setColor('white')
	unit[0]:draw()
	unit[1]:draw()
	
	--if actions.show then
		actions:draw()
	--end

	if log.str[log.count] ~= nil then
		console()
	end

	if log.count >= 30 then
		void(tmp_void+tmp_mul)
	end

	if log.count >= 74 then
		bistro:stop()
	--	love.graphics.print('TRY AGAIN', 0, window_height - 20 * 3 -2+20*2)
	end

	--pitch == 

	--[[local x, y, z = love.audio.getVelocity()
	love.graphics.print(x .. ' , ' .. y .. ' , ' .. z, 10, 200)
	local p = bistro:getPitch()
	love.graphics.print(p, 10, 200+22)]]

	--love.graphics.print(log.count, 10, 200+66)

	--70 / 76 / 80
	--1 → .05
	--×20
	--80 / 20 → 4
	--every 4 log.cound lower pitch by .05

	--log.cout 0 / pitch 1
	--log.count 80 / pitch .05

	--80 == pitch-(20*.5)

	--love.graphics.print(log.count, 10, 200)
	--love.graphics.print(tmp_void, 10, 200+22)
	--love.graphics.print(tmp_mul, 10, 200+44)
	
	--love.graphics.print(bistro:getVolume(), 10, 200+22)
	--love.graphics.print(bistro:getPitch(), 10, 200+44)


	--74
	--11
	--582.45~

	--love.graphics.draw(rainbow, 0, 0, 0, love.graphics.getDimensions())
end