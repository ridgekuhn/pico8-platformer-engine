---gravity-related functions
--
--dependencies:
--	none
--
--conflicts:
--	none

---gravitational acceleration
--
--@param clock num actor clock
--
--@param m num gravitional multiplier
--
--@returns num distance to move actor
function get_gravity(clock, m)
	local m = m or 1

	if clock == 2 then
		return 2
	else
		return ceil((clock/2)^2) * m
	end
end
