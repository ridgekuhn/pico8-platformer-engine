---store spritesheet as a string
--of 4-byte hex words,
--using screen as buffer
--
--dependencies:
--	global/esc-binary-str.lua
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
--
--@return str
function ss_serialize(sx,sy,sw,sh)
	assert(sx and sy and sw and sh)

  local clen = px9_comp(sx,sy,sw,sh,0x6000,sget)
  local str = ''

  for i = 0, clen - 1 do
		local addr = 0x6000 + i
    str = str .. chr(peek(addr))
  end

	print('clen: ' .. clen)
  return esc_binary_str(str)
end
