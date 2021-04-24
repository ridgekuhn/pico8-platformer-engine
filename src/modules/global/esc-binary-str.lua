---escape binary string
--by zep
--@see https://www.lexaloffle.com/bbs/?tid=38692
--
--@param s str
function esc_binary_str(s)
 local out=""
 for i=1,#s do
  local c  = sub(s,i,i)
  local nc = ord(s,i+1)
  local pr = (nc and nc>=48 and nc<=57) and "00" or ""
  local v=c
  if(c=="\"") v="\\\""
  if(c=="\\") v="\\\\"
  if(ord(c)==0) v="\\"..pr.."0"
  if(ord(c)==10) v="\\n"
  if(ord(c)==13) v="\\r"
  out..= v
 end
 return out
end
