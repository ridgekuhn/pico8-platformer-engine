---actors class views

---draw the actor to the screen
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
		local flip_x = self.sprite[9] or self.xdir == -1
		--@todo is there ever a reason to flip_y?
		local flip_y = self.sprite[10] --or self.ydir == -1

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

		--debug
		rect(self.x + ox,
			self.y + oy,
			self.x + ox + self.sprite[3] - 1,
			self.y + oy + self.sprite[4] - 1,
			10
		)
	end
end

