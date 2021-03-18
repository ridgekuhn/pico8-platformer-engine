---decompress spritesheet and store in table
--
--dependencies:
--	global/px9v7-decomp.lua
--
--extends:
--	none
--
--conflicts:
--	none

---deserialize string to spritesheet
--using screen as buffer
function ss_deserialize(str)
  for i = 1, #str, 8 do
    local num = '0x' .. sub(str, i, i + 3) .. '.' .. sub(str, i + 4, i + 7)
    poke4(0x6000 + ((i - 1) / 2), num)
  end

  px9_decomp(0,0,0x6000,sget, sset)
end

---store spritesheet in a table
--4 byte hex words per key
function ss_pack()
  local tbl = {}

  for i = 0, 8191, 4 do
    add(tbl, peek4(i))
  end

  return tbl
end

