---draw scaled, palette-cycled ss sprite
--
--@param spr tbl a table of args
--	to pass to sspr()
--
--@param [cycle] bool call cycle_palette()
--	helpful for preventing multiple calls
--	in a loop like in ss_map_draw()
--
--@pram [clock] num animation clock
function ssprs(spr, cycle, clock)
	if (spr.pal_swaps) then
		set_palette(spr.pal_swaps)
	end

	sspr(
		spr.sx,
		spr.sy,
		spr.sw,
		spr.sh,
		spr.dx * cam.scale,
		spr.dy * cam.scale,
		spr.dw * cam.scale,
		spr.dh * cam.scale
	)

	if (
		cycle
		and spr.pal_cycle
		and clock % spr.pal_cycle == 0
	) then
		spr.pal_swaps = cycle_palette(spr.pal_swaps)
	end

	pal()
	palt()
end
