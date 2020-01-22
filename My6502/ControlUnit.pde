/*
59-bit wide CONTROL WORD made up of 32-bit wide DECODE ROM [0..31] and additional y-bits [32..x-1]from COMBINATIONAL LOGIC

DECODE ROM
12-bit address via 8-bit Opcode [0..7], clock-phase [8], and microinstruction step [9..11]

COMBINATIONAL LOGIC
Intercepts the opcode before the ROM is read
Can modify the opcode in the case of a branch operation (where the status flag is not equal to the required value) to a special NOP (3-cycles?).
Some control bits are not part of the control word - instead directly drive ALU/register settings


CONTROL WORD

[0..2]   - Outputs 1 
[3..5]   - Outputs 2 
[6..8]   - Outputs 3
[9..11]  - Loads 1
[12..13] - Loads 2 
[14..15]


*/

// Control Word
int CW_A_OUT = 1;
int CW_X_OUT = 2;
int CW_Y_OUT = 3;
int CW_SR_OUT = 4;
int CW_T_OUT = 5;
int CW_P_OUT = 6;
int CW_ALU_OUT = 7;
int CW_PCH_OUT = 9;
int CW_ADH_OUT = 10;
int CW_PCHR_OUT = 11;
int CW_PCLR_OUT = 12;
int CW_ADH_00 = 13;
int CW_ADH_01 = 14;
int CW_ADH_FF = 15;
int CW_PCL_OUT = 17;
int CW_ADL_OUT = 18;
int CW_S_OUT = 20;
int CW_INTVEC_LO = 21;
int CW_INTVEC_HI = 22;
//int CW_ADL_FE = 23;
int CW_A_LOAD = 25;
int CW_X_LOAD = 26;
int CW_Y_LOAD = 27;
int CW_S_LOAD = 28;
int CW_T_LOAD = 29;
int CW_P_LOAD = 30;
int CW_IR_LOAD = 31;
int CW_PCL_LOAD = 33;
int CW_PCH_LOAD = 34;
int CW_ADL_LOAD = 35;
int CW_ADH_LOAD = 36;
int CW_P_FROM_WB = 37;
int CW_P_FROM_ALU = 38;
int CW_P_FROM_IR5 = 39;
int CW_ALU_FORCE_CARRY = 40;
int CW_DB_WB = 42;
int CW_RB_WB = 43;
int CW_RB_DB = 44;
int CW_PC_INC = 46;
int CW_ADL_INC = 47;
int CW_S_COUNT = 48;
int CW_ALU_X_A = 49;
int CW_ALU_X_B = 50;
int CW_ALU_Y_0 = 51;
int CW_ALU_Y_1 = 52;
int CW_ALU_Y_2 = 53;
int CW_ALU_Y_3 = 54;
int CW_P_C_LOAD = 55;
int CW_P_Z_LOAD = 56;
int CW_P_I_LOAD = 57;
int CW_P_V_LOAD = 58;
int CW_P_N_LOAD = 59;
int CW_INST_END = 60;

// Additional Control Word Signals from Random Control Logic
int CW_S_COUNT_DIR = 61;
int CW_ALU_CIN = 62;
int CW_ALU_ROTATE = 63;
int CW_INT_BRK = 64;

String micro_instruction_names[] = {"", "A_OUT", "X_OUT", "Y_OUT", "S_OUT(R)", "T_OUT", "P_OUT", "ALU_OUT", "", "PCH_OUT(ADH)", "ADH_OUT(ADH)", "PCH_OUT(R)", "PCL_OUT(R)", "ADH_00", "ADH_01", "ADH_FF", "", "PCL_OUT(ADL)", "ADL_OUT(ADL)", "", "S_OUT(ADL)", "INTVEC_HI", "INTVEC_LO",
                                "", "", "A_LOAD", "X_LOAD", "Y_LOAD", "S_LOAD", "T_LOAD", "P_LOAD(ALL)", "IR_LOAD", "", "PCL_LOAD", "PCH_LOAD", "ADL_LOAD", "ADH_LOAD", "P_LOAD(WB)", "P_LOAD(ALU)", "P_LOAD(IR5)", "ALU_FORCE_CARRY", "", "DB_WB", "RB_WB", "RB_DB", "",
                                "PC_INC", "ADL_INC", "S_COUNT", "ALU_X_A", "ALU_X_B", "ALU_Y_0", "ALU_Y_1", "ALU_Y_2", "ALU_Y_3", "P_LOAD(C)", "P_LOAD(Z)", "P_LOAD(I)", "P_LOAD(V)", "P_LOAD(N)", "INST_END(OBSOLETE)", "S_COUNT_DIR", "ALU_CIN", "ALU_ROT", "INT_BRK"};       
