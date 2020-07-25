---2d jump
--
--defines properties and
--methods for 2d jumps/falls
--
--dependencies:
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
---altitude and rise
--
--add these to the actors class
--model or child classes
--as needed
--
--@see actors:get_fall()
--actors.altitude = nil,
--
--@see actors:get_jump()
--actors.rise = 8,

---2d altitude
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
      return c - self:get_ymax() - 1
    end
  end

  return -1
end

--***********
--controllers
--***********
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

