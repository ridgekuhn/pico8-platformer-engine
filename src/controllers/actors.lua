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

  if not no_update then
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
    if costatus(cor) == 'suspended' then
      coresume(cor)
    elseif costatus(cor) == 'dead' then
      del(cors, cor)
    end
  end
end