//10000000100000001000000010000000100000000100001000000000000000000


// Encoded Micro-Instruction Bitmasks
// Bank 0.0 - Outputs 1 - R & W Buses - 3-bits
int MI_A_OUT = 0x1;
int MI_X_OUT = 0x2;
int MI_Y_OUT = 0x3;
int MI_SR_OUT = 0x4;
int MI_T_OUT = 0x5;
int MI_P_OUT = 0x6;
int MI_ALU_OUT = 0x7;

// Bank 0.1 - Outputs 2 - ADH Bus - 3-bits
int MI_PCH_OUT = 0x8;
int MI_ADH_OUT = 0x10;
int MI_PCHR_OUT = 0x18;
int MI_PCLR_OUT = 0x20;
int MI_ADH_00 = 0x28;
int MI_ADH_01 = 0x30;
int MI_ADH_FF = 0x38;

// Bank 0.2 - Outputs 3 - ADL Bus - 3-bits
int MI_PCL_OUT = 0x40;
int MI_ADL_OUT = 0x80;
int MI_S_OUT = 0x100;
int MI_INTVEC_LO = 0x140;
int MI_INTVEC_HI = 0x180;
int MI_ADL_FE = 0x1C0;

// Bank 0.3 - Loads 1 - W & D Buses - 3-bits
int MI_A_LOAD = 0x200;
int MI_X_LOAD = 0x400;
int MI_Y_LOAD = 0x600;
int MI_S_LOAD = 0x800;
int MI_T_LOAD = 0xA00;
int MI_P_LOAD = 0xC00;
int MI_IR_LOAD = 0xE00;
//int MI_ALU_INT_LOAD = 0xE00;

// Bank 0.4 - Loads 2 - Address and Status - 3-bits
int MI_PCL_LOAD = 0x1000;
int MI_PCH_LOAD = 0x2000;
int MI_ADL_LOAD = 0x3000;
int MI_ADH_LOAD = 0x4000;
int MI_P_FROM_WB = 0x5000;
int MI_P_FROM_ALU = 0x6000;
int MI_P_FROM_IR5 = 0x7000;

// Non-encoded - ALU Carry In force 1
int MI_ALU_FORCE_CARRY = 0x8000;

// Bank 1.0 - Buffers - 2-bits (multiplied by 0x10000 as technically all on ROM 2)
int MI_DB_WB = 0x10000;
int MI_RB_WB = 0x20000;
int MI_RB_DB = 0x30000;

// Bank 1.1 - Counters - 2-bits
int MI_PC_INC = 0x40000;
int MI_ADL_INC = 0x80000;
int MI_S_COUNT = 0xC0000;

// Non-encoded ALU operands
int MI_ALU_X_A = 0x100000;
int MI_ALU_X_B = 0x200000;
int MI_ALU_Y_0 = 0x400000;
int MI_ALU_Y_1 = 0x800000;
int MI_ALU_Y_2 = 0x1000000;
int MI_ALU_Y_3 = 0x2000000;

// Non-encoded Status Register Bit Loads
int MI_P_C_LOAD = 0x4000000;
int MI_P_Z_LOAD = 0x8000000;
int MI_P_I_LOAD = 0x10000000;
int MI_P_V_LOAD = 0x20000000;
int MI_P_N_LOAD = 0x40000000;


int MI_INST_END = 0x80000000;




// ControlBit
// Represents a wire from the Control Unit inputting into a component
// The state, represented here as true or false is equivalent to logic 1 & 0, or high & low
class ControlBit {
  boolean state;
  
  ControlBit() {
    state = false;
  }
  
  void setState(boolean new_state) {
    state = new_state;
  }
  
  void toggleState() {
    state = !state;
  }
  
  // enabled()
  // Just returns the state, but more readable - e.g. if(enabled()) or if(!enabled()) reads better than if(state) or if(!state)
  boolean enabled() {
    return state;
  }
}

