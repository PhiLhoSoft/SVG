#! lua-5.0.exe
-- Convert a file to another file, line per line.
--
-- Take two parameters: the file to process as input, the resulting file as output.
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.0 -- 2004/11/18 -- Initial code, from my CreateHtmlToc.lua program

filenameIn  = (arg and arg[1]) or "-"	-- If absent, use standard input
filenameOut = (arg and arg[2]) or "-"	-- If absent, use standard output

local resultList = {}

function Split(toSplit)
	local splitted = {}
	local i = 0
	for part in string.gfind(toSplit, "(M? ?[^ ]* [^ ]*) ?") do
		i = i + 1
		splitted[i] = part
	end
	return splitted
end

-- Extract useful information from the given line.
function ProcessLine(line)
	if line == nil then
		return nil
	end
--	lineNumber = lineNumber + 1
	if string.find(line, '<path') == nil then
		io.write(line .. '\n')
	else
		-- Currently quite rigid: path element must be on one line and
		-- must have only id and d attributes, in that order.
		local _, _, id, d = string.find(line, 'id="([^"]+)" d="([^"]+)"')
		if id and d then
			-- Split path
			local sd = Split(d)
			-- Keep starting point
			local j, first = 2, '-'

			-- Walk the table, dropping duplicate points
			for i = 1, table.getn(sd) - 1 do
				-- Drop the 'M' command, if any
				local _, _, p = string.find(sd[i], 'M? *(.*)')
				-- If there is a 'M' command, memorize first point
				if p ~= sd[i] then
					-- If last point is equal to first one, replace it by 'Z'
					if first == sd[j - 2] then
						sd[j - 2] = 'Z'
					end
					first = p
				end
				-- If two consecutive points are different, keep the second one
				-- ie. if they are equal, drop the second one.
				if p ~= sd[i + 1] then
					sd[j] = sd[i + 1]
					j = j + 1
				end
			end
			-- If last point is equal to first one, replace it by 'Z'
			if first == sd[j - 1] then
				sd[j - 1] = 'Z'
			end
			table.setn(sd, j - 1)
--			io.write('<path id="' .. id .. '" d="' .. table.concat(sd, ' ') .. '"/>\n')

			-- Walk the resulting table, transforming absolute linetos
			-- to relative ones.
			-- I can probably merge this one with the above, but I prefer
			-- to keep them separated, for easy understanding of algorithm
			-- and to allow various levels of optimization.
			local p, x, y
			local px, py = -1, -1
			for i = 1, table.getn(sd) do
				-- Drop the 'M' command, if any
				_, _, p = string.find(sd[i], 'M? *(.*)')
				if sd[i] == 'Z' then
					-- Keep it
				elseif p ~= sd[i] then
					-- If there is a 'M' command, save coords
					_, _, px, py = string.find(p, "([%d]+) ([%d]+)")
					-- I could make it relative, but I feel it isn't worth it
					sd[i] = 'M' .. px .. ',' .. py
				else
					-- Otherwise, transform the absolute coordinate to relative one
					_, _, x, y = string.find(p, "([%d]+) ([%d]+)")
					if x == px and y ~= py then
						p = 'v' .. y - py
					elseif x ~= px and y == py then
						p = 'h' .. x - px
					else
						p = 'l' .. x - px .. ',' .. y - py
					end
					sd[i] = p
					px, py = x, y
				end
			end
--			io.write('<path id="' .. id .. '" d="' .. table.concat(sd) .. '"/>\n')

			-- Walk again the resulting table, collapsing consecutive linetos in identical
			-- directions into one.
			-- Same comment about separating algorithms....

			-- Previous Command, Total Value, Current Command, Current Value
			local pc, tv, cc, cv = '', 0, '', 0
			local j = 1
--print('Init: ' .. table.getn(sd))
			for i = 1, table.getn(sd) do

--~ function DumpStep(s)
--~ 	print(s .. ': ', j, sd[j], cc, cv, pc, tv)
--~ end

				cc = string.sub(sd[i], 1, 1)
--print(i .. ' -- ' .. sd[i])
				if cc == 'Z' or cc == 'M' or cc == 'l' then
					-- Closepath or Moveto: keep it.
					-- Diagonal lineto, to optimize later.
					-- Just keep it now
					if tv ~= 0 then
						-- Store previously cumulated linetos
						sd[j] = pc .. tv
--DumpStep(pc)
						j = j + 1
					end
					sd[j] = sd[i]
--DumpStep(cc)
					j = j + 1
					pc, tv = cc, 0
				elseif cc == 'h' or cc == 'v' then
					cv = string.sub(sd[i], 2)
--print('h|v: ' .. cv .. ' ' .. pc .. ' ' .. cc)
					if pc == cc then
						tv = tv + cv
					else
						if tv ~= 0 then
							sd[j] = pc .. tv
--DumpStep(cc)
							j = j + 1
						end
						pc, tv = cc, cv
					end
				end
			end
			table.setn(sd, j - 1)
--print('Res: ' .. j)
			io.write('<path id="' .. id .. '" d="' .. table.concat(sd) .. '"/>\n')
		else
			-- Another kind of path, just copy it
			io.write(line .. '\n')
		end
	end

	return true
end

-- Process the input file
function ProcessFile()
	local fI, fO

	if filenameIn ~= '-' then
		fI = io.open(filenameIn, "r")
		if fI == nil then
			return false, "open r " .. filenameIn
		end
	else
		fI = io.stdin
	end

	if filenameOut ~= '-' then
		fO = io.open(filenameOut, "w")
		if fO == nil then
			return false, "open w " .. filenameOut
		end
		io.output(fO)
	end

	-- Loop on the lines and process them
	for line in fI:lines() do
		ProcessLine(line)
	end

	if filenameIn ~= '-' then
		fI:close()
	end
	if filenameOut ~= '-' then
		io.output()
		fO:close()
	end

	return true, nil
end

result, op = ProcessFile()
if not result then
	io.stderr:write("Error on operation : " .. (op or 'nil') .. '\n')
else
	io.stderr:write("Done !\n")
end
