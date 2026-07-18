#redo

import re
from enum import Enum, auto

root_state = 'stInstrWrite'  #/////////////////////////////////param
forced_val_prior = '0'; #/////////////////////////////////param

states_set = {
    'stInstrWrite',
    'stTMP',
    'stBEQ',
    'stBEQTrue',
    'stSWMemWrite',
    'stDataTMP',
    'stLWWriteData',
    'stRegFileWrLL',
    'stPCUpdate',
    'stLSH',
    'stOr',
    'stAND',
}

names_w_type_o : dict[str,str] = {}
names_w_type_o['aluOp'] = 'output reg [2:0]   '
names_w_type_o['regFileWr'] = 'output reg '
names_w_type_o['instrWrite'] = 'output reg '
names_w_type_o['mux1'] = 'output reg '
names_w_type_o['mux2'] = 'output reg '
names_w_type_o['mux0'] = 'output reg '
names_w_type_o['memWrite'] = 'output reg '
names_w_type_o['dataTMPWr'] = 'output reg '
names_w_type_o['floprPcUpdate'] = 'output reg '
names_w_type_o['floprPcMUX'] = 'output reg '


names_w_type_i : dict[str,str] = {}
names_w_type_i['opcode'] = 'input wire [2:0] '
names_w_type_i['beq'] = 'input wire '


class g_Arrow():
    def __init__(self):
        self.conditions = []
        self.condition_size = '4\'b'; #/////////////////////////////////param

class g_Node():
    def __init__(self):
      self.children: dict[g_Arrow,g_Node] = {}
      self.repeat = 0    
      self.name = ''
      self.signals_vals = {}
      self.force = {}

    def print_node(self):
      print("node_start=======================")
      print('node name = ' + str(self.name))
      print("repeat = ",str(self.repeat))
      ch_str = ""
      for arr, nod in self.children.items():
        for a in arr.conditions:
          ch_str += "cond = " + a + " "
        ch_str += " node = " + nod.name + "|"
      print(ch_str)
      print("node_end=======================")


parallel : set[g_Node] = set() 


def find_node_by_name(parallel,name):
    for node in iter(parallel):
        if (node.name == name):
            return node
        else:
            None


def pars(full_content,parallel : set[g_Node]):
    full_content = full_content.replace(' ','')
    full_content = full_content.replace('_','')
    full_content =  re.split('\n',full_content)

    splitters = '(->|'
    splitters += '-->|'
    splitters += '--->|'
    splitters += ':\[|'
    splitters += '\]|'
    splitters += '\||'
    splitters += '=)'
    res = []
    for i in full_content:
        res.append(re.split(splitters,i))

    line_cnt = 0
    for l in res:
        line_cnt += 1
        print('Line number: '+ str(line_cnt))
        print(l)

        if ((l[0] == '@startumlttt') | (l[0] == '@enduml') | (l[0] == '')):
            continue
        else:
            n : g_Node = find_node_by_name(parallel,l[0])
            if (n == None):
                n = g_Node()
                n.name = l[0]
                parallel.add(n)   

            if (l[1] == '-->'):
                arrow = g_Arrow()
                for cond in l[4:-2:2]:
                    arrow.conditions.append(cond)

                end_node = find_node_by_name(parallel,l[2])
                if (end_node == None):
                    end_node = g_Node()
                    end_node.name = l[2]
                    parallel.add(end_node)

                n.children[arrow] = end_node


            elif (l[1] == ':['):
                n.force[l[2]] = l[4]

            elif (l[1] == '--->'):
                n.repeat = l[2]

            else: 
                print('Wrong line')
                print('Line number: '+ str(line_cnt))
                print(l)
                raise Exception()
                   

full_content = ''

with open('./proc_fsm.pu', 'r', encoding='utf-8') as file:
    full_content = file.read()
    


pars(full_content,parallel)
# root = find_node_by_name(parallel,'S0Fetch')
print("states_set ==========================================")
print(states_set)

def checker(parallel,states_set,names_w_type_o):
    states : set[str] = set()
    for i in parallel:
        states.add(i.name)
    
    diff = (states_set - states) | (states - states_set)
    if (len(diff) != 0):
        print(diff)
        raise Exception('Wrong states')

    #checks if all forced signals was in names_w_type_o
    names_key = names_w_type_o.keys()
    for j in parallel:
        diff2 = (names_key - j.force) 
        if (len(names_key) - len(diff2) != len(j.force)):
            print('j[name] = ' + str(j.name))
            print(j.force - names_key)
            raise Exception('Wrong force signals')




checker(parallel,states_set,names_w_type_o)


def new_line(index,length):
    return (',\n' if (index != (length - 1)) else '\n')


def generate(
        in_out,
        out,
        states,
        parallel,
        start_node,
        ):
    
    in_out_str = ''
    for name, direction in (in_out.items()):
        in_out_str += direction + ' ' + name + ',\n'

    for name, direction in (out.items()):
        in_out_str += direction + ' ' + name + ',\n'
    in_out_str = in_out_str[:-2]

    states_str = ''
    for index, (state) in enumerate(states):
        states_str += state + new_line(index,len(states))

    forced_default = ''
    for forced_name in out.keys():
        forced_default += forced_name + ' = 0;\n'

    outer_string = 'case (state)\n'
    for node in parallel:
        outer_string += '    ' + node.name + ' : '
        outer_string += 'begin\n'

        f_val_res = ''
        for forced_name, forced_val in node.force.items():
            f_val_res += '        ' +forced_name + ' = \'b' + (forced_val_prior if (forced_val == '*') else forced_val) + ';\n'    

        outer_string += f_val_res

        #inner case
        inner_string = '        casez({'
        for i in in_out.keys():
            inner_string = inner_string + i + ',' 
        inner_string = inner_string[:-1]
        inner_string += '})\n'

        for arrow, node_child in node.children.items():

            steps_str = ''
            node_condition = ''
            #conditions inner
            for cond in arrow.conditions:
                if (cond == '*'):
                    node_condition += 'default' + ','
                else:
                    node_condition += arrow.condition_size + cond + ','
            node_condition = node_condition[:-1]
                
            steps_str += '            ' +node_condition + ' : nextstate =' + node_child.name + ';'

            inner_string += steps_str + '\n'


        outer_string +=  inner_string + '        ' + 'endcase\n'
        outer_string += 'end\n\n'

    outer_string += 'endcase\n\n'

    return f"""module control_unit
(
input clk,
input rst,
{in_out_str}
);
typedef enum {{ 
{states_str}    
}} states_type;
states_type state, nextstate;

always_ff @(posedge clk, posedge rst)
    if (rst) state <= {start_node};
    else state <= nextstate;

always_comb
begin
{forced_default}
nextstate = {root_state};
{outer_string}
end

endmodule
    """
    

with open('control_unit.sv', 'w', encoding='utf-8') as file:
  file.write(generate(names_w_type_i,names_w_type_o,states_set,parallel,root_state))