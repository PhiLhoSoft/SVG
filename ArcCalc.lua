#!Lua-5.0.exe
-- Convert SVG arcs (radii, start point, end point, some parameters)
-- to center based arcs (center point, radii, angles, etc.).
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/09/21 -- Finished ConvertToCenterArc and debug
-- v. 0.1 -- 2004/08/22 -- Creation

--dofile[[_AsText_.lua]]

local svgArc =
{
	-- Coordinates of the beginning of arc
	x1 = 120, y1 = 120,
	-- Radii of the ellipse (semi-major and semi-minor axes)
	rx = 100, ry = 50,
	-- angle from the x-axis of the current coordinate system to the x-axis of the ellipse
	x_axis_rotation = 0,	-- phi
	-- 0 if arc is spanning less than or equal to 180 degrees
	-- 1 if arc is spanning greater than 180 degrees
	large_arc_flag = 0,
	-- 0 if the line joining center to arc sweeps through decreasing angles
	-- 1 if it sweeps through increasing angles
	sweep_flag = 0,
	-- Coordinates of the end of arc
	x2 = 200, y2 = 200
}
-- <path d="M 10,10 A 40,40 0 0,0 60,10"/>
-- A | a   elliptical arc (rx,ry x-axis-rotation large-arc-flag,sweep-flag x,y)

local centerArc =
{
	-- Coordinates of the center
	cx = 150, cy = 200,
	-- Radii of the ellipse (semi-major and semi-minor axes)
	rx = 50, ry = 100,
	-- angle from the x-axis of the current coordinate system to the x-axis of the ellipse
	x_axis_rotation = 10,	-- phi
	-- beginning angle of arc in degrees
	theta1 = -30,
	-- arc extend in degrees
	delta_theta = -90
}

-- Following steps are suggested in the implementation notes

-- Convert from center arc (ca) to SVG arc (sa)
function ConvertToSvgArc(ca)
	local sa = {}
	local phi = math.rad(ca.x_axis_rotation)
	local theta1 = math.rad(ca.theta1)
	local theta2 = theta1 + math.rad(ca.delta_theta)

	local function ConvertX(th)
		return ca.cx +
			ca.rx * math.cos(th) * math.cos(phi) -
			ca.ry * math.sin(th) * math.sin(phi)
	end

	local function ConvertY(th)
		return ca.cy +
			ca.rx * math.cos(th) * math.sin(phi) +
			ca.ry * math.sin(th) * math.cos(phi)
	end

	sa.x1 = ConvertX(theta1)
	sa.y1 = ConvertY(theta1)
	sa.x2 = ConvertX(theta2)
	sa.y2 = ConvertY(theta2)
	if math.abs(ca.delta_theta) > 180 then
		sa.large_arc_flag = 1
	else
		sa.large_arc_flag = 0
	end
	if ca.delta_theta > 0 then
		sa.sweep_flag = 1
	else
		sa.sweep_flag = 0
	end
	sa.rx = ca.rx
	sa.ry = ca.ry
	sa.x_axis_rotation = ca.x_axis_rotation

	return sa
end

-- Convert from SVG arc (sa) to center arc (ca)
function ConvertToCenterArc(sa)
	local ca = {}
	local phi = math.rad(sa.x_axis_rotation)

	-- Compute half distance between start and end points
	local halfX = (sa.x1 - sa.x2) / 2
	local halfY = (sa.y1 - sa.y2) / 2

	-- Step 1: Compute x1' and y1'
	local x1p =   halfX * math.cos(phi) + halfY * math.sin(phi)
	local y1p = - halfX * math.sin(phi) + halfY * math.cos(phi)

	-- Step 2: Compute cx' and cy'
	local sign
	if sa.large_arc_flag == sa.sweep_flag then
		sign = -1
	else
		sign = 1
	end
	local rx_2 = sa.rx^2
	local ry_2 = sa.ry^2
	local x1p_2 = x1p^2
	local y1p_2 = y1p^2
	local sqr = rx_2 * ry_2 - rx_2 * y1p_2 - ry_2 * x1p_2
