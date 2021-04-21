---set palette swaps
--@usage
--	pal_swaps = {
--		{
--			{0,1,0}, {1,2}, {2,3,1}
--		},
--		...etc
--	}
--
--	set_palette(pal_swaps)
--	pset(0, 0, 0) --draws opaque dark blue
--	pset(0, 0, 1) --draws opaque dark purple
--	pset(0, 0, 2) --draws transparent dark green
--
--@param pal_swaps tbl palette swap data
--
--@param [p] num palette to modify
function set_palette(pal_swaps, p)
	for swap in all(pal_swaps) do
		pal(swap[1], swap[2], p)

		if swap[3] == 0 then
			palt(swap[1], false)
		elseif swap[3] == 1 then
			palt(swap[1], true)
		end
	end
end

---cycle palette
--shifts palette swaps table indexes down
--to next value
--
--@usage
--	pal_swaps = {
--		{
--			{0,1,0}, {2,3,1}
--		},
--		...etc
--	}
--
--	pal_swaps = cycle_palette(pal_swaps)
--
--expected:
--	pal_swaps = {
--		{
--			{0,3,1}, {2,1,0}
--		},
--		...etc
--	}
--
--@param pal_swaps tbl palette swap data
--
--@returns tbl cycled palette swaps
function cycle_palette(pal_swaps)
	local new_p = {
		cycle = pal_swaps.cycle
	}

	--copy last value to first index
	new_p[1] = {pal_swaps[1][1], pal_swaps[#pal_swaps][2], pal_swaps[#pal_swaps][3]}

	--shift remaining values to next index
	for i=2, #pal_swaps do
		new_p[i] = {pal_swaps[i][1], pal_swaps[i-1][2], pal_swaps[i-1][3]}
	end

	return new_p
end

---cycle actor palette
--cycles palettes for actor sprites
function actors:cycle_palette()
	for sprite in all(self.sprites) do
		if sprite.pal_swaps then
			for k,v in pairs(sprite.pal_swaps) do
				if
					v. cycle
					and self.sclock % v.cycle == 0
				then
					sprite.pal_swaps[k] = cycle_palette(v)
				end
			end
		end
	end
end
