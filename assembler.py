import re

finish_vals= ''
full_content = '''
ll,3,31,        0 ожидаемое значение с дребезгом 1110
ll,4,1,         1 для сдвига на 1 и для операции 'and'
ll,5,50,        2 контакт, загрузка из адреса 30
lw,5,5,         3 контакт, сами данные
and,5,5,4,      4 еденица слева для дребезка
lshs,1,1,4,     5 сдвиг влево для дребезга
or,1,1,5,       6 сравнение с дребезгом
ll,6,10,        7
beq,1,3,6,      8
beq,0,0,0,      9 в начало. На этом момента 6, 3, 5 свободны, а 4 содержит 1 
ll,6,11,        10 сдвиг для инструкции в 6 адресе
lw,3,53,        11 сама инструкция в 3 адресе в нижних битах
lshs,3,3,6,     12 инструкция в верхних 3ёх битах
ll,5,51,        13
lw,5,5,         14
ll,7,52,        15
lw,7,7,         16
ll,4,61,        17 111_101 адрес записи и первый адрес данных
ll,6,3,         18 сдвиг для формирования адреса левых и правых данных
lshs,4,4,6,     19
ll,6,7,         20 второй адресс регистра данных
or,4,4,6,       21      
or,4,4,3,       22
ll,6,25,        23 qqqqqqqqqqqqqqqqqqqqqqqqq
sw,4,6,         24
empty,          25
ll,6,54,        26 qqqqqqqqqqqqqqqqqqqqqqqqq
sw,7,6,         27
beq,0,0,0,      28
'''



# full_content = '''
# ll,1,127
# ll,2,6
# lshs,1,1,2
# ll,3,127
# or,1,1,3
# ll,4,3
# add12,7,4,1
# '''
#в 7 регистре значение 2



#sw 105    25
finish_vals += '''tb_load_data[50] <= 12'b000000000001;\n''' #нажатие
finish_vals += '''tb_load_data[51] <= 12'b000_000_001_001;\n''' #data1
finish_vals += '''tb_load_data[52] <= 12'b000_000_000_101;\n''' #data2
finish_vals += '''tb_load_data[53] <= 12'b000_000_000_100;\n''' #instruction



full_content =  re.split('\n',full_content)
res = []
for i in full_content:
  res.append(re.split(',',i))

def Uns2Bin(number,amountOfZnach):
  number : int = int(number)
  binStr : str = ''
  for i in range(amountOfZnach):
    cur_left_bit = '1' if ((number & 1) == 1) else '0'
    number = number >> 1
    binStr = str(cur_left_bit) + binStr
  return binStr

def pars3():
  cmd_pars = ''
  cmd_pars += Uns2Bin(i[1],3)
  cmd_pars += Uns2Bin(i[2],3)
  cmd_pars += Uns2Bin(i[3],3)
  return cmd_pars



def getCommand(i,cmd_cnt):
  local_cmd : str = 'tb_load_data['+ str(cmd_cnt) +'] <= 12\'b'
  if i[0] == '':
     return ''
  elif i[0] == 'empty':
    local_cmd += 'xxx_xxx_xxx_xxx'
  elif i[0] == 'll': #prefer does not use
    local_cmd += '000'
    local_cmd += Uns2Bin(i[1],3)
    local_cmd += Uns2Bin(i[2],6)
  elif i[0] == 'lw':
    local_cmd += '001'
    local_cmd += Uns2Bin(i[1],3)
    local_cmd += Uns2Bin(i[2],3)
    local_cmd += 'xxx'
  elif i[0] == 'sw':
    local_cmd += '010'
    local_cmd += Uns2Bin(i[1],3)
    local_cmd += Uns2Bin(i[2],3)
    local_cmd += 'xxx'
  elif i[0] == 'lshs':
    local_cmd += '011'
    local_cmd += pars3()
  elif i[0] == 'or':
    local_cmd += '100'
    local_cmd += pars3()
  elif i[0] == 'and':
    local_cmd += '101'
    local_cmd += pars3()
  elif i[0] == 'beq':
    local_cmd += '110'
    local_cmd += pars3()
  elif i[0] == 'add12': #for negative number you must do ll + lsh + 
    local_cmd += '111'
    local_cmd += pars3()
  else:
    print("wrong command: ", i[0])
    raise Exception()
  return local_cmd


cmd_cnt = 0
all_cmd : str = ''
for i in res:
  cmdParsed = getCommand(i,cmd_cnt)
  if (cmdParsed != ''):
    all_cmd += cmdParsed + ';\n'
    cmd_cnt += 1



all_cmd += finish_vals
print(all_cmd)

with open("machine_code.txt", "w") as f:
  f.write(all_cmd)
