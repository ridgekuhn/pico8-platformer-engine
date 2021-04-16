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
--  dw = 8,
--
--  --optional, draw height
--  dh = 8,
--
--  --optional, flip_x
--  flip_x = nil,
--
--  --optional, flip_y
--  flip_y = nil
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
	local _ENV = self

	if type(sprite) == 'number' then
		local flip_x = xdir == -1
		--@todo is there ever a reason to flip_y?
		--local flip_y = self.ydir == -1

		spr(sprite,
				x,
				y,
				1,
				1,
				flip_x
				--, flip_y
		)
	elseif type(sprite == 'table') then
		local ox = xdir == 1 and sprite[5] or sprite[7]
		local oy = ydir == 1 and sprite[6] or sprite[8]
		local dw = sprite.dw or sprite[3]
		local dh = sprite.dh or sprite[4]
		local flip_x = sprite.flip_x or xdir == -1
		--@todo is there ever a reason to flip_y?
		local flip_y = sprite.flip_y --or ydir == -1

		sspr(sprite[1],
				 sprite[2],
				 sprite[3],
				 sprite[4],
				 x + ox,
				 y + oy,
				 dw,
				 dh,
				 flip_x,
				 flip_y
		)
	end
end

