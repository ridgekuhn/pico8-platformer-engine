---debug methods for actors/draw-sprite

--*****
--views
--*****
---draw sprite boundaries
function actors:draw_sprite_boundaries()
	local ox = self.xdir == 1 and self.sprite[5] or self.sprite[7]
	local oy = self.ydir == 1 and self.sprite[6] or self.sprite[8]

	rect(self.x + ox,
		self.y + oy,
		self.x + ox + self.sprite[3] - 1,
		self.y + oy + self.sprite[4] - 1,
		10
	)
end

