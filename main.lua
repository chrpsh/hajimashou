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
    log.magic_comm_isshown = false
    log.turn = 0

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
		actions.show = false
		console_show = true
		local hov = actions.hov
		local name = unit[turn].name
		local act = {'TAKES MEDS', 'USES PREGABALIN', 'USES SEDATIVE', 'TRIES TO CRY'}
		local stat = {'NAUSEA', 'IRRITATION', 'INSOMNIA'}
		--[[if log.turn > 0 then
			log.count = log.count + 1
			log.str[log.count] = ''
		end]]
		log.count = log.count + 1
		log.str[log.count] = --[['	' ..]] name .. ' ' .. act[hov]
		log.count = log.count + 1

		if hov == 1 then
			if log.work < 2 then
				log.str[log.count] = 'NOTHING HAPPENS'
				--[[if turn == 1 then
					log.count = log.count + 1
					log.str[log.count] = 'OH YEAH MUST WAIT'
				end]]
				log.count = log.count + 1
				log.str[log.count] = stat[1] .. ' +1 ' .. stat[2] .. ' +1 '
				unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
				unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1 
				log.work = log.work + 1
			else
				if chance(.3) == 1 then
					log.str[log.count] = 'THEY WORK'
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
					if chance(.5) == 1 then
						log.str[log.count] = 'GOT SEROTONINE SYNDROME'
						log.count = log.count + 1
						log.str[log.count] = stat[1] .. ' +1 ' .. stat[3] .. ' +1 '
						unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
						unit[turn].st['insomnia'] = unit[turn].st['insomnia'] + 1 
					else
						log.str[log.count] = 'HAVE TOLERANCE'
						log.count = log.count + 1
						log.str[log.count] = stat[2] .. ' +1 '
						unit[turn].st['irritation'] = unit[turn].st['irritation'] + 1 
					end
				end
			end
		elseif hov == 2 then
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
			end
		elseif hov == 3 then
			if chance(.3) == 1 then
				log.str[log.count] = 'EASES PAIN'
				log.count = log.count + 1
				log.str[log.count] = '' .. stat[2] .. ' −1 ' .. stat[3] .. ' −1 '
				unit[turn].st['irritation'] = unit[turn].st['irritation'] - 1
				unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
			else
				if chance(.5) == 1 then
					log.str[log.count] = 'SUDDENLY FELLS ASLEEP'
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
		elseif hov == 4 then
			log.str[log.count] = 'CAN’T JUST CAN’T'
			log.count = log.count + 1
			log.str[log.count] = stat[1] .. ' +1 '
			unit[turn].st['nausea'] = unit[turn].st['nausea'] + 1
		end
		if log.turn > 2 then
			if chance(.5) == 1 then
				randomevent()
			end
		end
		actions:changed(turn)
		change_turn()
	end
end

function randomevent()
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
	log.str[log.count] = '	ENCOUNTERS DIZZINESS'
	log.count = log.count + 1
	log.str[log.count] = stat[1] .. ' +3 ' .. stat[2] .. ' +2 '
	unit[turn].st['irritation'] = unit[turn].st['irritation'] - 1
	unit[turn].st['insomnia'] = unit[turn].st['insomnia'] - 1
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


function love.draw()
	setColor('blue')
	love.graphics.rectangle('fill', 0, 0, window_width/3, window_height)
	setColor('white')
	unit[0]:draw()
	unit[1]:draw()
	
	--if actions.show then
		actions:draw()
	--end

	if log.str[log.count] ~= nil then
		console()
	end
end