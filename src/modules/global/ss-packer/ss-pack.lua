---store spritesheet in a table
--4 byte hex words per key
--
--@param ulen num byte length
--	of uncompressed string
function ss_pack(ulen)
  local tbl = {}

  for i = 0, ulen - 1, 4 do
    add(tbl, peek4(i))
  end

  return tbl
end

