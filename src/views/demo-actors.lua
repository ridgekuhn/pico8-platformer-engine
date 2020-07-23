---demo actors views

---draw smoke
function actors:draw_smoke(ox, oy, r)
	--smoke
	if(self.sclock % 5 == 0) then
		add(self.dcors, cocreate(function()
			local ox = ox or 0
			local oy = oy or 0
			local r = r or 1
			local x = self.x + ox
			local y = self.y + oy

			for i=1, 20 do
				if(i % 2) then
					y -= .3
					r += .1
					circfill(x, y, r, 7)
				end
				yield()
			end
		end))
	end
end

