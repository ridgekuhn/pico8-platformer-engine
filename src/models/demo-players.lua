---player 1 model

--describe default player properties

p.states= {
	idle = {
		frames = {
			lpf = 1,
			sprites = {
				'0,0,8,16,5,0,3,0'
			},
			hitboxes = {
				'6,16,5,0'
			}
		}
	},
	jumping = {
		frames = {
			lpf = 1,
			sprites = {
				'40,0,15,16,0,0,1,0'
			},
			hitboxes = {
				'6,16,5,0'
			}
		}
	},
	running = {
		frames = {
			lpf = 5,
			rev = true,
			sprites = {
				'8,0,12,16,2,0,2,0',
				'19,0,9,16,3,0,4,0',
				'28,0,12,16,2,0,2,0'
			},
			hitboxes = {
				'6,16,5,0',
				'6,16,5,0',
				'6,16,5,0'
			}
		}
	},
	sliding = {
		frames = {
			lpf = 1,
			sprites = {
				'82,0,15,16,0,0,1,0'
			},
			hitboxes = {
				'14,14,1,2'
			}
		}
	},
	hit = {
		frames = {
			lpf = 1,
			sprites = {
				'55,0,11,16,3,0,4,0'
			},
			hitboxes = {
				'6,16,5,0'
			}
		}
	},
	dead = {
		frames = {
			lpf = 1,
			sprites = {
				'66,0,16,8,0,8,0,8'
			},
			hitboxes = {
				'16,6,0,9'
			}
		}
	}
}

p:deserialize_frames()

p.states.falling = p.states.jumping

p:set_bitmasks()

p.dialogue = {
	[1] = 'yawn...',
	[2] = 'so bored...',
	[3] = 'hello???',
	[4] = "@!#*",
	[5] = "*#&*!!",
	[6] = "&!#*@!!!"
}

---initialize player
function p:init()
	for i=1, cfg.players, 1 do
		add(self, self:new({
			x = flr(rnd(112)),
			speed = 2,
			rise = 8,

			lives = 3,
			color = ceil(rnd(15)),

			cors = {},
			dcors = {}
		}))

		self[i]:spawn()
	end
end

---spawn player
function p:spawn()
	self.health = 100

	self:set_state('idle', true)
	self.sprite, self.hitbox, self.bitmask = self:get_frame()

	self.y = 0
	self.altitude = self:get_altitude()

	--reset dirty hits
	self.hits = nil
end

