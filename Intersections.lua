#!Lua-5.0.exe
-- Compute intersections of 2D geometrical objects.
-- I converted JavaScript code from Kevin Lindsey <http://www.KevLinDev.com>
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/08/26

-- Avoid to load this file twice
if Geom2D.Intersect ~= nil then return end

local Public, Private = {}, {}

Geom2D.Intersect = Public

function Public.CircleCircle(c1, c2)
	local result = {}

	-- Determine minimum and maximum radii where circles can intersect
	local r_max = c1.r + c2.r
	local r_min = math.abs(c1.r - c2.r)

	-- Determine actual distance between circle centers
	local c_dist = Geom2D.Point.ComputeDistance(c1.pc, c2.pc)

	if c_dist > r_max then
		result.text = "Outside"
	elseif c_dist < r_min then
		result.text = "Inside"
	else
		if c_dist == r_max then
			result.text = "Intersection (degenerate point)"
		else
			result.text = "Intersection (two distinct points)"
		end

		local a = c_dist/2 + (c1.r^2 - c2.r^2) / (2*c_dist)
		local h = math.sqrt(c1.r^2 - a*a)
		local p = Geom2D.Point.ComputeLerp(c1.pc, c2.pc, a/c_dist)
		local b = h / c_dist
		local bdx = b * (c2.pc.x - c1.pc.x)
		local bdy = b * (c2.pc.y - c1.pc.y)

		result.p1 =
		{
			x = p.x - bdy,
			y = p.y + bdx
		}
		result.p2 =
		{
			x = p.x + bdy,
			y = p.y - bdx
		}
	end

    return result
end
