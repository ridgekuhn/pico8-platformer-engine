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
--@param str str px9-compressed string
--
--@param [addr] num memory address
--	to use as decompression buffer
function ss_deserialize(str, addr)
	local addr = addr or 0x6000

  for i = 1, #str, 8 do
    local num = '0x' .. sub(str, i, i + 3) .. '.' .. sub(str, i + 4, i + 7)
    poke4(addr + ((i - 1) / 2), num)
  end

  px9_decomp(0,0,0x6000,sget, sset)
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
--			--length of *un*compressed string
--			--eg, (sw * sh) / 2
--			[1] = 8192,
--			--compressed px9 string
--			[2] = 'yourCompressedPX9string'
--		},
--		...
--	}
--
--	poke4(0, unpack(ss_data[1]))
--
--@param ss_data tbl compressed ss data
function ss_packer_init(ss_data)
	for k,ss in pairs(ss_data) do
		ss_deserialize(ss[2])
		ss_data[k] = ss_pack(ss[1])
	end
end
