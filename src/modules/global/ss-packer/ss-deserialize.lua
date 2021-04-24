---decompress spritesheet and store in table
--
--dependencies:
--	global/px9v7/px9v7-decomp.lua
--
--extends:
--	none
--
--conflicts:
--	none

---deserialize string to spritesheet
--using screen as buffer
--@param str str px9-compressed string
function ss_deserialize(str)
  for i = 1, #str do
		local addr = 0x6000 + (i - 1)

		poke(addr, ord(str, i))
  end

  px9_decomp(0,0,0x6000,sget,sset)
end

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

---decrompress and pack spritesheets
--packs uncompressed ss data into a table
--of 4-byte values
--
--@usage
--	ss_data = {
--		[1] = {
--			--spritesheet dimensions
--			--as a string, 'w,h'
--			[1] = '128,128',
--			--compressed px9 string
--			[2] = 'binarystring'
--		},
--		...
--	}
--
--	poke4(0, unpack(ss_data[1]))
--
--@param ss_data tbl compressed ss data
function ss_packer_init(ss_data)
	local packed = {}

	for k,ss in pairs(ss_data) do
		local dimensions = split(ss[1])

		--swap spritesheet
		ss_deserialize(ss[2])

		--pack spritesheet bytes into table
		packed[k] = ss_pack(ceil((dimensions[1] * dimensions[2]) / 2))

		--store sw,sh at index 0
		packed[k][0] = dimensions
	end

	return packed
end
