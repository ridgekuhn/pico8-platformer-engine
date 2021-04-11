---draw scaled, palette-cycled ss sprite
--
--@param sprite tbl a single table of
--	sprite data to use instead of
--	all tables in actor.sprites
function actors:ssprs(sprite)
	local sprites = sprite and {sprite} or self.sprites

	for sprite in all(sprites) do
		local dx = sprite.dx or self.x + sprite[5]
		local dy = sprite.dy or self.y + sprite[6]
		local dw = sprite.dw or sprite[3]
		local dh = sprite.dh or sprite[4]

		if (sprite.pal_swaps) then
			set_palette(sprite.pal_swaps)
		end

		sspr(
			sprite[1],
			sprite[2],
			sprite[3],
			sprite[4],
			dx,
			dy,
			dw,
			dh,
			sprite.flip_x,
			sprite.flip_y
		)

		pal()
		palt()
	end
end
