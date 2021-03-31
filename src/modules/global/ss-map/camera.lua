---camera for ss-map module
--These are just examples for reference,
--since we will likely need
--other cam properties
--and additional operations
--in camera_udpate()
--to track player movement, etc
--
--dependencies:
--	none
--
--extends:
--	none
--
--conflicts:
--	global/camera.lua
function camera_init()
	cam = {
		x = 0,
		y = 0,
		scale = 1
		--l = 128 / cam.scale,
	}
end

function camera_update()
	--camera length (width and/or height)
	cam.l = 128 / cam.scale
	--lock camera to bottom
	cam.y = 256 - cam.l
end
