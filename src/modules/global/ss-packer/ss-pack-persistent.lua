---decompress and pack spritesheets
--packs uncompressed ss data already
--stored in cart's spritesheet/map
--to a table
--
--@usage
--	ss_data = {
--		[1] = {
--			--spritesheet dimensions
--			--as a string, 'w,h'
--			[1] = '128,128',
--
--			--location of compressed data
--			--and length of data, as a string
--			[2] = '0,1953'
--		},
--		...etc
--	}
--
--@param ss_data tbl compressed ss metadata
--
--@return tbl nested table of
--	spritesheet data in 4-byte rows
function ss_pack_persistent(ss_data)
	local packed = {}

	for k,ss in pairs(ss_data) do
		local dimensions = split(ss[1])
		local addr = split(ss[2])

		--copy compressed string
		--so we can write to spritesheet mem
		memcpy(0x6000, addr[1], addr[2])
		px9_decomp(0,0,0x6000,sget,sset)

		--pack spritesheet bites into table
		packed[k] = ss_pack(ceil((dimensions[1] * dimensions[2]) / 2))

		--store sw,sh at index 0
		packed[k][0] = dimensions

		--restore spritesheet/map memory
		reload(0,0,0x3000)
	end

	return packed
end
