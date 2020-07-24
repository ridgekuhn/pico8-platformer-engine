---global controller functions

function get_cel(n)
	return flr(n/8)
end

function is_solid(x, y)
	local tile = mget(get_cel(x), get_cel(y))

	return fget(tile,0)
end

function get_gravity(clock, m)
	local m = m or 1

	if(clock == 2) then
		return 2
	else
		return ceil((clock/2)^2) * m
	end
end

