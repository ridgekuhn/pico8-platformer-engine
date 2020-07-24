---game app state

---initialize game app state
function game_init()
	gameclock = 0

	camera_init()

	--reset dirty tables
	for table in all({e, p}) do
		for actor in all(table) do
			del(table, actor)
		end

		if(type(table.init) == 'function') then
			table:init()
		end
	end

	_update = game_running_update
	_draw = game_running_draw

	--update the game once
	--before game_running_draw()
	--is called
	_update()
end

---update game running state
function game_running_update()
	--check for game over
	for player in all(p) do
		if(player.state == 'dead') then
			gameclock = 0

			_update = game_over_update
			_draw = game_over_draw
		end

		player:update()
	end

	--player 1 monologue
	if(#p == 1 and
		gameclock % 300 == 0
	) then
		p[1]:speak(ceil(rnd(3)))
	end

	gameclock += 1
end

---draw game app state
function game_running_draw()
	cls()

	map()

	p:draw()

	hud_draw()

	--debug
	p[1]:draw_hitbox()

	if(#p == 2) then
		p[1]:draw_coll_aabb(p[2])
	end

	print('mem: '..stat(0), 0, 0, 7)
	print('cpu: '..stat(1), 0, 7, 7)
end

---update game over state
function game_over_update()
	if(gameclock > 90 and
		(btnp(4) or btnp(5))
	) then
		title_init()
	end

	for player in all(p) do
		if(player.state ~= 'dead') then
			player.b2 = nil
			player.b3 = nil
			player.b4 = true
			player.b4_hold = nil

			player.altitude = player:get_altitude()
			player:update_state()
			player.sclock += 1
		end
	end

	gameclock += 1
end

--draw game over state
function game_over_draw()
	cls()

	map()

	p:draw()

	print_centered('game over', nil, nil, nil, true)
end

