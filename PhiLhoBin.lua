#!Lua-5.0.exe
-- Do this and that.
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/10/05

strToEncode = "PhiLho PhiLho@GMX.net http://Phi.Lho.free.fr/"

local ca, cA = string.byte('a'), string.byte('A')
local toBin =
{
	"00000",
	"00001",
	"00010",
	"00011",
	"00100",
	"00101",
	"00110",
	"00111",
	"01000",
	"01001",
	"01010",
	"01011",
	"01100",
	"01101",
	"01110",
	"01111",
	"10000",
	"10001",
	"10010",
	"10011",
	"10100",
	"10101",
	"10110",
	"10111",
	"11000",
	"11001",
	"11010",
	"11011",
	"11100",
	"11101",
	"11110",
	"11111",
}

function Encode(c)
	local v = string.byte(c)
	local b
	if c >= 'A' and c <= 'Z' then
		b = '0' .. toBin[v - cA + 1]
	elseif c >= 'a' and c <= 'z' then
		b = '1' .. toBin[v - ca + 1]
	else -- number or punctuation
		v = 27 + math.mod(v, 6) -- 32-26
		if c >= '0' and c <= '9' then
			b = '0' .. toBin[v]
		else
			b = '1' .. toBin[v]
		end
	end
	return b .. ' '
end

code = string.gsub(strToEncode, "(.)", Encode)
print(code)

--[[ Result:
001111 100111 101000 001011 100111
101110 111100 001111 100111 101000
001011 100111 101110 111110 000110
001100 010111 111110 101101 100100
110011 111100 100111 110011 110011
101111 111110 111111 111111 001111
100111 101000 111110 001011 100111
101110 111110 100101 110001 100100
100100 111110 100101 110001 111111
]]
