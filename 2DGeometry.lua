#!Lua-5.0.exe
-- Compute operations on 2D geometrical objects.
-- I converted JavaScript code and ideas from Kevin Lindsey <http://www.KevLinDev.com>
-- but I dropped the OOP because I didn't felt a strong need for that, here. :-)
-- I may change my mind, thought.
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/08/26

-- Avoid to load this file twice
if Geom2D ~= nil then return end

local Public, Private = {}, {}

Geom2D = Public

---- Examples of geometrical objects definitions
-- A point is not a SVG shape, and is a fundamental primitive for geometry,
-- so we don't give it a "kind" to save some processing.
-- A table with just x and y fields is a point.
local point = { x=100, y=100 }
-- Base SVG shapes
local line = { kind="line", p1 = { x=100, y=100 }, p2 = { x=150, y=150 } }
local circle = { kind="circle", pc = { x=100, y=100 }, r=50 }
local ellipse = { kind="ellipse", pc = { x=100, y=100 }, rx=30, ry=70 }
local rect = { kind="rect", ptl = { x=100, y=100 }, width=70, height=30, rx=10, ry=5 }
local polyline = { kind="polyline", { x=10, y=10 }, { x=20, y=20 }, { x=30, y=10 } }
local polygon = { kind="polygon", { x=10, y=10 }, { x=20, y=20 }, { x=30, y=10 } }
-- SVG Path
local path = { kind="path", d = {} }


--### 2D Point Utilities ###--

Public.Point = {}

-- Give the distance between two points
function Public.Point.ComputeDistance(p1, p2)
	local dx = p1.x - p2.x
	local dy = p1.y - p2.y
	return math.sqrt(dx^2 + dy^2)
end

-- Lerp = Linear Interpolation
-- Ie. compute a new point between the two given.
-- d is between 0.0 and 1.0: for small d, the resulting point
-- is near p1, for d nearing 1, it is near p2.
function Public.Point.ComputeLerp(p1, p2, d)
	local pr = {}
	pr.x = p1.x*(1 - d) + p2.x*d
	pr.y = p1.y*(1 - d) + p2.y*d
	return pr
end
