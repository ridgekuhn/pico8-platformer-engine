---config app state

cfg = {
	cursor = 1,
	players = 2,
	music = true
}

---override p8 loop
function config_init()
	_update = config_update
	_draw = config_draw
end

---update config menu
function config_update()
	--move cursor
	if(btnp(⬇️) and cfg.cursor < 4) then
		sfx(8)
		cfg.cursor += 1

	elseif(btnp(⬆️) and cfg.cursor > 1) then
		sfx(8)
		cfg.cursor -= 1
	end

	--player select
	if(cfg.cursor == 1) then
		if(btnp(⬅️)) then
			sfx(8)
			cfg.players = 1
		elseif(btnp(➡️)) then
			sfx(8)
			cfg.players = 2
		end

	--music toggle
	elseif(cfg.cursor == 2) then
		if(btnp(⬅️) or btnp(➡️)) then
			sfx(8)
			cfg.music = not cfg.music
		end

	--save config
	elseif(cfg.cursor == 3) then
		if(btnp(🅾️)) then
			game_init()
		end

	--cancel
	elseif(cfg.cursor == 4) then
		if(btnp(🅾️)) then
			title_init()
		end
	end
end

---draw config menu
function config_draw()
	cls()
	camera()

	print('config menu')

	--cursor
	local cursor = (cfg.cursor * 7) + 7

	if(cfg.cursor >= 3) then
		cursor = (cfg.cursor * 7) + 14
	end

	print('◆', 0, cursor, 7)

	--menu options
	print('#players: '..tostr(cfg.players), 8, 14, 7)

	if(cfg.music) then
		print('music: on', 8, 21, 7)
	else
		print('music: off', 8, 21, 7)
	end

	print('start game\ncancel', 8, 35, 7)
end
