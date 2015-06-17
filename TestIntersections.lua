#!Lua-5.0.exe
-- Test intersections of 2D geometrical objects.
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/08/26

-- For debug
dofile[[C:\Dev\LuaPhiLhoSoft\_AsText_.lua]]

dofile[[2DGeometry.lua]]
dofile[[Intersections.lua]]
dofile[[2DGeomToSVG.lua]]

local c1 = { pc = { x=130, y=200 }, r=30 }
local c2 = { pc = { x=200, y=200 }, r=50 }

local r = Geom2D.Intersect.CircleCircle(c1, c2)
--print(AsText(r))
local f = SvgFormat.CreateSvg("@Intersection.svg", "Intersection of two circles")
f:write(SvgFormat.FormatText(10, 20, r.text, [[font-familly="Verdana" font-size="12" fill="red"]]))
f:write(SvgFormat.ConvertCircle(c1, [[stroke="none" fill="blue" fill-opacity="0.3"]]))
f:write(SvgFormat.ConvertCircle(c2, [[stroke="none" fill="green" fill-opacity="0.3"]]))
if r.p1 ~= nil then
	f:write(SvgFormat.ConvertPoint(r.p1, [[stroke="red" strokeWidth="0.1" fill="none"]]))
end
if r.p2 ~= nil then
	f:write(SvgFormat.ConvertPoint(r.p2, [[stroke="red" strokeWidth="0.1" fill="none"]]))
end
SvgFormat.CloseSvg(f)
