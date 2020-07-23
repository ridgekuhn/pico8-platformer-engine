---players class controllers

---get player input
function p:get_input()
	for i=0, 5 do
		self['b' .. tostr(i)] = btn(i, self.index - 1)
	end
end
--
