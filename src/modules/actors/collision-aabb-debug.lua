---debug functions for actors/collision-aabb

function actors:draw_hitbox()
	rect(self:get_xmin(), self:get_ymin(), self:get_xmax(), self:get_ymax(), 11)
end

function actors:draw_coll_aabb(actor)
	local hit, xmin, ymin, xmax, ymax = self:get_coll_aabb(actor)

	if(hit) then
		rect(xmin, ymin, xmax, ymax, 9)
	end
end