printf(sqr)
	if sqr > 0 then
		sqr = sign * math.sqrt(sqr / (rx_2 * y1p_2 + ry_2 * x1p_2))
	else
		sqr = 0
	end
	local cxp =   sqr * sa.rx * y1p / sa. ry
	local cyp = - sqr * sa.ry * x1p / sa.rx
print(halfX, halfY, x1p, y1p, sign, rx_2, ry_2, x1p_2, y1p_2, sqr, cxp, cyp)

	-- Step 3: Compute cx and cy from cxp and cyp
	ca.cx = (sa.x1 + sa.x2) / 2 + cxp * math.cos(phi) - cyp * math.sin(phi)
	ca.cy = (sa.y1 + sa.y2) / 2 + cxp * math.sin(phi) + cyp * math.cos(phi)

	-- Step 4: Compute angle start and angle extend

	-- Compute angle between two vectors
	local function ComputeAngle(u, v)
		local t = u.x * v.x + u.y * v.y
		local b = math.sqrt((u.x^2 + u.y^2) * (v.x^2 + v.y^2))
		local sign
		if u.x * v.y - u.y * v.x < 0 then
			sign = -1
		else
			sign = 1
		end
		return math.deg(sign * math.acos(t / b))
	end

	local v1 = { x=1, y=0 }
	local v2 = { x=(x1p - cxp) / sa.rx, y=(y1p - cyp) / sa.ry }
	local v3 = { x=(-x1p - cxp) / sa.rx, y=(-y1p - cyp) / sa.ry }

	ca.theta1 = ComputeAngle(v1, v2)
	ca.delta_theta = math.mod(ComputeAngle(v2, v3), 360)
print(ca.theta1, ca.delta_theta)

	-- Fix range of theta1 and delta theta
	if sa.sweep_flag == 0 then
		sign = -1
	else
		sign = 1
	end
	ca.delta_theta = sign * ca.delta_theta
	if ca.delta_theta > 0 then
		ca.theta1 = ca.theta1 - 360
	elseif ca.delta_theta < 0 then
		ca.theta1 = ca.theta1 + 360
	end
	ca.theta1 = math.mod(ca.theta1, 360)	-- Perhaps not useful, doesn't do harm...

	ca.rx = sa.rx
	ca.ry = sa.ry
	ca.x_axis_rotation = sa.x_axis_rotation

	return ca
end

-- Test code

function printf(...)
	-- Format arguments in the provided string
	local fs = string.format(unpack(arg))
	-- Remove unnecessary decimal parts
	fs = string.gsub(fs, "%.00", "")
	-- Write the resulting string
	print(fs)
end

function PrintSvgArc(sA)
	printf('x1="%0.2f" y1="%0.2f" rx="%0.2f" ry="%0.2f" x_axis_rotation="%0.2f"\nlarge_arc_flag="%0.2f" sweep_flag="%0.2f"  x2="%0.2f" y2="%0.2f" ',
		sA.x1, sA.y1, sA.rx, sA.ry, sA.x_axis_rotation,
		sA.large_arc_flag, sA.sweep_flag, sA.x2, sA.y2)
end

function PrintCenterArc(cA)
	printf('cx="%0.2f" cy="%0.2f" rx="%0.2f" ry="%0.2f"\nx_axis_rotation="%0.2f" theta1="%0.2f" delta_theta="%0.2f" ',
		cA.cx, cA.cy, cA.rx, cA.ry,
		cA.x_axis_rotation, cA.theta1, cA.delta_theta)
end

function fprintf(f, ...)
	-- Format arguments in the provided string
	local fs = string.format(unpack(arg))
	-- Remove unnecessary decimal parts
	fs = string.gsub(fs, "%.00", "")
	-- Write the resulting string
	f:write(fs)
end

local svgHeader =
[[
<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>
<svg width="640" height="480"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
]]
local svgLine  = '<line x1="%0.2f" y1="%0.2f" x2="%0.2f" y2="%0.2f"/>\n'
local svgText = '<text x="%0.2f" y="%0.2f">%s</text>\n'

