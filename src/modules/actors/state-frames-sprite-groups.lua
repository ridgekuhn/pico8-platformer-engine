---state frames sprite groups
--
--dependencies:
--	actors/state-frames
--
--extends:
--	actors/collision-aabb
--
--conflicts:
--	actors/collision-per-px
--	actors/draw-sprite
--	actors/state-frames-deserialize

--******
--models
--******
---sprite property
--
--define manually as needed.
--or load with
--@see actors:get_frame()
--@see actors:draw_sprite()
--
--some_actors.sprites = {
--	{
--		--spritesheet x position
--		[1] = 0,
--		--spritesheet y position
--		[2] = 0,
--		--sprite width
--		[3] = 8,
--		--sprite height
--		[4] = 8,
--		--x-offset from self.x
--		[5] = 0,
--		--y-offset from self.y
--		[6] = 0,
--		--x-offset from self.x
--		--when sprite is
--		--flipped horizontally
--		[7] = 0,
--		--y-offset from self.y
--		--when sprite is
--		--flipped vertically
--		[8] = 0,
--		--optional, draw width
--		dw = 8,
--		--optional, draw height
--		dh = 8,
--		--optional, flip_x
--		[11] = nil,
--		--optional, flip_y
--		[12] = nil
--	},
--	{8,0,8,8,0,0,0,0},
--	{16,0,8,8,0,0,0,0},
--	--etc.
--},

--*****
--views
--*****
---draw the actor to the screen
--
--gets the actor.sprite
--property and draws the sprite
--using sspr()
--
--this method will automatically
--flip_x if self.xdir == -1
function actors:draw_sprite()
	local _ENV = self

	for sprite in all(sprites) do
		local ox = xdir == 1 and sprite[5] or sprite[7]
		local oy = ydir == 1 and sprite[6] or sprite[8]
		local dw = sprite.dw or sprite[3]
		local dh = sprite.dh or sprite[4]
		local flip_x = sprite.flip_x or xdir == -1
		--@todo is there ever a reason to flip_y?
		local flip_y = sprite.flip_y --or ydir == -1

		sspr(sprite[1],
				 sprite[2],
				 sprite[3],
				 sprite[4],
				 x + ox,
				 y + oy,
				 dw,
				 dh,
				 flip_x,
				 flip_y
		)
	end
end

