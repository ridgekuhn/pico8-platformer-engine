---game app state

---initialize game app state
function game_init()
	gameclock = 0

	--reset dirty tables
	for table in all({p}) do
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
	--if(some_condition) then
	--	_update = game_over_update
	--	_draw = game_over_draw
	--end

	gameclock += 1
end

---draw game app state
function game_running_draw()
	cls()
end

---update game over state
function game_over_update()
end

--draw game over state
function game_over_draw()
end

