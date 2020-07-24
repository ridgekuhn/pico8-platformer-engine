---per-pixel collisions

function make_bitmask(sprite, hitbox, tcol)
	local tcol = tcol or 0

	assert(flr(hitbox.w/32) <= 1, '32+ pixels wide not supported')

	local bitmask = {}
	local bitmask_flip_x = {}

	for y = 0, hitbox.h - 1 do
		local bits = 0
		local bits_flip_x = 0

		for x = 0, hitbox.w - 1 do
			local mask = 0x8000.0000
			local col = sget(sprite.sx + hitbox.ox + x, sprite.sy + hitbox.oy + y)

			if(col ~= tcol) then
				bits = bits |	(mask >>> x)
				bits_flip_x = bits_flip_x | (mask <<> x + 1)
			end
		end

		bitmask[y] = bits
		bitmask_flip_x[y] = bits_flip_x << 32 - hitbox.w
	end

	return bitmask, bitmask_flip_x
end

function actors:set_bitmasks()
	for k, state in pairs(self.states) do
		state.frames.bitmasks = {}
		state.frames.bitmasks_flip_x = {}

		for i=1, #state.frames.sprites do
			state.frames.bitmasks[i], state.frames.bitmasks_flip_x[i] = make_bitmask(state.frames.sprites[i], state.frames.hitboxes[i])
		end
	end
end

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

  local d = frames.lpf * #frames.sprites
  local aclock = 0
  local f = 0

  if(clock == 0 and frames.r) then
    frames.r = nil
  end

  if(not frames.rev) then
    aclock = clock % d
    f = flr((aclock / d) * #frames.sprites) + 1

  elseif(frames.rev) then
    local nframes = (#frames.sprites * 2) - 2
    local rd = frames.lpf * nframes

    aclock = clock % rd

    if(not frames.r) then
      f = flr((aclock / d) * #frames.sprites) + 1

      if(clock > 0 and aclock == (d - 1)) then
        frames.r = true
      end

    else
      f = abs(flr((aclock / rd) * nframes) - (#frames.sprites * 2) + 1)

      if(f == 2 and aclock == (rd - 1)) then
        frames.r = false
      end
    end
  end

  return frames.sprites[f], frames.hitboxes[f], bitmask[f]
end

function actors:get_coll_aabb(actor)
  local l = self
  local r = actor

  if(l.x > r.x) l, r = r, l

  local l_xmin = flr(l:get_xmin())
  local l_xmax = flr(l:get_xmax())
  local l_ymin = flr(l:get_ymin())
  local l_ymax = flr(l:get_ymax())

  local r_xmin = flr(r:get_xmin())
  local r_xmax = flr(r:get_xmax())
  local r_ymin = flr(r:get_ymin())
  local r_ymax = flr(r:get_ymax())

  if(l_xmin < r_xmax and
      l_xmax > r_xmin and
      l_ymin < r_ymax and
      l_ymax > r_ymin
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

