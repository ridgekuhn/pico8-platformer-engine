---actor state frames
--
--provides a method to
--"animate" an actor's
--sprite, hitbox, and bitmask
--properties using the
--state and sclock properties
--
--dependencies:
--	actors/draw-sprite
--		@see actors:draw_sprite()
--
--extends:
--	none
--
--conflicts:
--	none

--******
--models
--******
---states table property
--
--add the states table
--while/after instantiating
--a child class of actors,
--and before defining
--the child's :new() method.
--
--hitboxes definitions
--are optional, but if you
--do define them,
--#hitboxes must equal #sprites
--
--@usage
--	some_new_actors = actors:new({
--		states = {
--			some_state =	{
--				frames = {
--					lpf = 1,
--					sprites = {
--						{
--							--spritesheet x position
--							[1] = 0,
--
--							--spritesheet y position
--							[2] = 0,
--
--							--sprite width
--							[3] = 8,
--
--							--sprite height
--							[4] = 8,
--
--							--x-offset from self.x
--							[5] = 0,
--
--							--y-offset from self.y
--							[6] = 0,
--
--							--x-offset from self.x
--							--when sprite is
--							--flipped horizontally
--							[7] = 0,
--
--							--y-offset from self.y
--							--when sprite is
--							--flipped vertically
--							[8] = 0,
--
--							--optional, draw width
--							[9] = 8,
--
--							--optional, draw height
--							[10] = 8,
--
--							--optional, flip_x
--							[11] = nil,
--
--							--optional, flip_y
--							[12] = nil
--						},
--						--etc.
--
--						hitboxes = {
--							{
--								--height
--								[1] = 8,
--
--								--width
--								[2] = 8,
--
--								--x-offset from self.x
--								[3] = 0,
--
--								--y-offset from self.y
--								[4] = 0
--							},
--							--etc.
--						}
--					}
--				}
--			},
--			--etc.
--		}
--	})

---deserialize frame strings
--
--to save on tokens, you can
--serialize sprite and hitbox
--frame data as
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
--						'0,0,8,8,0,0,0,0',
--						'8,0,8,8,0,0,0,0',
--						'16,0,8,8,0,0,0,0'
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
		for table, strings in pairs(state.frames) do
			if(table == 'sprites' or
				table == 'hitboxes'
			) then
				for i=1, #strings do
					if(type(strings[i] == 'string')) then
						strings[i] = split(strings[i], ",")
					end
				end
			end
		end
	end
end

---sprite property
--
--set using
--@see actors:get_frame()
--
--@usage
--	some_actors.sprite = some_actors:get_frame()

--*****
--views
--*****
---frame animation
--
--set the actor sprite and
--corresponding hitbox by
--loading data from
--the actor's .states table
--
--can be overridden to load
--any arbitrary table of
--sprite metadata against
--any arbitrary clock
--
--@usage
--  self.sprite, self.hitbox = self:get_frame()
--
--@param sprites table optional
--  set of sprite data
--
--@param clock num optional
--  clock to animate against
--
--@return table
--  of sprite metadata
--
--@return table
--  of hitbox metadata
function actors:get_frame(frames, clock)
  local frames = frames or self.states[self.state].frames
  local clock = clock or self.sclock

	frames.hitboxes = frames.hitboxes or {}

  if(#frames.sprites == 1) then
    return frames.sprites[1], frames.hitboxes[1]
  end

  --total duration of animation
  local d = frames.lpf * #frames.sprites
  local aclock = 0
  local f = 0

  --reset dirty animation
  if(clock == 0 and frames.r) then
    frames.r = nil
  end

  --animation is not reversible
  if(not frames.rev) then
    aclock = clock % d
    f = flr((aclock / d) * #frames.sprites) + 1

  --animation is reversible
  elseif(frames.rev) then
    --total frames of reversed
    --animation, excluding
    --the first and last
    local nframes = (#frames.sprites * 2) - 2
    --total duration
    --of animation
    local rd = frames.lpf * nframes

    aclock = clock % rd

    --animation is
    --playing forward
    if(not frames.r) then
      f = flr((aclock / d) * #frames.sprites) + 1

      if(clock > 0 and aclock == (d - 1)) then
        frames.r = true
      end

    --animation is
    --playing backwards
    else
      f = abs(flr((aclock / rd) * nframes) - (#frames.sprites * 2) + 1)

      if(f == 2 and aclock == (rd - 1)) then
        frames.r = false
      end
    end
  end

  return frames.sprites[f], frames.hitboxes[f]
end

