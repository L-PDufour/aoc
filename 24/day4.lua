Counter = 0
Grid = {} -- Table of strings
ROWS = 0
COLS = 0

local function loadGrid(filename)
	local file = io.open(filename, "r")
	if not file then
		-- print("Cannot open file")
		return false
	end
	Grid = {}
	for line in file:lines() do
		table.insert(Grid, line)
		ROWS = ROWS + 1
	end
	file:close()
	COLS = #Grid[1]
	return true
end

local function isItX(y, x)
	return "x" ~= Grid[y]:sub(x, x):lower()
end

local function checkHorizontally(y, x)
	if isItX(y, x) then
		return
	end

	-- Check rightward (forward) for "xmas"
	if x <= COLS - 3 then
		local forwardResult = Grid[y]:sub(x, x + 3)
		if forwardResult:lower() == "xmas" then
			-- print("Found 'xmas' at row " .. y .. ", starting position " .. x .. ": " .. forwardResult)
			Counter = Counter + 1
		end
	end

	if x >= 3 then
		local backwardResult = Grid[y]:sub(x - 3, x)
		if backwardResult:lower():reverse() == "xmas" then
			-- print("Found 'xmas' at row " .. y .. ", starting position " .. x .. ": " .. backwardResult)
			Counter = Counter + 1
		end
	end
end

local function recursiveHorizontalCheck(y, startX)
	if startX > COLS then
		return
	end
	checkHorizontally(y, startX)
	recursiveHorizontalCheck(y, startX + 1)
end

local function checkVertically(x, y)
	if isItX(y, x) then
		return
	end

	local downwardString = ""
	local upwardString = ""
	if y <= ROWS - 3 then
		for i = 0, 3 do
			downwardString = downwardString .. Grid[y + i]:sub(x, x)
		end
	end

	if y >= 4 then
		for i = 0, 3 do
			upwardString = upwardString .. Grid[y - i]:sub(x, x)
		end
	end

	if downwardString:lower() == "xmas" then
		-- print("Found 'xmas' vertically at column " .. x .. ", starting row " .. y .. ": " .. downwardString)
		Counter = Counter + 1
	end

	if upwardString:lower() == "xmas" then
		-- print("Found 'samx' vertically at column " .. x .. ", starting row " .. y .. ": " .. upwardString)
		Counter = Counter + 1
	end
end

local function recursiveVerticalCheck(x, startY)
	if startY > ROWS then
		return
	end

	checkVertically(x, startY)

	recursiveVerticalCheck(x, startY + 1)
end

-- Function to check diagonals from a starting point
local function checkDiagonally(x, y, dx, dy)
	if isItX(y, x) then
		return
	end
	local diagonalString = ""
	for i = 0, 3 do
		local newX = x + (i * dx)
		local newY = y + (i * dy)

		-- Check bounds
		if newX < 1 or newX > COLS or newY < 1 or newY > ROWS then
			return -- Exit if out-of-bounds
		end

		-- Append the character to the diagonal string
		diagonalString = diagonalString .. Grid[newY]:sub(newX, newX)
	end

	-- Check for "xmas" match
	if diagonalString:lower() == "xmas" then
		print(
			"Found 'xmas' diagonally starting at (" .. x .. ", " .. y .. ") with direction (" .. dx .. ", " .. dy .. ")"
		)
		Counter = Counter + 1
	end
end

-- Function to check all diagonal patterns in the grid
local function checkAllDiagonals()
	for y = 1, ROWS do
		for x = 1, COLS do
			-- Down-right diagonal
			if x <= COLS - 3 and y <= ROWS - 3 then
				checkDiagonally(x, y, 1, 1)
			end

			-- Up-right diagonal
			if x <= COLS - 3 and y >= 4 then
				checkDiagonally(x, y, 1, -1)
			end

			-- Down-left diagonal
			if x >= 3 and y <= ROWS - 3 then
				checkDiagonally(x, y, -1, 1)
			end

			-- Up-left diagonal
			if x >= 3 and y >= 3 then
				checkDiagonally(x, y, -1, -1)
			end
		end
	end
end

local function checkAllRowsAndColumns()
	for y = 1, ROWS do
		recursiveHorizontalCheck(y, 1)
	end
	for x = 1, COLS do
		recursiveVerticalCheck(x, 1)
	end
	checkAllDiagonals()

	print("Total matches found: " .. Counter)
end

if loadGrid("./input-day4.txt") then
	checkAllRowsAndColumns()
end
