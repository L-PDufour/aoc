local file = io.open("./input.txt", "r")
if not file then
	print("Cannot open file")
	return
end

local grid = {}
for line in file:lines() do
	local row = {}
	for num in line:gmatch("%d+") do
		table.insert(row, num)
	end
	table.insert(grid, row)
end
local count = 0
for i, row in pairs(grid) do
	local safety = false
	local level = nil
	for j = 2, #row do -- Start at 2 to compare with the previous element
		local result = row[j] - row[j - 1]
		if level == nil then
			if result < 0 then
				level = "descending"
			else
				level = "ascending"
			end
		end
		if level == "descending" and result > 0 then
			safety = false
			break
		end
		if level == "ascending" and result < 0 then
			safety = false
			break
		end
		result = math.abs(result)
		if result == 0 or result > 3 then
			safety = false
			break
		else
			safety = true
		end
	end
	if safety == true then
		count = count + 1
	end
end
print(count)
file:close()
