import sys
import re

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def bin(n, l):
    return '{0:0{1}b}'.format(n, l)

def hex(n):
    return '{0:08x}'.format(n)

def reg(s):
    if s[0] != "r":
        eprint("registers should start with r: {}", s)

    return bin(int(s[1:]), 5)

code = []
data = []
    
def assemble(path):
    with open(path, 'r') as file:

        for line in file:
            line = line.split(';')[0] # remove comment
            line = line.strip()
            if line == '':
                continue

            if line[0] == ".":
                section = line[1:]
                if section == "data":
                    data = True
                elif section == "text":
                    data = False
                else:
                    print("unknown section {}".format(section))
                    return
                continue
            
            if data:
                if len(line) > 8:
                    eprint('value {} is to long'.format(line))
                    return

                line = '0' * (8 - len(line)) + line
                data.append(line)
            else:
                args = re.split('\s|,\s|,|\(|\)', line.lower())
                args = [s for s in args if s != '']
                if args[0] in ['lw', 'sw']:
                    
                    if args[0] == 'lw':
                        f0 = bin(3, 6)
                    elif args[0] == 'sw':
                        f0 = bin(4, 6)
                    else:
                        print('error opcode: {}', args[0])

                    rs = reg(args[1])
                    offset = bin(int(args[2]), 16)
                    rt = reg(args[3])

                    out = f0 + rs + rt + offset
                    code.append(hex(int(out, 2)))
                elif args[0] in ['add', 'sub', 'and', 'or', 'mul']:
                    f0 = bin(2, 6)
                    rd = reg(args[1])
                    rt = reg(args[2])
                    rs = reg(args[3])
                    f1 = bin(10, 5)
                    i = ['add', 'sub', 'and', 'or', 'mul'].index(args[0])
                    f2 = bin([32, 34, 36, 37, 50][i], 6)

                    out = f0 + rs + rt + rd + f1  + f2
                    code.append(hex(int(out, 2)))
                else:
                    print('unknown opcode: {}', args[0])

                    

if __name__ == "__main__":
    assemble(sys.argv[1])
    for l in code:
        print(l)
