---actors class views

function actors:draw_sprite()
	if(type(self.sprite) == 'number') then
		local flip_x = self.xdir == -1

		spr(self.sprite,
				self.x,
				self.y,
				1,
				1,
				flip_x,
				false
		)
	elseif(type(self.sprite == 'table')) then
		local flip_x = self.sprite.flip_x or self.xdir == -1
		local flip_y = self.sprite.flip_y
		local dw = self.sprite.dw or self.sprite.sw
		local dh = self.sprite.dh or self.sprite.sh

		sspr(self.sprite.sx,
				 self.sprite.sy,
				 self.sprite.sw,
				 self.sprite.sh,
				 self.x,
				 self.y,
				 dw,
				 dh,
				 flip_x,
				 flip_y
		)
	end
end

