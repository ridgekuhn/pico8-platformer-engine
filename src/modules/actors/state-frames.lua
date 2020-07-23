---actor state frames
--
--provides a method to
--"animate" an actor's
--sprite, hitbox, and bitmask
--properties using the
--state and sclock properties
--
--requirements:
--	none
--
--extends:
--	none
--
--conflicts:
--	none

--******
--models
--******
---states table
--add this table template
--while/after instantiating
--a child class of actors,
--and before defining
--the child's :new() method.
--
--some_new_actors = actors:new({
--	some_property = some_value,
--
--	states = {
--		some_state =	{
--			frames = {
--				lpf = 1,
--				sprites = {
--					{
--						sx = 0,
--						sy = 0,
--						sw = 8,
--						sh = 8,
--						dw = 8, --optional
--						dh = 8, --optional
--						flip_x = false, --optional
--						flip_y = false, --optional
--					},
--					hitboxes = {
--						{
--							w = 8,
--							h = 8,
--							ox = 0,
--							oy = 0,
--						}
--					}
--				}
--			}
--		},
--		etc.
--	}
--})

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
--  self.sprite, self.hitbox = self:set_sprite()
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
