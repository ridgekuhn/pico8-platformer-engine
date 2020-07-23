---player 1 model

--describe default player properties
p.defaulthitbox = {w=6,h=16,ox=5,oy=0}

p.states= {
	idle = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=0,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	jumping = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=64,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	running = {
		frames = {
			lpf = 5,
			rev = true,
			sprites = {
				{sx=16,sy=0,sw=16,sh=16},
				{sx=32,sy=0,sw=16,sh=16},
				{sx=48,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox,
				p.defaulthitbox,
				p.defaulthitbox
			}
		}
	},
	sliding = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=112,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				{w=14,h=14,ox=1,oy=2}
			}
		}
	},
	hit = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=80,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	dead = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=96,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				{w=16,h=5,ox=0,oy=9}
			}
		}
	}
}

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

