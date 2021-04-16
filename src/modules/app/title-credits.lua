function credits_init()
	music(0)

	_update = credits_update
	_draw = credits_draw
end

function credits_update()
	if time() > 3 then
		title_init()
		return
	end
end

function credits_draw()
	cls()

	if time() < 3 then
		print_centered('a', nil, -14)
		print_centered('game engine by:', nil, -7)
		print_centered('ridgek', nil, 7)
		print_centered('𝘩𝘵𝘵𝘱𝘴://𝘳𝘪𝘥𝘨𝘦𝘬.𝘪𝘵𝘤𝘩.𝘪𝘰', nil, 14)
	end
end
