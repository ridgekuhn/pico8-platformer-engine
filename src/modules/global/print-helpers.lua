---global view functions

---print centered
function print_centered(str, camx, camy, col, shadow)
	local camx = camx or 0
	local camy = camy or 0
	local col = col or 7

	local x = camx + 64
	local y = camy + 60

	if(shadow) then
		print_shadow(str, x - (#str * 2), y, col)
	else
		print(str, x - (#str * 2), y, col)
	end
end

---print with drop shadow
function print_shadow(str, camx, camy, col, scol)
	local camx = camx or 0
	local camy = camy or 0
	local col = col or 7
	local scol = scol or 1

	print(str, camx + 1, camy + 1, scol)
	print(str, camx, camy, col)
end

