---actors map tile collisions
--methods for interacting w map tiles
--
--dependencies:
--	none
--
--conflicts:
--	none

---get map cel
--convert screen vector to map cel vector
--
--@param n num screen vector
--
--@returns num flr(n/8)
function get_cel(n)
	return flr(n/8)
end

---check if map tile is solid
--
--@param x num screen vector
--
--@param y num screen vector
--
--@returns bool true if sprite flag 0
function is_solid(x, y)
	local tile = mget(get_cel(x), get_cel(y))

	return fget(tile,0)
end

---solid map tile collision
--
--checks the leading edge of
--actor's for collision with a
--"solid" map tile where
--sprite flag 0 is active
--
--ie, if player is "moving"
--to the right, then xdir=1
--and all the pixels along
--the right side of the actor
--will be checked from top
--to bottom. if player is
--"moving" down, all pixels
--along the bottom will be
--checked from left to right.
--
--the actor's xdir/ydir
--property can be bypassed
--by passing the dir argument,
--in case we need to check
--the opposite direction
--
--@param axis string required
--  the movement axis
--  to check against
--
--@param d num optional
--  how far ahead of the
--  actor to check
--
--@param dir num optional
--  1 or -1, representing the
--  actor's xdir or ydir
--
--@return num the draw
--  coordinate of the
--  map tile with sprite flag 0
function actors:get_coll_solid(axis, d, ndir)
  local d = d or 0
  local ndir = ndir or self[axis..'dir']

  if ndir == 1 then
    d += self['get_'..axis..'max'](self)
  else
    d += self['get_'..axis..'min'](self)
  end

  if axis == 'x' then
    local x = d

    for y = self:get_ymin(), self:get_ymax() - 1, 1 do
      if is_solid(x,y) then
        return get_cel(x) * 8
      end
    end
  else
    local y = d

    for x = self:get_xmin(), self:get_xmax() - 1, 1 do
      if is_solid(x,y) then
        return get_cel(y) * 8
      end
    end
  end
end

---get move distance
--
--checks if the actor can move
--freely or will collide with
--a "solid" map tile with
--sprite flag 0 set.
--
--if collision is detected,
--the method will try moving
--1px backwards until
--movement is canceled.
--
--@usage
--  self.x += self:get_move('x')
--
--@usage
--  self.x += self:get_move('y', -8)
--
--@usage
--  self.x += self:get_move('x', nil, function(self, dx)
--    if(self.x += dx < 127) then
--      return true
--    end
--  end)
--
--@param axis string required
--  the movement axis
--  to check against
--
--@param d num optional
--  how far ahead of the
--  actor to check
--
--@param in_bounds optional
--  a callback method which
--  must return true
--  to allow movement
--
--@return num the distance
--  the actor is allowed
--  to move
function actors:get_move(axis, d, in_bounds)
  local d = d or self.speed * self[axis..'dir']

  for i = d, 0, -sgn(d) do
    local c = self:get_coll_solid(axis, i)

    if type(in_bounds) == 'function' then
      if
				not c
				and in_bounds(self, i)
      then
        return i
      end
    elseif not c then
      return i
    end
  end

  return 0
end

