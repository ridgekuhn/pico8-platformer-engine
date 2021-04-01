---local fill pattern
--by makke & felice
--https://www.lexaloffle.com/bbs/?tid=30518
_fillp_xmask_lo={[0]=0xffff,0x7777,0x3333,0x1111}
_fillp_xmask_hi={[0]=0x0000,0x8888,0xcccc,0xeeee}
_fillp_original=fillp

function fillp(p,x,y)
	if y then
		x=x&3

		local p16=flr(p)
		local p32=p16+(p16>>>16) >>< (y&3)*4+x

		p+=flr((p32&_fillp_xmask_lo[x]) + (p32<<>4&_fillp_xmask_hi[x])) - p16
	end

	return _fillp_original(p)
end
