---players class model
p = actors:new()

function p:new(o)
	local player = o or actors:new(o)
	setmetatable(player, self)
	self.__index = self

	player.index = #p + 1

	return player
end