class IOPin extends ControlBit {
  String display_name_enabled;
  String display_name_disabled;
  boolean invert;
  
  IOPin(String name, boolean active_low) {
    super();
    display_name_enabled = name;
    display_name_disabled = "";
    invert = active_low;
  }
  
  IOPin(String name) {
    this(name, false);
  }
  
  IOPin(String name_on, String name_off) {
    super();
    display_name_enabled = name_on;
    display_name_disabled = name_off;
    invert = false;
  }
  
  void display(float x, float y) {
    boolean enabled = enabled();
    String display_name = display_name_enabled;
    if(!enabled && display_name_disabled != "") {
      display_name = display_name_disabled;
    }
   
    color col; 
    if(enabled) {
      if(!invert) {
        col = color(255, 0, 0);
      } else {
        col = color(128);
      }
    } else {
      if(!invert) {
        col = color(128);
      } else {
        col = color(255, 0, 0);
      }
    }
    textFont(font_disp);
    fill(col);
    textAlign(LEFT, TOP);
    text(display_name, x, y);
    if(invert) {
      stroke(col);
      strokeWeight(1.5);
      line(x, y - 3, x + display_name.length() * 10, y - 3);
    }
  }
}

// ControlWord
// Represents a the decoded microinstruction bits from the Instruction ROMs for the current instruction and timing
class ControlWord {
  ControlBit[] control_bits;
  int word_length;
  
  ControlWord(int len) {
    word_length = len;
    control_bits = new ControlBit[len];
    for(int i=0; i<len; i++) {
      control_bits[i] = new ControlBit();
    }
  }
  
  void reset() {
    for(int i=0; i<word_length; i++) {
      control_bits[i].state = false;
    }
  }
  
  void setControlBit(int index, ControlBit cb) {
    control_bits[index] = cb;
  }
  
  void setBitState(int index, boolean state) {
    control_bits[index].state = state;
  }
  
  boolean getBitState(int index) {
    return control_bits[index].state;
  }
  
  boolean bitEnabled(int index) {
    return getBitState(index);
  }
}

class InstructionDef {
  String inst_name;
  int addressing_mode;
  int arguments;
  
  
  static final int IMPLIED = 0;
  static final int IMMEDIATE = 1;
  static final int ZERO_PAGE = 2;
  static final int ZERO_PAGE_X = 3;
  static final int ABSOLUTE = 4;
  static final int ABSOLUTE_X = 5;
  static final int ABSOLUTE_Y = 6;
  static final int INDIRECT_X = 7;
  static final int INDIRECT_Y = 8;
  static final int INDIRECT = 9;
  static final int RELATIVE = 10;
  static final int DUMMY = 11;      // Only used by BRK
  
  final int[] args = {0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1};
  
  final String[] addr_mode_format = {"", "#", "zpg", "zpg,X", "abs", "abs,X", "abs,Y", "ind,X", "ind,Y", "rel", "", ""};
  
  InstructionDef() {
    inst_name = "";
    addressing_mode = IMPLIED;
    arguments = 0;
  }
  
  void set(String name, int addr_mode) {
    inst_name = name;
    addressing_mode = addr_mode;
    arguments = args[addr_mode];
  }
  
  String cuFormat() {
    return inst_name + " " + addr_mode_format[addressing_mode];
  }
  
  // Returns a formatted string of the instruction at the passed address
  String disassemble(int[] data, int inst_addr) {
    String inst_str = inst_name + " ";
    switch(addressing_mode) {
      case IMMEDIATE:
        inst_str += "#$" + hex(data[inst_addr + 1], 2);
        break;
      case ZERO_PAGE:
        inst_str += "$" + hex(data[inst_addr + 1], 2);
        break;
      case ZERO_PAGE_X:
        inst_str += "$" + hex(data[inst_addr + 1], 2) + ", X";
        break;
      case ABSOLUTE:
        inst_str += "$" + hex(data[inst_addr + 2], 2) + hex(data[inst_addr + 1], 2);
        break;
      case ABSOLUTE_X:
        inst_str += "$" + hex(data[inst_addr + 2], 2) + hex(data[inst_addr + 1], 2) + ", X";
        break;
      case ABSOLUTE_Y:
        inst_str += "$" + hex(data[inst_addr + 2], 2) + hex(data[inst_addr + 1], 2) + ", Y";
        break;
      case INDIRECT_X:
        inst_str += "($" + hex(data[inst_addr + 1], 2) + ", X)";
        break;
      case INDIRECT_Y:
        inst_str += "($" + hex(data[inst_addr + 1], 2) + "), Y";
        break;
      case INDIRECT:
        inst_str += "($" + hex(data[inst_addr + 2], 2) + hex(data[inst_addr + 1], 2) + ")";
        break;
      case RELATIVE:
        inst_str += "$" + hex(data[inst_addr + 1], 2);
        break;  
    }
    
    return inst_str;
  }
}