function CreateSvg(title, desc)
	local f = assert(io.open("@ArcCalc.svg", "w"))
	f:write(svgHeader)
	if title ~= nil then
		fprintf(f, '  <title>%s</title>\n', title)
	end
	if desc ~= nil then
		fprintf(f, '  <desc>\n%s\n  </desc>\n', desc)
	end
	f:write[[
  <defs>
    <marker id="Arrow"
            viewBox="0 0 10 10" refX="0" refY="5"
            markerUnits="strokeWidth"
            markerWidth="8" markerHeight="6"
            orient="auto">
      <path d="M 0 0 L 10 5 L 0 10 z"/>
    </marker>
  </defs>
]]
	return f
end

function GetPointOnEllipse(el, theta)
	local x = el.cx + el.rx * math.cos(theta)
	local y = el.cy + el.ry * math.sin(theta)
	return { x=x, y=y }
end

function TestConversion(cA, sA)
	if sA == nil and cA == nil then
		print"Error in parameters!"
		return
	end
	local f
	if sA == nil then
		sA = ConvertToSvgArc(cA)
		f = CreateSvg("Center based elliptical arc to SVG arc")
	end
	if cA == nil then
		cA = ConvertToCenterArc(sA)
		f = CreateSvg("SVG arc to center based elliptical arc")
	end
--	PrintSvgArc(sA)
--	PrintCenterArc(cA)
--	printf(AsText(sA))
--	printf(AsText(cA))
	fprintf(f, '  <g transform="rotate(%0.2f %0.2f,%0.2f)">\n',
		cA.x_axis_rotation, cA.cx, cA.cy)

	f:write[[
    <g stroke="grey" stroke-width="4" fill="#E0FFE0">
]]
	-- Initial ellipse
	fprintf(f, '      <ellipse cx="%0.2f" cy="%0.2f" rx="%0.2f" ry="%0.2f"/>\n',
		cA.cx, cA.cy, cA.rx, cA.ry)

	-- Arc defining angles
	local t1, t2 = math.rad(cA.theta1), math.rad(cA.theta1 + cA.delta_theta)
	local p1, p2 = GetPointOnEllipse(cA, t1), GetPointOnEllipse(cA, t2)
	fprintf(f, '    ' .. svgLine,
		cA.cx, cA.cy,
		p1.x, p1.y)
	fprintf(f, '    ' .. svgLine,
		cA.cx, cA.cy,
		p2.x, p2.y)

    f:write('    </g>\n') -- Grey

	-- Coordinate axis
	f:write[[
    <g stroke="black" stroke-width="1" marker-end="url(#Arrow)" font-size="10" font-family="Verdana">
]]
	local axisIndent  = '      '
	fprintf(f, axisIndent .. svgLine,
		cA.cx - 1.5 * cA.rx, cA.cy,
		cA.cx + 1.5 * cA.rx, cA.cy)
	fprintf(f, axisIndent .. svgLine,
		cA.cx, cA.cy - 1.5 * cA.ry,
		cA.cx, cA.cy + 1.5 * cA.ry)
    fprintf(f, axisIndent .. svgText,
		cA.cx + 1.5 * cA.rx, cA.cy + 12, 'x')
    fprintf(f, axisIndent .. svgText,
		cA.cx + 7, cA.cy + 1.5 * cA.ry, 'y')
    f:write('    </g>\n') -- Axis

    f:write('  </g>\n')	-- Rotation

	-- The SVG arc
	f:write[[
  <g stroke="red" stroke-width="1" fill="blue" fill-opacity="0.3">
]]
	fprintf(f, '    <path d="M %0.2f,%0.2f A %0.2f,%0.2f %0.2f %i,%i %0.2f,%0.2f"/>\n',
		sA.x1, sA.y1, sA.rx, sA.ry, sA.x_axis_rotation,
		sA.large_arc_flag, sA.sweep_flag, sA.x2, sA.y2)
	f:write[[
  </g>
</svg>
]]
	f:close()
end

--TestConversion(centerArc, nil)
TestConversion(nil, svgArc)
