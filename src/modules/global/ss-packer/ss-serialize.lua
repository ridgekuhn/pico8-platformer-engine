---store spritesheet as a string
--of 4-byte hex words,
--using screen as buffer
--
--dependencies:
--	global/px9v7/px9v7-comp.lua
--
--extends:
--	none
--
--conflicts:
--	none
--
--@param sx num spritesheet sx
--
--@param sy num spritesheet sy
--
--@param sw num spritesheet sw
--
--@param sh num spritesheet sh
function ss_serialize(sx,sy,sw,sh)
  local clen = px9_comp(sx,sy,sw,sh,0x6000,sget)
  local str = ''
  for i = 0, clen, 4 do
    local bytes = tostr(peek4(0x6000 + i), true)
    bytes = sub(bytes, 3, 6) .. sub(bytes, 8, 11)
    str = str .. bytes
  end

	print('clen: ' .. clen)
  return str
end
