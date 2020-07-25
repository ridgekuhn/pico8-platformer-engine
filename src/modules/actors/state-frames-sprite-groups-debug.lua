---debug methods for actors/state-frames-sprite-groups

--*****
--views
--*****
---draw sprite boundaries
function actors:draw_sprite_boundaries()
	for sprite in all(self.sprite) do
		local ox = self.xdir == 1 and sprite[5] or sprite[7]
		local oy = self.ydir == 1 and sprite[6] or sprite[8]

		rect(self.x + ox,
			self.y + oy,
			self.x + ox + sprite[3] - 1,
			self.y + oy + sprite[4] - 1,
			10
		)
	end
end

