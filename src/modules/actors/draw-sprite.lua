---actor draw sprites
--
--provides a method to render
--a simple sprite using spr()
--or a table of spritesheet data
--using sspr()
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
---sprite property
--
--define manually as needed.
--@see actors:draw_sprite()
--
--some_actors.sprite = 0,
--
--or--
--
--some_actors.sprite = {
--	--spritesheet x position
--  [1] = 0,
--
--	--spritesheet y position
--  [2] = 0,
--
--  --sprite width
--  [3] = 8,
--
--  --sprite height
--  [4] = 8,
--
--  --x-offset from self.x
--  [5] = 0,
--
--  --y-offset from self.y
--  [6] = 0,
--
--  --x-offset from self.x
--  --when sprite is
--  --flipped horizontally
--  [7] = 0,
--
--  --y-offset from self.y
--  --when sprite is
--  --flipped vertically
--  [8] = 0,
--
--  --optional, draw width
--  [9] = 8,
--
--  --optional, draw height
--  [10] = 8,
--
--  --optional, flip_x
--  [11] = nil,
--
--  --optional, flip_y
--  [12] = nil
--},

--*****
--views
--*****
---draw the actor to the screen
--
--gets the actor.sprite
--property and draws the sprite
--using spr() if it finds a
--number, or sspr() if it finds
--a table.
--
--this method will automatically
--flip_x if self.xdir == -1
--
--the spr() method is limited,
--and assumes you simply
--want to draw an 8x8 sprite
--with no offset from
--self.x/self.y
function actors:draw_sprite()
	if(type(self.sprite) == 'number') then
		local flip_x = self.xdir == -1
		--@todo is there ever a reason to flip_y?
		--local flip_y = self.ydir == -1

		spr(self.sprite,
				self.x,
				self.y,
				1,
				1,
				flip_x
				--, flip_y
		)
	elseif(type(self.sprite == 'table')) then
		local ox = self.xdir == 1 and self.sprite[5] or self.sprite[7]
		local oy = self.ydir == 1 and self.sprite[6] or self.sprite[8]
		local dw = self.sprite[9] or self.sprite[3]
		local dh = self.sprite[10] or self.sprite[4]
		local flip_x = self.sprite[11] or self.xdir == -1
		--@todo is there ever a reason to flip_y?
		local flip_y = self.sprite[12] --or self.ydir == -1

		sspr(self.sprite[1],
				 self.sprite[2],
				 self.sprite[3],
				 self.sprite[4],
				 self.x + ox,
				 self.y + oy,
				 dw,
				 dh,
				 flip_x,
				 flip_y
		)
	end
end

