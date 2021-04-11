---draw scaled ss sprite
--
--@param spr tbl a table of args
--	to pass to sspr()
function ssprs(spr)
	sspr(
		spr[1],
		spr[2],
		spr[3],
		spr[4],
		spr.dx * cam.scale,
		spr.dy * cam.scale,
		spr.dw * cam.scale,
		spr.dh * cam.scale
	)
end
