---store spritesheet as a string
--of 4-byte hex words,
--using screen as buffer
--
--dependencies:
--	global/px9v7-comp.lua
--
--extends:
--	none
--
--conflicts:
--	none
function ss_serialize()
  local clen = px9_comp(0,0,127,127,0x6000,sget)
  local str = ''
  for i = 0, clen, 4 do
    local bytes = tostr(peek4(0x6000 + i), true)
    bytes = sub(bytes, 3, 6) .. sub(bytes, 8, 11)
    str = str .. bytes
  end

  return str
end
