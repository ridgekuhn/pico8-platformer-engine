---draw scaled ss sprite
--
--@param spr tbl a table of args
--	to pass to sspr()
function ssprs(spr)
	local _ENV = spr

	sspr(
		spr[1],
		spr[2],
		spr[3],
		spr[4],
		dx * cam.scale,
		dy * cam.scale,
		dw * cam.scale,
		dh * cam.scale
	)
end
