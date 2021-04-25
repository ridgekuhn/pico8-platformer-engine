---save compressed binary ss data to cart
--also saves metadata file required
--for decompression
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
--@param ss_data tbl compressed ss data
--
--@param pack bool immediately call
--	ss_pack_persistent() in
--	metadata declaration if true
--
--@param datafile str path to cartridge
--	to store compressed ss data in
--
--@param metafile str path to metadata file
function ss_persist(ss_data, pack, datafile, metafile)
	local	datafile = datafile or './gfx.p8'
	local metafile = metafile or './ss_data.p8'

	--begin logging metadata
	local openingstr,closingstr = '',''
	if pack then
		openingstr,closingstr = 'ss_data = ss_pack_persistent({', '})'
	else
		openingstr,closingstr = 'ss_data = {', '}'
	end

	printh(openingstr, metafile, true)

	--start address of each compressed ss
	local addr = 0

	for ss in all(ss_data) do
		printh('\t{', metafile)

		--copy string to ss mem
		for i=1, #ss[2] do
			local cur_addr = addr + (i-1)

			--only overwrite ss/map storage
			assert(cur_addr < 0x3000)

			poke(cur_addr, ord(ss[2], i))
		end

		--write to gfx cart
		cstore(addr, addr, #ss[2], datafile)

		--log metadta
		printh('\t\t' .. '\'' .. ss[1] .. '\'' .. ',', metafile)
		printh("\t\t" .. '\'' .. addr .. ',' .. #ss[2] .. '\'', metafile)

		printh("\t},", metafile)

		addr += #ss[2]
	end

	printh(closingstr, metafile)
end
