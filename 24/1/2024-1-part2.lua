local left = {}
local right = {}

local file = io.open("input.txt", "r")
if not file then
	print("Error: Could not open file")
	return -- Exit the script or handle the error
end
for line in file:lines() do
	local l, r = line:match("(%d+)%s+(%d+)")
	if l and r then
		table.insert(left, tonumber(l))
		table.insert(right, tonumber(r))
	end
end
table.sort(left)
table.sort(right)

local sum = 0
for i = 1, #left do
	local score = 0
	for j = 1, #right do
		if left[i] == right[j] then
			score = score + 1
		end
	end
	sum = sum + left[i] * score
end

print(sum)
