---actor base class
actors = {
	state	=	'idle',
	sclock = 0,

	x	=	0,
	y	=	0,

	speed	=	1,
	xdir = 1,
	ydir = 1,

	altitude = nil,

	rise = 8,

	hitbox = {},

	sprite = 0
}

function actors:new(o)
	local actor = o or {}
	setmetatable(actor, self)
	self.__index = self

	return actor
end

function actors:get_xmin()
	return self.x + self.hitbox.ox
end

function actors:get_xmax()
	return self.x + self.hitbox.ox + self.hitbox.w - 1
end

function actors:get_ymin()
	return self.y + self.hitbox.oy
end

function actors:get_ymax()
	return self.y + self.hitbox.oy + self.hitbox.h - 1
end

