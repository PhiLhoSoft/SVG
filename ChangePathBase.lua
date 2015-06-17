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

-- Extract useful information from the given line.
function ProcessLine(line)
	if line == nil then
		return nil
	end
--	lineNumber = lineNumber + 1
	local _, _, el = string.find(line, "<path (.*)/>")
	if el == nil then
		io.write(line .. "\n")
	else
		io.write("<PATH ".. el .. "/>\n")
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
