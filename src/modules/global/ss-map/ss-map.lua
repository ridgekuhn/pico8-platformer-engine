---draw a map from multiple spritesheets
--
--dependencies:
--	global/ss-packer/ss-deserialize.lua
--	global/palette-cycle/palette-cycle.lua
--	./ssprs.lua or global/palette-cycle/ssprs.lua
--	global/ss-map/camera.lua
--
--extends:
--	none
--
--conflicts:
--	global/camera.lua

---initialize spritesheet map
--@usage
--[[
ss_data = {
	[1] = {
		--length of *un*compressed string
		--eg, (sw * sh) / 2
		[1] = 8192,
		--compressed px9 string
		[2] = 'yourCompressedPX9string'
	},
	...etc
}

ss_packer_init(ss_data)

ss_layers = {
	--[1] a map layer
	{
		--each map cel corresponds to
		--an index of ss_data
		--serialized as string
		map = '1,2',
		----first map cel to be drawn
		--cur_map_index = (this.scrolledx \ 128) + 1,

		--repeat map cels forever
		infinite = true,

		--x is initial position on map,
		--regardless of parallax scrolling
		x = 0,
		y = 80,

		--parallax scroll rate
		scroll = .5,
		----parallax scrolled position
		----relative to cam.x,
		--scrolledx = (cam.x * this.scroll) - this.x,

		----args to pass to sspr()
		--sx = 0,
		--sy = 0,
		--sw = 128,
		--sh = (#ss_data[this.cur_map_index + 1] / 16),
		----the following props must be
		----multiplied by cam.scale
		----before drawing!
		--dx = ((this.cur_map_index * 128) - this.scrolledx),
		--dy = (this.y - cam.y),
		--dw = 128,
		--dh = this.sh,

		----args to pass to
		----set_palette() and cycle_palette()
		----double serialized as string
		--pal_swaps = '0,0;1,1;2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9;10,10;11,11;12,12;13,13;14,14;15,15',
		----@tokenhunt will i ever actually use this?
		----transparent color for palette
		--pal_t = 0,
		----framerate of palette cycle in
		----update60 loops per frame
		--pal_cycle = 60,
	},
	...etc
}

	ss_map_init(ss_layers)
--]]
function ss_map_init(ss_layers)
	ss_layers.clock = 0

	for l in all(ss_layers) do
		--save tokens in ss_layers,
		--remove and define manually
		--in ss_layers if needed
		l.sx = 0
		l.sy = 0
		l.sw = 128
		l.dw = 128

		--deserialize layer map
		l.map = split(l.map)

		--deserialize layer palette
		if (l.pal_swaps) then
			l.pal_swaps = split(l.pal_swaps,';')

			for k,v in pairs(l.pal_swaps) do
				l.pal_swaps[k] = split(v)
			end
		end
	end
end

function ss_map_update()
	for l in all(ss_layers) do
		--subtract l.x last so l.x remains
		--the initial map position of l
		l.scrolledx = (cam.x * l.scroll) - l.x
		--get 0-index of current map cel
		local cur_map_0index = l.scrolledx \ 128

		--default to 1 if the first x pos
		--is out of range, so we can
		--calculate props for
		--the first drawn map cel
		if (l.scrolledx < 0) then
			l.cur_map_index = 1
		--wrap back around map if l.infinite
		elseif(l.infinite) then
			l.cur_map_index = (cur_map_0index % #l.map) + 1
		--everyone's favorite lua feature
		else
			l.cur_map_index = cur_map_0index + 1
		end

		--only calculate props
		--if map cel is in-range
		--(ignore l.cur_map_index > #l.map)
		if (l.map[l.cur_map_index]) then
			--@todo should ss_data just have x,y dimension props?
			--calculate height of cel,
			--by counting number
			--of 4-byte values and
			--assuming width is always 128 (64 bytes)
			l.sh = (#ss_data[l.map[l.cur_map_index]] / 16)
			--prevent cur_map_0index < 0
			--from canceling out l.scrolledx
			--if l.scrolledx is also < 0
			l.dx = (cur_map_0index >= 0 and cur_map_0index * l.dw or 0) - l.scrolledx
			l.dy = l.y - cam.y
			--@todo should ss_data just have x,y dimension props?
			l.dh = l.sh
		end
	end

	ss_layers.clock += 1
end

function ss_map_draw()
	for l in all(ss_layers) do
		--draw up to 3 map cels on x-axis,
		--assuming cels are 128px wide
		--and cam.s >= .5 (256 scaled px wide)
		for i = 0, 2 do
			--save l.dx so we can modify it
			--and use it for drawing
			--l.cur_map_index + [1,2]
			local dx = l.dx
			--add (i * l.dw) to l.dx to get
			--next map cel's dx,
			--and massage heavily to prevent
			--scaling errors like motion judder
			l.dx = ceil((flr(l.dx * cam.scale) + (i * flr(l.dw * cam.scale))) / cam.scale)

			--if l.infinite, then
			--wrap back around to first map cel
			local cur_map_index = l.infinite and ((l.cur_map_index + i - 1) % #l.map) + 1 or l.cur_map_index + i

			if (
				--if map cel data exists
				l.map[cur_map_index]
				--if in-camera
				and l.dx <= cam.l
				and l.dx + l.dw >= 0
				and l.dy <= cam.l
				and l.dy + l.dh >= 0
			) then
				poke4(0, unpack(ss_data[l.map[cur_map_index]]))
				ssprs(l, i == 0, ss_layers.clock)
			end

			--reset l.dx
			l.dx = dx
		end
	end
end
