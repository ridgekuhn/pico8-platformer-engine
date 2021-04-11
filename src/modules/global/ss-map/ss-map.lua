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

ss_map = actors:new({
	--[1] a map layer
	{
		--each map cel corresponds to
		--an index of ss_data
		map = {1,2},
		----first map cel to be drawn
		--cur_map_0index = this.scrolledx \ 128
		--cur_map_index = this.cur_map_0index + 1

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

		sprites = {
			{
				--args to pass to sspr()
				--sx
				[1] = 0,
				--sy
				[2] = 0,
				--sw
				[3] = 128,
				--sh
				[4] = 128,

				--the following props are
				--calculated in update and must
				--multiplied by cam.scale
				--before drawing!
				--dx = ((this.cur_map_index * 128) - this.scrolledx),
				--dy = (this.y - cam.y),
				--dw = this.sw,
				--dh = this.sh,
				--flip_x = nil,
				--flip_y = nil

				--args to pass to
				--set_palette() and cycle_palette()
				pal_swaps = {
					{0,0, true}, {1,1}, {2, 2}, {3, 3}
				}
				--framerate of palette cycle in
				--update60 loops per frame
				pal_cycle = 60,
			}
		}
	},
	...etc
})
--]]

ss_map = actors:new()

function ss_map:new(layer)
	setmetatable(layer, self)
	self.__index = self

	return layer
end

function ss_map:update()
	for l in all(self) do
		--subtract l.x last so l.x remains
		--the initial map position of l
		l.scrolledx = (cam.x * l.scroll) - l.x
		--get 0-index of current map cel
		l.cur_map_0index = l.scrolledx \ 128

		--default to 1 if the first x pos
		--is out of range, so we can
		--calculate props for
		--the first drawn map cel
		if (l.scrolledx < 0) then
			l.cur_map_index = 1
		--wrap back around map if l.infinite
		elseif(l.infinite) then
			l.cur_map_index = (l.cur_map_0index % #l.map) + 1
		--everyone's favorite lua feature
		else
			l.cur_map_index = l.cur_map_0index + 1
		end

		l:cycle_palette()
		l.sclock += 1
	end
end

function ss_map:draw()
	for l in all(self) do
		--@todo this is only shoved into
		--l.sprites to conform with use in
		--actors:cycle_palette()
		--and actors:ssprs()
		--would we ever need to
		--loop through multiple sprites?
		local spr = l.sprites[1]

		--only proceed if map cel is in-range
		--(ignore l.cur_map_index > #l.map)
		if (l.map[l.cur_map_index]) then
			--draw up to 3 map cels on x-axis,
			--assuming cels are 128px wide
			--and cam.s >= .5 (256 scaled px wide)
			for i = 0, 2 do
				--save l.dx so we can modify it
				--and use it for drawing
				--l.cur_map_index + [1,2]
				--when we pass it to ssprs()
				local dx = spr.dx

				--prevent cur_map_0index < 0
				--from canceling out l.scrolledx
				--if l.scrolledx is also < 0
				spr.dx = (l.cur_map_0index >= 0 and l.cur_map_0index * spr[3] or 0) - l.scrolledx
				--add (i * spr[3]) to spr.dx to get
				--next map cel's dx,
				--and massage heavily to prevent
				--scaling errors like motion judder
				spr.dx = ceil((flr(spr.dx * cam.scale) + (i * flr(spr[3] * cam.scale))) / cam.scale)

				spr.dy = l.y - cam.y

				--if l.infinite, then
				--wrap back around to
				--draw first map cel
				local cur_map_index = l.infinite and ((l.cur_map_index + i - 1) % #l.map) + 1 or l.cur_map_index + i

				if (
					--if map cel data exists
					l.map[cur_map_index]
					--if in-camera
					and spr.dx <= cam.l
					and spr.dx + spr[3] >= 0
					and spr.dy <= cam.l
					and spr.dy + spr[4] >= 0
				) then
					poke4(0, unpack(ss_data[l.map[cur_map_index]]))
					actors:ssprs(spr)
				end

				--reset l.dx
				spr.dx = dx
			end
		end
	end
end
