---make a deep/recursive copy of a table
--@see http://lua-users.org/wiki/CopyTable
--
--@param tbl original table
--
--@returns tbl copy of original table
function deepcopy(orig)
	local orig_type = type(orig)
	local copy

	if orig_type == 'table' then
		copy = {}

		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end

		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end

	return copy
end