class ControlUnit {
  Register ir;
  StatusRegister p; 
  
  InstructionDef[] instructions;
  int[] instruction_rom;
  ControlWord control_word;
    
  int cur_inst_address;
  int cur_op_code;
  
  int phase;  // Internal clock phase register (1-bit flip-flop); 0 = PHI1; 1 = PHI2
  int step;   // Internal step register (4-bit counter); 0-7
  int inst_version; // Set by combinational logic for instructions that differ based on external factors
  boolean inhibit_phase_flipflop;
  
  // DEBUG
  String last_cw = "";
  int last_clock = 0;
  // END DEBUG
   
  // Instruction versions for instructions that differ based on external factors
  final static int VER0 = 0;
  final static int VER1 = 1;
  final static int VER2 = 2;
  final static int VER3 = 3;
  
  // These are different definitions to those in Clock!
  final static int INT_PHI1 = 0;
  final static int INT_PHI2 = 1;
  
  ControlUnit(Register instruction_reg) {
    ir = instruction_reg;
    instruction_rom = new int[16384];  // 256 instructions * max 8 steps * 2 clock phases (12-bit address) * 4 instruction versions
    control_word = new ControlWord(65);
    
    for(int i=0; i<16384; i++) {
      instruction_rom[i] = 0;
    }
  
    instructions = new InstructionDef[256];
    for(int i=0; i<256; i++) {
      instructions[i] = new InstructionDef();
    }
    
    // Allow me this one...
    MicroCodeAssembler avengers = new MicroCodeAssembler(this);
    avengers.assemble();
    
    reset();
  }
  
  void reset() {
    cur_inst_address = -1;
    cur_op_code = -1;
    
    phase = 0;
    step = 0;
    inst_version = VER0;
    inhibit_phase_flipflop = false;
  }
  
  void connectComponentControlInput(int control_id, ControlBit input) {
    control_word.setControlBit(control_id, input);
  }
     
  // getIR5()
  // Returns bit-5 of the instruction register for set and clear instructions
  boolean getIR5() {
    // Test for CLV instruction - if so, return false instead of the bit value (true)
    if(ir.value == 0xB8) {
      return false;
    }
    return (ir.value & 0x20) == 0x20;
  }
  
