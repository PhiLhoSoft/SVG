#!Lua-5.0.exe
-- Transforms 2D geometrical objects described in Lua tables
-- to a SVG file.
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/08/26

-- Avoid to load this file twice
if SvgFormat ~= nil then return end

local Public, Private = {}, {}

SvgFormat = Public

local svgHeader =
[[
<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>
<svg width="640" height="480"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
]]
local svgLine = '<line x1="%0.2f" y1="%0.2f" x2="%0.2f" y2="%0.2f" %s/>\n'
local svgCircle = '<circle cx="%0.2f" cy="%0.2f" r="%0.2f" %s/>\n'
local svgEllipse = '<ellipse cx="%0.2f" cy="%0.2f" rx="%0.2f" ry="%0.2f" %s/>\n'
local svgText = '<text x="%0.2f" y="%0.2f" %s>%s</text>\n'

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
-- Private functions

function Private.sprintf(fo, ...)
--print("Format: ", fo, " Arg: ", AsText(arg))
	-- Format arguments in the provided string
	local fs = string.format(fo, unpack(arg))
--print("Result: ", fs)
	-- Remove unnecessary decimal parts (nicer for integers)
	fs = string.gsub(fs, "%.00", "")
	return fs
end

function Private.fprintf(fi, fo, ...)
	-- Write the resulting string
	fi:write(Private.sprintf(fo, unpack(arg)))
end

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
-- Public functions

function Public.ConvertPoint(p, f)
	return Private.sprintf(svgCircle, p.x, p.y, 1, f or '')
end

function Public.ConvertCircle(c, f)
	return Private.sprintf(svgCircle, c.pc.x, c.pc.y, c.r, f or '')
end

function Public.FormatText(x, y, t, f)
	return Private.sprintf(svgText, x, y, f or '', t)
end

function Public.CreateSvg(filename, title, desc, marker)
	local f = assert(io.open(filename, "w"))
	f:write(svgHeader)
	if title ~= nil then
		Private.fprintf(f, '  <title>%s</title>\n', title)
	end
	if desc ~= nil then
		Private.fprintf(f, '  <desc>\n%s\n  </desc>\n', desc)
	end
	if marker ~= nil then
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
	end
	return f
end

function Public.CloseSvg(f)
	f:write[[
</svg>
]]
	f:close()
end
