start = "abc"
end =   "cba"

chart = []

for i in range(len(end) + 1):
	chart.insert(i, [i])
	for j in range(1, len(start) + 1):
		if i == 0:
			chart[i].insert(j, j)
		else:
			if start[j - 1] == end[i - 1]:
				chart[i].insert(j, chart[i - 1][j - 1])
			else:
				smallest = min(chart[i][j -1], chart[i - 1][j], chart[i - 1][j - 1])
				chart[i].insert(j, smallest + 1)

for line in chart:
	print(line)

distance = chart[len(end)][len(start)]
print(distance)


