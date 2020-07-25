---player 1 controllers

---update player 1 data
function p:update()
	self:update_cors(self.cors)

	self:get_input(self:set_input_holds())

	self.altitude = self:get_altitude()

	self.hits = self:get_hits(p)

	self:update_state()

	self.sclock += 1
end

---set input holds
function p:set_input_holds()
	self.b4_hold = self.b4

	if(self.state ~= 'falling') then
		self.b5_hold = self.b5
	else
		self.b5_hold = false
	end
end

---keep player inside
--camera boundaries
function p:get_x_boundary(dx)
	if(self.x + dx >= cam.x and
		self.x + dx <= cam.x + 127 - 16
	) then
		return true
	end
end

---invincibility
function p:invincibility(t)
	local t = t or 60

	self.hits = nil
	self.invincible = true

	add(self.cors, cocreate(function()
		for i=1, t do
			self.invincible = true
			yield()
		end

		self.invincible = nil
	end))
end

---check sprite collision
function p:get_hits(actors)
	local hits = {}

	for i=1, #actors do
		if(actors == p and
			actors[i] ~= self
		) then
			local hit, xmin, ymin, xmax, ymax = self:get_coll_aabb(actors[i])

			if(hit) then
				add(hits, {
					table = 'p',
					id = i,
					xmin = xmin,
					ymin = ymin,
					xmax = xmax,
					ymax = ymax
				})
			end
		end
	end

	if(#hits > 0) then
		return hits
	end
end

---check if state should
--change to hit state
function p:get_hit_state()
	if(self.hits and
		 #self.hits > 0
	) then
		for k,v in pairs(self.hits) do
			if(not self.invincible and
				p[v.id].state == 'sliding'
			) then
				return true
			end
		end
	end
end

---controls player 1's state
function p:update_state()
	--load sprite, hitbox, bitmask
	self.sprite, self.hitbox, self.bitmask = self:get_frame()

	if(self.state == 'idle') then
		self:state_idle()
	elseif(self.state == 'running') then
		self:state_running()
	elseif(self.state == 'falling') then
		self:state_falling()
	elseif(self.state == 'jumping') then
		self:state_jumping()
	elseif(self.state == 'sliding') then
		self:state_sliding()
	elseif(self.state == 'hit') then
		self:state_hit()
	elseif(self.state == 'dead') then
		self:state_dead()
	end
end

---idle state
function p:state_idle()
	if(self:get_hit_state()) then
		self:set_state('hit')
		return
	end

	if(self.altitude > 0) then
		self:set_state('falling')
		return
	end

	if(self.b0 or self.b1) then
		self:set_state('running')
		return
	end

	if((self.b4 and not self.b4_hold) and
		self.altitude == 0
	) then
		self:set_state('jumping')
		return
	end

	if(self.b5 and not self.b5_hold) then
		self:set_state('sliding')
		return
	end
end

---running state
function p:state_running()
	if(self:get_hit_state()) then
		self:set_state('hit')
		return
	end

	if(self.altitude > 0) then
		self:set_state('falling')
		return
	end

	if(not self.b0 and not self.b1) then
		self:set_state('idle')
		return
	elseif(self.b0) then
		self.xdir = -1
		self.x += self:get_move('x', nil, self.get_x_boundary)
	elseif(self.b1) then
		self.xdir = 1
		self.x += self:get_move('x', nil, self.get_x_boundary)
	end

	if((self.b4 and not self.b4_hold) and
		self.altitude == 0
	) then
		self:set_state('jumping')
		return
	end

	if(self.b5 and not self.b5_hold) then
		self:set_state('sliding')
		return
	end
end

---falling state
function p:state_falling()
	if(self:get_hit_state()) then
		self:set_state('hit')
		return
	end

	if(self.altitude == 0) then
		self:set_state('idle')
		return
	end

	if(self.sclock > 0) then
		if(self.b0) then
			self.xdir = -1
			self.x += self:get_move('x', nil, self.get_x_boundary)
		elseif(self.b1) then
			self.xdir = 1
			self.x += self:get_move('x', nil, self.get_x_boundary)
		end
	end

	self.ydir = 1
	self.y += self:get_fall()
end

---jumping state
function p:state_jumping()
	if(self:get_hit_state()) then
		self:set_state('hit')
		return
	end

	if(not self.b4) then
		self:set_state('falling')
		return
	end

	if(self.b0) then
		self.xdir = -1
		self.x += self:get_move('x', nil, self.get_x_boundary)
	elseif(self.b1) then
		self.xdir = 1
		self.x += self:get_move('x', nil, self.get_x_boundary)
	end

	self.ydir = -1

	local dy = self:get_move('y', self:get_jump())

	if(dy == 0) then
		self:set_state('idle', true)
	else
		self.y += dy
	end
end

---sliding state
function p:state_sliding()
	if(not self.b5 or
		(self.sclock > 8 and
		self.b5_hold)
	) then
		self:set_state('idle')
		return
	end

	if(self.b4) then
		self:set_state('jumping')
		return
	end

	if(self.altitude > 0) then
		self:set_state('falling')
		return
	end

	if(self.hits and
		 #self.hits > 0
	) then
		self:set_state('idle', true)
		return
	end

	local dx = self.speed * self.xdir * 2

	self.x += self:get_move('x', dx, self.get_x_boundary)
end

---hit state
function p:state_hit()
	if(self.sclock == 0) then
		sfx(10)

		self.health -= 20

	elseif(self.sclock > 15) then
		if(self.health <= 0) then
			self:set_state('dead')
			return
		else
			self:invincibility()
			self:speak(3 + ceil(rnd(3)))

			self:set_state('idle')
		end
	end
end

---dead state
function p:state_dead()
	if(self.altitude > 0) then
		self.ydir = 1
		self.y += self:get_fall()
	end
end

