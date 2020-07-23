---actors class controller

---update actor state
--
--to use actors:set_state(),
--you will need to write
--your own update_state()
--method for your classes and
--pass it to _update()
--
--@usage
--  function _update()
--    some_class_object:update_state()
--  end
--
--function actors:update_state()
--  if(self.state == 'some_state') then
--    self:some_state()
--  elseif(self.state == 'some_other_state') then
--    self:some_other_state()
--  end
--end

---set actor state
--
--sets the actor's new state
--property and runs the
--some_class_object:update_state()
--method. call from within
--individual state methods
--and return out of the
--function.
--
--@usage
--  function some_class_object:some_state()
--    if(some_condition) then
--      self:set_state('some_other_state', true)
--      return
--    end
--
--    do_something_else()
--  end
--
--@param state string
--  representing actor state
--
--@param no_update boolean
--  seems counterintuitive,
--  but saves tokens this way.
--  pass 'true' to skip
--  updating actor state
function actors:set_state(state, no_update)
  self.state = state
  self.sclock = 0

  if(not no_update) then
    self:update_state()
  end
end

---update coroutines
--
--@param cors table
--  of coroutines to run
--  on this update loop
function actors:update_cors(cors)
  for cor in all(cors) do
    if(costatus(cor) == 'suspended') then
      coresume(cor)
    elseif(costatus(cor) == 'dead') then
      del(cors, cor)
    end
  end
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
function actors:get_coll_solid(axis, d, dir)
  local d = d or 0
  local dir = dir or self[axis..'dir']

  if(dir == 1) then
    d += self['get_'..axis..'max'](self) - 1
  else
    d += self['get_'..axis..'min'](self)
  end

  if(axis == 'x') then
    local x = d

    for y = self:get_ymin(), self:get_ymax() - 1, 1 do
      if(is_solid(x,y)) then
        return get_cel(x) * 8
      end
    end
  else
    local y = d

    for x = self:get_xmin(), self:get_xmax() - 1, 1 do
      if(is_solid(x,y)) then
        return get_cel(y) * 8
      end
    end
  end
end

---get altitude
--
--checks all pixels below
--the actor for the first
--"solid" map tile with
--sprite flag 0
--
--@usage
--  self.altitude = self:get_altitude()
--
--@return num the distance
--  between the actor
--  and the solid map tile
--
--@return num -1 if no solid
--  map tile is detected
--  in the possible draw area
function actors:get_altitude()
  for i=1, 127, 8 do
    local c = self:get_coll_solid('y', i, 1)

    if(c) then
      return c - self:get_ymax()
    end
  end

  return -1
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
  local d = d or (self.speed * self[axis..'dir'])

  for i = d, 0, -sgn(d) do
    local c = self:get_coll_solid(axis, i)

    if(type(in_bounds) == 'function') then
      if(not c and
        in_bounds(self, i)
      ) then
        return i
      end
    elseif(not c) then
      return i
    end
  end

  return 0
end

---fall distance
--
--checks how far an actor
--can fall after adding gravity
--before colliding with a
--"solid" map tile with
--sprite flag 0
--
--@usage
--  self.ydir = 1
--  self.y += self:get_fall()
--
--@param m num passed to
--  get_gravity() for
--  modifying gravitational
--  acceleration
--
--@return the distance
--  the actor is allowed
--  to move downward
function actors:get_fall(m)
  local dy = get_gravity(self.sclock, m)

  if(dy > self.altitude) then
    return self.altitude
  end

  return dy
end

---jump distance
--
--checks how far an actor
--can jump after adding
--gravitational deceleration.
--
--@usage
--  local dy = self:get_move('y', self:get_jump())
--
--  if(dy == 0) then
--    self:set_state('idle')
--    return
--  else
--    self.y += dy
--  end
--
--@param rise num how far the
--  actor can rise before
--  applying gravitational
--  deceleration
--
--@param m num passed to
--  get_gravity() for
--  modifying gravitational
--  deceleration
--
--@return the distance
--  the actor is allowed
--  to move upward
function actors:get_jump(rise, m)
  local rise = rise or self.rise
  local decel = get_gravity(self.sclock, m)

  if(decel >= rise) then
    return 0
  else
    return -(rise - get_gravity(self.sclock))
  end
end