  // Tests each bit in num with those in the 8-bit pattern - 0, 1 or x (don't care)
  boolean compareBits(int num, String pattern) {
    String num_bin = binary(num, 8);
    // Work LSB to MSB
    for(int i=7; i>=0; i--) {
      char b = pattern.charAt(i);
      if(b == 'x' || b == 'X' || b == '-') {
        continue;
      }
      if(num_bin.charAt(i) != b) {
        return false;
      }
    }
    return true;
  }
  
  
  void update(Clock c) {
    // Set the control-word bits for the current phase
    // Generally, output enables on registers will be active at this point
    // Registers will latch data from their input buses on the rising edge of the current phase
    int op_code = ir.value;  // 8-bit op-code
    
    // This is used for disassembly
    if(cur_op_code != op_code) {
      cur_op_code = op_code;
      cur_inst_address = (pch.value * 256) + pcl.value;
    }
   
    control_word.reset();
    
    // Run the opcode through the combinational logic circuit first
    // BRK
    if(compareBits(op_code, "00000000")) {
      control_word.setBitState(CW_INT_BRK, true);
      control_word.setBitState(CW_S_COUNT_DIR, true); // Count down
    }
    // ADC and SBC - test for 011---01 or 111---01
    else if(compareBits(op_code, "-11---01")) {
      // Use the Status Register Carry value
      control_word.setBitState(CW_ALU_CIN, p.getC());
    } 
  // ALU Carry In - tested positive for 11--1000 or 111--110 for INC operations
  //else if(compareBits(op_code, "11--1000") || compareBits(op_code, "111--110")) {
  //  // Use a value of 1
  //  control_word.setBitState(CW_ALU_FORCE_CARRY, true);
  //}
    // Branching - test for ---10000 (all branch operations)
    else if(compareBits(op_code, "---10000")) {
      if(step == 1 && phase == INT_PHI1) {
        boolean bit_status = ((op_code & 0x20) == 0x20);
        if(compareBits(op_code, "00------")) {
          // Negative Flag
          if(p.getN() == bit_status) {
            inst_version = VER1; // Branch taken
          }
        } else if(compareBits(op_code, "01------")) {
          // Overflow Flag
          if(p.getV() != bit_status) {
            control_word.setBitState(CW_INST_END, true);
          }
        } else if(compareBits(op_code, "10------")) {
          // Carry Flag
          if(p.getC() != bit_status) {
            control_word.setBitState(CW_INST_END, true);
          }
        } else if(compareBits(op_code, "11------")) {
          // Zero Flag
          if(p.getZ() != bit_status) {
            control_word.setBitState(CW_INST_END, true);
          }
        }
      } else if(step == 2 && phase == INT_PHI1) {
        // Check for page transitions
        if(alu.c_out == true) {
          // Positive page transition if the ALU carry out has been set
          inst_version = VER2;
        } else if(alu.c_out == false && alu.y_n_out == true) {
          // Negative page transition if the ALU negative out flag has been set AND the carry out has NOT been set
          inst_version = VER3;
        }
      }
    }
    // ROR - test for 011---10, or ROL - test for 001---10
    else if(compareBits(op_code, "0-1---10")) {
      control_word.setBitState(CW_ALU_ROTATE, true);
      control_word.setBitState(CW_ALU_CIN, p.getC());
    }
    // Test for (ind), Y
    else if(compareBits(op_code, "---10001")) {
      if(alu.c_out == true) {
        inst_version = VER1;
      }
    }
    // Test for abs, X
    else if(compareBits(op_code, "---111--")) {
      if(alu.c_out == true) {
        inst_version = VER1;
      }
    }
    // Stack count direction
    else if((compareBits(op_code, "0-00-000") ^ (op_code == 0x40)) || (op_code == 0x20)) {
      control_word.setBitState(CW_S_COUNT_DIR, true); // Count down
    }
    
    // 14-bit decode ROM address made up of opcode [0..7], clock phase [8], step [9..11] and instruction version [12..13]
    int addr = op_code + (256 * phase) + (512 * step) + (4096 * inst_version);
    
    int cur_inst_word = instruction_rom[addr];
    
    control_word.setBitState(  cur_inst_word         & 0x7,       true);  // ROM 1 Bank 0 - R & W Bus Outputs
    control_word.setBitState(((cur_inst_word >> 0x3) & 0x7) +  8, true);  // ROM 1 Bank 1 - ADH Bus Outputs
    control_word.setBitState(((cur_inst_word >> 0x6) & 0x7) + 16, true);  // ROM 1 Bank 2 - ADL Bus Outputs
    control_word.setBitState(((cur_inst_word >> 0x9) & 0x7) + 24, true);  // ROM 1 Bank 3 - W & D Bus Loads
    control_word.setBitState(((cur_inst_word >> 0xC) & 0x7) + 32, true);  // ROM 1 Bank 4 - Address and Status Loads
    control_word.setBitState(CW_ALU_FORCE_CARRY,  (cur_inst_word & 0x8000)     == 0x8000);
    control_word.setBitState(((cur_inst_word >> 0x10) & 0x3) + 41, true); // ROM 2 Bank 0 - Buffers
    control_word.setBitState(((cur_inst_word >> 0x12) & 0x3) + 45, true); // ROM 2 Bank 1 - Counters
    control_word.setBitState(CW_ALU_X_A,  (cur_inst_word & 0x100000)   == 0x100000);
    control_word.setBitState(CW_ALU_X_B,  (cur_inst_word & 0x200000)   == 0x200000);
    control_word.setBitState(CW_ALU_Y_0,  (cur_inst_word & 0x400000)   == 0x400000);
    control_word.setBitState(CW_ALU_Y_1,  (cur_inst_word & 0x800000)   == 0x800000);
    control_word.setBitState(CW_ALU_Y_2,  (cur_inst_word & 0x1000000)  == 0x1000000);
    control_word.setBitState(CW_ALU_Y_3,  (cur_inst_word & 0x2000000)  == 0x2000000);
    control_word.setBitState(CW_P_C_LOAD, (cur_inst_word & 0x4000000)  == 0x4000000);
    control_word.setBitState(CW_P_Z_LOAD, (cur_inst_word & 0x8000000)  == 0x8000000);
    control_word.setBitState(CW_P_I_LOAD, (cur_inst_word & 0x10000000) == 0x10000000);
    control_word.setBitState(CW_P_V_LOAD, (cur_inst_word & 0x20000000) == 0x20000000);
    control_word.setBitState(CW_P_N_LOAD, (cur_inst_word & 0x40000000) == 0x40000000);
    control_word.setBitState(CW_INST_END, (cur_inst_word & 0x80000000) == 0x80000000);
    
    // DEBUG - Print the control word to the console
    String cw = "";
    String cw_set_bits = "";
    for(int i=0; i<control_word.word_length; i++) {
      cw += (control_word.bitEnabled(i)) ? "1" : "0";
      if(control_word.bitEnabled(i)) {
        if(micro_instruction_names[i] != "") {
          cw_set_bits += micro_instruction_names[i] + ", ";
        }
      }
    }
    if(!cw.equals(last_cw)) {
      //println(cw);
      println("Step " + step + " Phase " + (phase == INT_PHI2 ? "PHI2" : "PHI1"));
      println("CW: " + cw_set_bits);
      last_cw = cw;
    }
    // END DEBUG
    
    // If CW_S_OUT (Stack Pointer output to ADL) is active, also set the CW_ADH_01 control line
    if(control_word.bitEnabled(CW_S_OUT)) {
      control_word.setBitState(CW_ADH_01, true);
    }
    
    //              _____
    // Set the Read/Write "pin" of the CPU based on whether the Read Bus - Data Bus buffer is open or not
    // If it's open then we're assuming that we want to write data to RAM, otherwise we're reading from RAM
    if(control_word.bitEnabled(CW_RB_DB)) {
      io_rw.setState(false);
    } else {
      io_rw.setState(true);
    }
    
    // DEBUG - Print the current clock state to the console
    if(last_clock != c.currentState()) {
      String clock_states[] = {"", "RISING", "HIGH", "FALLING", "LOW"};
      println(clock_states[c.currentState()]);
      last_clock = c.currentState();
    }
    // END DEBUG
    
    if(c.currentState() == Clock.STATE_RISING) {
      if(phase == INT_PHI2 && control_word.bitEnabled(CW_IR_LOAD)) {
        phase = INT_PHI1;
        step = 0;
        inst_version = VER0;
        inhibit_phase_flipflop = true;
      }
    }
    // On the FALLING EDGE of the clock, flip-flop the internal phase register, and increment the count if required 
    if(c.currentState() == Clock.STATE_FALLING) {
      // Step count on the falling edge of PHI-2
      if(phase == INT_PHI2) {
        step++;
        if(step == 8) { 
          step = 0;
          inst_version = VER0;
        }
      }
      
      // Flip-flop phase
      if(!inhibit_phase_flipflop) {
        phase = 1 - phase;
      } else {
        inhibit_phase_flipflop = false;
      }
    }
    
  }
  
  void display(float x, float y) {
    textFont(font_disp);
    fill(0, 0, 128);
    
    textAlign(LEFT, TOP);
    text("STEP", x, y);
    text("PHASE", x, y + 20);
    text("INST", x, y + 40);
    text("VER", x, y + 60);
    
    textFont(font_disp);
    fill(0);
    
    text(str(step), x + 100, y);
    text((phase == INT_PHI1) ? "PHI-1" : "PHI-2", x + 100, y + 20);
    
    String inst = "FETCH";
 //   if(step > 0) {
      inst = instructions[ir.value].cuFormat();
 //   }
    text(inst, x + 100, y + 40);
    
    text(inst_version, x + 100, y + 60);
  }

}
