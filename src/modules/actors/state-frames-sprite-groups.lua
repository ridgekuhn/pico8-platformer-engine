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
--some_actors.sprite = {
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
--		[9] = 8,
--		--optional, draw height
--		[10] = 8,
--		--optional, flip_x
--		[11] = nil,
--		--optional, flip_y
--		[12] = nil
--	},
--	{8,0,8,8,0,0,0,0},
--	{16,0,8,8,0,0,0,0},
--	--etc.
--},

---serialized states table
--
--serialize sprite and hitbox
--states table frame data as
--a comma-delimited string,
--and then call this function
--to convert the string
--back to a table.
--
--@usage
--	some_actors = actors:new({
--		states = {
--			some_state =	{
--				frames = {
--					lpf = 1,
--					sprites = {
--						--sprite group frame 1
--						{
--							--character head sprite
--							'0,0,8,8,0,0,0,0',
--							--character body sprite
--							'8,0,8,8,0,0,0,0'
--						},
--						--sprite group frame 2
--						{
--							--character head sprite
--							'0,0,8,8,0,0,0,0',
--							--character body sprite
--							'8,0,8,8,0,0,0,0'
--						},
--						--etc
--					},
--					hitboxes = {
--						'8,8,0,0',
--						'8,8,0,0',
--						'8,8,0,0'
--					}
--				}
--			},
--			--etc
--		}
--	})
--
--	some_actors:deserialize_frames()
function actors:deserialize_frames()
	for k, state in pairs(self.states) do
		for table, v in pairs(state.frames) do
			if(table == 'hitboxes') then
				for i=1, #v do
					v[i] = split(v[i], ",")
				end
			elseif(table == 'sprites') then
				for spritegroup in all(v) do
					for i=1, #spritegroup do
						spritegroup[i] = split(spritegroup[i], ",")
					end
				end
			end
		end
	end
end

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
	for sprite in all(self.sprite) do
		local ox = self.xdir == 1 and sprite[5] or sprite[7]
		local oy = self.ydir == 1 and sprite[6] or sprite[8]
		local dw = sprite[9] or sprite[3]
		local dh = sprite[10] or sprite[4]
		local flip_x = sprite[11] or self.xdir == -1
		--@todo is there ever a reason to flip_y?
		local flip_y = sprite[12] --or self.ydir == -1

		sspr(sprite[1],
				 sprite[2],
				 sprite[3],
				 sprite[4],
				 self.x + ox,
				 self.y + oy,
				 dw,
				 dh,
				 flip_x,
				 flip_y
		)
	end
end

