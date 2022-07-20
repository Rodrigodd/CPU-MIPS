import sys
import re


MEM_BASE_ADDRESS = 0x0A00
symbol_address = {}

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def bin(n, l):
    return '{0:0{1}b}'.format(n, l)

def hex(n):
    return '{0:08x}'.format(n)

def reg(s):
    if s[0] != "r":
        eprint("registers should start with r: {}".format(s))

    return bin(int(s[1:]), 5)

def num(s):
    if s[0:2] == '0x':
        return int(s[2:], 16)
    
    if s[0].isdigit():
        return int(s, 10)

    if s in symbol_address:
        return symbol_address[s]
    else:
        eprint("unkown symbol '{}'".format(s))
        return symbol_address[s]

code = []
data = []
    
def assemble(path):
    with open(path, 'r') as file:

        for line in file:
            line = line.split(';')[0] # remove comment
            line = line.strip()
            if line == '':
                continue
            print(line)

            if line[0] == ".":
                section = line[1:]
                if section == "data":
                    data_section = True
                elif section == "text":
                    data_section = False
                else:
                    print("unknown section {}".format(section))
                    return
                continue
            
            if data_section:
                args = re.split('\s|:\s|:', line.lower())
                if len(args) > 1:
                    symbol_address[args[0]] = len(data) + MEM_BASE_ADDRESS 
                    num_str = args[1]
                else:
                    num_str = args[0]
                if len(num_str) > 8:
                    eprint('value {} is to long'.format(num_str))
                    return

                data.append(hex(num(num_str)))
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

                    rt = reg(args[1]) # write reg
                    offset = bin(num(args[2]), 16)
                    rs = reg(args[3]) # address reg

                    out = f0 + rs + rt + offset
                    code.append(hex(int(out, 2)))
                elif args[0] in ['add', 'sub', 'and', 'or', 'mul']:
                    f0 = bin(2, 6)
                    rd = reg(args[1])
                    rs = reg(args[2])
                    rt = reg(args[3])
                    f1 = bin(10, 5)
                    i = ['add', 'sub', 'and', 'or', 'mul'].index(args[0])
                    f2 = bin([32, 34, 36, 37, 50][i], 6)

                    out = f0 + rs + rt + rd + f1 + f2
                    code.append(hex(int(out, 2)))
                else:
                    print('unknown opcode: {}', args[0])

                    

if __name__ == "__main__":
    assemble(sys.argv[1])
    kind = sys.argv[2] if 2 < len(sys.argv) else "c"
    if kind == "c":
        for l in code:
            print(l)
    elif kind == "d":
        for l in data:
            print(l)
    else:
        eprint("unknown arg '{}'".format(kind))

