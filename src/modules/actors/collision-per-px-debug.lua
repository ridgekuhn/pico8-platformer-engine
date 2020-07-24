---debug functions for actors/collision-per-px

--***********
--controllers
--***********
---per-pixel sprite collision
--
--overrides default method
--to draw overlapping sprites
--@see actors:draw_coll_px()
--
--the only difference is
--this returns a bitmask table
--instead of a boolean
--
--@param actor table
--  to check for
--  collisions against
--
--@return table bitmask for
--  sprite collisions
--  relative to
--  leftmost actor
--  as determined by
--  @see actors:get_coll_aabb()
--
--@return leftmost actor
--
--@return y-offset of collision
--  relative to leftmost actor
function actors:get_coll_px(actor)
  local hit, xmin, ymin, xmax, ymax, l, r = self:get_coll_aabb(actor)

  if(hit) then
    local ly = flr(l:get_ymin())
    local ry = flr(r:get_ymin())

    local l_oy_min = max(ymin - ly)
    local l_oy_max = ymax - ly

    local r_oy = ly - ry

    local bitmask = {}

    for y = l_oy_min, l_oy_max - 1 do
      local c = l.bitmask[y] & (r.bitmask[r_oy + y] >>> xmin - flr(l:get_xmin()))

      if(c ~= 0) then
        add(bitmask, c)
      end
    end

    if(bitmask ~= {}) then
      return bitmask, l, l_oy_min
    end
  end
end

--*****
--views
--*****
---draw actor bitmask
--
--@param bitmask table
--  of bitmask data
function actors:draw_bitmask(bitmask)
  local bitmask = bitmask or self.bitmask

  local mask = 0x8000.0000

  for y=0, self.hitbox[2] - 1 do
    for x=0, self.hitbox[1] - 1 do
      local bit = (mask >>> x) & self.bitmask[y]

      if(bit ~= 0) then
        pset(self:get_xmin() + x, self:get_ymin() + y, 8)
      end
    end
  end
end

---draw sprite collisions
--
--draws the overlapping pixels
--of actor and another actor
--
--@param actor table
--  to check for
--  collisions against
function actors:draw_coll_px(actor)
  local coll_bitmask, l_actor, ymin = self:get_coll_px(actor)

  if(coll_bitmask) then
    local mask = 0x8000.0000

    for y=0, #coll_bitmask - 1 do
      for x=0, l_actor.hitbox[1] - 1 do
        local bit = (mask >>> x) & coll_bitmask[y + 1]

        if(bit~= 0) then
          pset(l_actor:get_xmin() + x, l_actor:get_ymin() + ymin + y, 8)
        end
      end
    end
  end
end
