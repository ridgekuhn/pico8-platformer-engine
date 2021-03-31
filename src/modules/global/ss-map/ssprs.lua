---draw scaled ss sprite
--
--@param spr tbl a table of args
--	to pass to sspr()
function ssprs(spr)
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
end
