---draw palette-cycled sprite
--
--@param spr tbl a table of args
--	to pass to sspr()
--
--@param [cycle] bool call cycle_palette()
--
--@pram [clock] num animation clock
function ssprc(spr, cycle, clock)
	if (spr.pal_swaps) then
		set_palette(spr.pal_swaps)
	end

	sspr(
		spr.sx,
		spr.sy,
		spr.sw,
		spr.sh,
		spr.dx,
		spr.dy,
		spr.dw,
		spr.dh
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
