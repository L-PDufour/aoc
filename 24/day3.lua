local file = io.open("./input-day3.txt", "r")
if not file then
	print("Cannot open file")
	return
end
local t = {}
for line in file:lines() do
	local i = 1
	while true do
		local pattern = "mul%((%d+),%s*(%d+)%)"
		local start_idx, end_idx = string.find(line, pattern, i)
		if not start_idx then
			break
		end
		table.insert(t, string.sub(line, start_idx + 3, end_idx))
		i = end_idx + 1
	end
end
local total_sum = 0
for _, pair in ipairs(t) do
	local a, b = pair:match("%((%d+),%s*(%d+)%)")
	if a and b then
		a = tonumber(a)
		b = tonumber(b)
		local product = a * b
		total_sum = total_sum + product
	end
end
print("Total Sum of Products:", total_sum)
