---player 1 model

--describe default player properties

p.states= {
	idle = {
		frames = {
			lpf = 1,
			sprites = {
				{
					--body
					'0,7,8,9,5,7,3,7',
					--head
					'0,0,6,7,5,0,5,0'
				}
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
				{
					--full
					'40,0,15,16,0,0,1,0'
				}
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
				{
					--body
					'8,0,12,9,2,7,2,7',
					--head
					'0,0,6,7,5,1,5,1'
				},
				{
					--body
					'19,0,9,9,3,7,4,7',
					--head
					'0,0,6,7,5,0,5,0'
				},
				{
					--body
					'28,0,12,9,2,7,2,7',
					--head
					'0,0,6,7,5,1,5,1'
				}
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
				{
					'82,0,15,16,0,0,1,0'
				}
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
				{
					'55,0,11,16,3,0,4,0'
				}
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
				{
					'66,0,16,8,0,8,0,8'
				}
			},
			hitboxes = {
				'16,6,0,9'
			}
		}
	}
}

p:deserialize_frames()

p.states.falling = p.states.jumping

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
	self.sprite, self.hitbox = self:get_frame()

	self.y = 0
	self.altitude = self:get_altitude()

	--reset dirty hits
	self.hits = nil
end

