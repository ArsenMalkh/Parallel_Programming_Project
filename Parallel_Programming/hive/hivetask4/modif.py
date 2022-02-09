import sys

for line in sys.stdin:
    line = line.strip()
    reverse_len = ""
    for i in range(0, len(line)):
        reverse_len += line[len(line) - 1 - i]
    print(reverse_len)
