import sys

for line in sys.stdin:
    line = line.strip()
    tokens = line.split()
    tokens = tokens[:5] + [tokens[-1]]
    if '.ru' in tokens[1]:
        tokens[1] = tokens[1].replace('.ru', '.com')
    tokens = tokens[:1] + tokens[-1:] + tokens[1:-1]
    print('\t'.join(tokens))
