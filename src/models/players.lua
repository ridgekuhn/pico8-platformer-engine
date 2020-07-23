---players class model
p = actors:new()

---players class constructor
--
--@param o table
--	the new player table
function p:new(o)
	local player = o or actors:new(o)
	setmetatable(player, self)
	self.__index = self

	player.index = #p + 1

	return player
end

