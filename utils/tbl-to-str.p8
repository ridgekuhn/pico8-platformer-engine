pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
#include ../src/modules/global/table-string/stringify.lua

--#include myModel.lua

for data in all ({
	--{table, tablename, sub-class actors (boolean), filename}
}) do
	local table = data[1]
	local tablename = data[2]
	local actors = data[3]
	local filename = data[4]

	local str = serialize_table(table)

	local openingstr,closingstr = '',''

	if actors then
		openingstr = tablename .. ' = actors:new(table_from_string('
		closingstr = '))'
	else
		openingstr = tablename .. ' = table_from_string('
		closingstr = ')'
	end

	printh(openingstr .. str .. closingstr, filename, true)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000