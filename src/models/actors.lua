---actor base class
--the heart of the engine!

---actor table defaults
--
--though not necessarily
--required, the following
--properties are expected
--by their respective
--methods in the base engine
--or modules as noted
actors = {
  --****************
  --class properties
  --
  --define these on children
  --of the actors class
  --when instantiating
  --the child class table
  --
  --@see actors:new()
  --****************
  --some_property = some value,
  --
  ------------
  --coroutines
  --
  --optional. can be named
  --anything and called by
  --@see actors:update_cors()
  ----------------------
  --updatecors = {},
  --drawcors = (),
  --
  --*****************
  --object properties
  --
  --define new properties
  --as needed when you
  --instantiate each object,
  --either in the newclass:new()
  --method, or when calling
  --newclass:new() via add()
  --*********
  -------
  --state
  -------
  --@see actors:set_state()
  state = 'idle',
  sclock = 0,

  ----------
  --position
  ----------
  x = 0,
  y = 0,

  ----------
  --movement
  ----------
  --@see actors:get_move()
  speed = 1,
  xdir = 1,
  ydir = 1,

  --@see actors:get_fall()
  altitude = nil,

  --@see actors:get_jump()
  rise = 8,

  -----------
  --collision
  -----------
  --define manually as needed,
  --or load with
  --@see actors:get_frame()
  --in /src/modules/actors/state-frames.lua
	--
  --@see actors:get_xmin()
  --@see actors:get_xmax()
  --@see actors:get_ymin()
  --@see actors:get_ymax()
  --@see actors:get_map_solid_coll()
  hitbox = {
		--height
    [1] = 8,
		--width
    [2] = 8,
		--x-offset from self.x
    [3] = 0,
		--y-offset from self.y
    [4] = 0
  },

  ------
  --draw
  ------

  ------------
  --coroutines
  --
  --optional. can be named
  --anything and called by
  --@see actors:update_cors()
  ----------------------
  --updatecors = {},
  --drawcors = ()
}

---actors class constructor
--
--creates a new child class
--and sets metatables
--and indexes
--
--@usage
--  players = actors:new({
--    some_property = 'foo'
--  })
--
--@param o table optional
--  properties belonging
--  to the new child class
function actors:new(o)
  local actor = o or {}
  --use the parent table
  --for instantiated objects
  setmetatable(actor, self)
  --fallback to the parent
  --table for undefined
  --properties
  self.__index = self

  return actor
end

--actor collision coordinates
function actors:get_xmin()
  return self.x + self.hitbox[3]
end

function actors:get_xmax()
  return self.x + self.hitbox[3] + self.hitbox[1] - 1
end

function actors:get_ymin()
  return self.y + self.hitbox[4]
end

function actors:get_ymax()
  return self.y + self.hitbox[4] + self.hitbox[2] - 1
end

