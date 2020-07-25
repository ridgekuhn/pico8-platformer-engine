---per-pixel collisions
--
--detect if actors have collided
--using a combination of
--axis-aligned bounding boxes
--and bitmasks
--
--dependencies:
--  none
--
--extends:
--  none
--
--conflicts:
--  actors/state-frames
--    @see actors:get_frame()
--  actors/collision-aabb
--    @see actors:get_coll_aabb()

--******
--global
--******
---create bitmasks
--
--converts sprite/hitbox data to
--a bitmask for "pixel perfect"
--collision detection
--@see actors:set_bitmask()
--@see actors:get_coll_px()
--
--informed by:
--freds72 per-pixel api
--@see https://www.lexaloffle.com/bbs/?pid=70445#p
--
--@param sprite table
--  of sprite data
--
--@param hitbox table
--  of hitbox data
--
--@param tcol num transparent
--  color in spritesheet
function make_bitmask(sprite, hitbox, tcol)
  local tcol = tcol or 0

  assert(flr(hitbox[1]/32) <= 1, '32+ pixels wide not supported')

  local bitmask = {}
  local bitmask_flip_x = {}

  for y = 0, hitbox[2] - 1 do
    local bits = 0
    local bits_flip_x = 0

    for x = 0, hitbox[1] - 1 do
      local mask = 0x8000.0000
      local col = sget(sprite[1] - sprite[5] + hitbox[3] + x, sprite[2] - sprite[6] + hitbox[4] + y)

      if(col ~= tcol) then
        bits = bits |  (mask >>> x)
        bits_flip_x = bits_flip_x | (mask <<> x + 1)
      end
    end

    bitmask[y] = bits
    bitmask_flip_x[y] = bits_flip_x << 32 - hitbox[1]
  end

  return bitmask, bitmask_flip_x
end

--******
--models
--******
---states table property
--
--behaves exactly as
--@see /src/modules/actors/state-frames.lua
--but we provide a modified
--version of
--@see actors:get_frame()

---set actor bitmasks
--
--iterates actor.states table
--and creates bitmasks
--for each state's frames.
--
--call after defining the
--actor states table
function actors:set_bitmasks()
  for k, state in pairs(self.states) do
    state.frames.bitmasks = {}
    state.frames.bitmasks_flip_x = {}

    for i=1, #state.frames.sprites do
      state.frames.bitmasks[i], state.frames.bitmasks_flip_x[i] = make_bitmask(state.frames.sprites[i], state.frames.hitboxes[i])
    end
  end
end

--***********
--controllers
--***********
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
--
--@return table
--  of bitmask metadata
function actors:get_frame(frames, clock)
  local frames = frames or self.states[self.state].frames
  local clock = clock or self.sclock
  local bitmask = {}

  frames.hitboxes = frames.hitboxes or {}
  frames.bitmasks = frames.bitmasks or {}

  if(self.xdir == 1) then
    bitmask = frames.bitmasks
  else
    bitmask = frames.bitmasks_flip_x
  end

  if(#frames.sprites == 1) then
    return frames.sprites[1], frames.hitboxes[1], bitmask[1]
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

  return frames.sprites[f], frames.hitboxes[f], bitmask[f]
end

---aabb sprite collision
--
--checks for collision with
--another actor object.
--
--@usage
--  function some_actor:check_hits()
--    for enemy in all(enemies) do
--      if(some_actor:coll_aabb(enemy)) then
--        do_something()
--      end
--    end
--  end
--
--@param actor table
--  to check for
--  collisions against
--
--@return boolean true if
--  collision detected
--
--@return num leftmost draw
--  coordinate of the collision
--
--@return num leftmost draw
--  coordinate of the collision
--
--@return num top draw
--  coordinate of the collision
--
--@return num rightmost draw
--  coordinate of the collision
--
--@return num bottom draw
--  coordinate of the collision
--
--@return table leftmost actor
--
--@return table rightmost actor
function actors:get_coll_aabb(actor)
  local l = self
  local r = actor

  --set leftmost actor
  if(l.x > r.x) l, r = r, l

  local l_xmin = flr(l:get_xmin())
  local l_xmax = flr(l:get_xmax())
  local l_ymin = flr(l:get_ymin())
  local l_ymax = flr(l:get_ymax())

  local r_xmin = flr(r:get_xmin())
  local r_xmax = flr(r:get_xmax())
  local r_ymin = flr(r:get_ymin())
  local r_ymax = flr(r:get_ymax())

  --check hitbox overlap
  if(l_xmin <= r_xmax and
      l_xmax >= r_xmin and
      l_ymin <= r_ymax and
      l_ymax >= r_ymin
  ) then
    return true,
      r_xmin,
      max(l_ymin, r_ymin),
      min(l_xmax, r_xmax),
      min(l_ymax, r_ymax),
      l,
      r
  end
end

---per-pixel sprite collision
--
--check if actor sprite pixels
--overlap with another actor
--
--@param actor table
--  to check for
--  collisions against
--
--@return bool true
--  if collision detected
function actors:get_coll_px(actor)
  local hit, xmin, ymin, xmax, ymax, l, r = self:get_coll_aabb(actor)

  if(hit) then
    local ly = flr(l:get_ymin())
    local ry = flr(r:get_ymin())

    local l_oy_min = max(ymin - ly)
    local l_oy_max = ymax - ly

    local r_oy = ly - ry

    for y = l_oy_min, l_oy_max do
      local c = l.bitmask[y] & (r.bitmask[r_oy + y] >>> xmin - flr(l:get_xmin()))

      if(c ~= 0) then
        return true
      end
    end
  end
end

