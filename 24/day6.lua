Singleton = {
	grid = {},
	gridW = 0,
	gridH = 0,
	guard = { 0, 0 },
	stop = false,
}
local function loadGrid(filename)
	local file = io.open(filename, "r")
	if not file then
		print("Cannot open file")
		return false
	end
	for line in file:lines() do
		table.insert(Singleton.grid, line)
		Singleton.gridH = Singleton.gridH + 1
	end
	file:close()
	Singleton.gridW = #Singleton.grid[1]
	return true
end

local function setGuardStartPos()
	for y = 1, Singleton.gridH do
		for x = 1, Singleton.gridW do
			if Singleton.grid[y]:sub(x, x) ~= "." and Singleton.grid[y]:sub(x, x) ~= "#" then
				Singleton.guard = { x, y }
				return
			end
		end
	end
end

local function setGuardPositionToX()
	local y = Singleton.guard[2]
	local x = Singleton.guard[1]

	local currentRow = Singleton.grid[y]

	local newRow = currentRow:sub(1, x - 1) .. "x" .. currentRow:sub(x + 1)

	Singleton.grid[y] = newRow
end

local function checkObstacle(x, y)
	local newY = Singleton.guard[2] + y
	local newX = Singleton.guard[1] + x

	if newY < 1 or newY > Singleton.gridH or newX < 1 or newX > Singleton.gridW then
		Singleton.stop = true
		return
	end

	return Singleton.grid[newY]:sub(newX, newX) ~= "#"
end

local directions = {
	{ 0, -1 },
	{ 1, 0 },
	{ 0, 1 },
	{ -1, 0 },
}

local function recursive(x, y, dirIndex)
	if
		Singleton.guard[1] < 1
		or Singleton.guard[1] > Singleton.gridW
		or Singleton.guard[2] < 1
		or Singleton.guard[2] > Singleton.gridH
		or Singleton.stop == true
	then
		return
	end

	Singleton.guard = { x, y }
	setGuardPositionToX()

	local dx = directions[dirIndex][1]
	local dy = directions[dirIndex][2]

	if checkObstacle(dx, dy) then
		recursive(x + dx, y + dy, dirIndex)
	else
		local newDirIndex = (dirIndex % 4) + 1
		recursive(x, y, newDirIndex)
	end
end

local function moveGuard()
	if
		Singleton.guard[1] < 1
		or Singleton.guard[1] > Singleton.gridW
		or Singleton.guard[2] < 1
		or Singleton.guard[2] > Singleton.gridH
		or Singleton.stop == true
	then
		return
	end
	recursive(Singleton.guard[1], Singleton.guard[2], 1) -- Start moving up
end

local function countX(grid)
	local count = 0
	for _, row in ipairs(grid) do
		local _, xCount = row:gsub("x", "")
		count = count + xCount
	end
	print(count)
	return count
end

if loadGrid("./input-day6.txt") then
	setGuardStartPos()
	moveGuard()
	countX(Singleton.grid)
end
-- 4696
