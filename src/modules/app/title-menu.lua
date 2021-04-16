---title app state

---override p8 loop
function title_init()
	title_selection = 1

	_update = title_update
	_draw = title_draw
end

---update title menu
function title_update()
	--move cursor
	if
		btnp(⬇️)
		and title_selection < 3
	then
		sfx(8)
		title_selection += 1

	elseif
		btnp(⬆️)
		and title_selection > 1
	then
		sfx(8)
		title_selection -= 1
	end

	if btnp(🅾️) then
		if title_selection == 1 then
			cfg.players = 1
			game_init()

		elseif title_selection == 2 then
			cfg.players = 2
			game_init()

		elseif title_selection == 3 then
			config_init()
		end
	end
end

---draw title menu
function title_draw()
	cls()
	camera()

	rectfill(38, 83, 90, 104, 7)

	--cursor
	local cursor_y = (title_selection * 6) + 79
	print('◆', 40, cursor_y, 0)

	--options
	print('1 player\n2 players\noptions', 48, 85, 0)

	--version
	print('V0.0.1', 100, 120, 13)
end

