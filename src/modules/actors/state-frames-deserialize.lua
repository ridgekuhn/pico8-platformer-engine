---deserialize actor state frames
--
--dependencies:
--	actors/state-frames
--	or
--	actors/collision-per-px
--
--extends:
--	actors/state-frames
--	actors/collision-per-px
--
--conflicts:
--	none

--******
--models
--******
---deserialize frame strings
--
--to save on tokens, you can
--serialize sprite and hitbox
--states table frame data as
--a comma-delimited string,
--and then call this function
--to convert the string
--back to a table.
--
--@usage
--	some_actors = actors:new({
--		states = {
--			some_state =	{
--				frames = {
--					lpf = 1,
--					sprites = {
--						'0,0,8,8,0,0,0,0',
--						'8,0,8,8,0,0,0,0',
--						'16,0,8,8,0,0,0,0'
--					},
--					hitboxes = {
--						'8,8,0,0',
--						'8,8,0,0',
--						'8,8,0,0'
--					}
--				}
--			},
--			--etc
--		}
--	})
--
--	some_actors:deserialize_frames()
function actors:deserialize_frames()
	for k, state in pairs(self.states) do
		for table, strings in pairs(state.frames) do
			if(table == 'sprites' or
				table == 'hitboxes'
			) then
				for i=1, #strings do
					if(type(strings[i] == 'string')) then
						strings[i] = split(strings[i], ",")
					end
				end
			end
		end
	end
end

