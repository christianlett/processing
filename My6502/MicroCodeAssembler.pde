class MicroCodeAssembler {
  
  ControlUnit cu;
  
  // Instruction versions for cu.instructions that differ based on external factors
  final static int VER0 = 0;
  final static int VER1 = 1;
  final static int VER2 = 2;
  final static int VER3 = 3;
  
  // These are different definitions to those in Clock!
  final static int PHI1 = 0;
  final static int PHI2 = 1;
  
  MicroCodeAssembler(ControlUnit cu) {
    this.cu = cu;
  }
  
  void loadInstructionROM(int ver, int inst, int stp, int clock_phase, int control_id) {
    int addr = inst + (clock_phase * 256) + (512 * stp) + (4096 * ver);
    cu.instruction_rom[addr] |= control_id; 
  }
  
  void assemble() {
    // ADC # (69) - NVZC - 2 cycles
    cu.instructions[0x69].set("ADC", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0x69, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_ALU_X_A);  // ACC
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER0, 0x69, 0, PHI2, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x69, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x69, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x69, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x69, 1, PHI2, MI_IR_LOAD);
    
    // ADC zpg (65) - NZCV - 3 Cycles
    cu.instructions[0x65].set("ADC", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0x65, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x65, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x65, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x65, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x65, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER0, 0x65, 1, PHI1, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x65, 1, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x65, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x65, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x65, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x65, 2, PHI2, MI_IR_LOAD);
    
    // ADC abs (6D) - NZCV - 4 cycles
    cu.instructions[0x6D].set("ADC", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0x6D, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x6D, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x6D, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x6D, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x6D, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0x6D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x6D, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x6D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x6D, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x6D, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER0, 0x6D, 2, PHI1, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x6D, 2, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x6D, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x6D, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x6D, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x6D, 3, PHI2, MI_IR_LOAD);
    
    // ADC abs, X (7D) - NZCV - 4 or 5 cycles
    cu.instructions[0x7D].set("ADC", InstructionDef.ABSOLUTE_X);
    
    // Version 0 - No carry from LB + X
    loadInstructionROM(VER0, 0x7D, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_PCL_OUT);    // Operand 1 (Low Address Byte)
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_ALU_Y_2);    // Load DB into ALU-Y (ALU_Y_2, ALU_Y_3)
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_X_OUT);      // Load X into ALU-X (X_OUTPUT, ALU_X_A)
    loadInstructionROM(VER0, 0x7D, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x7D, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER0, 0x7D, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER0, 0x7D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x7D, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER0, 0x7D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x7D, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x7D, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_ADH_OUT); 
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER0, 0x7D, 2, PHI1, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x7D, 2, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x7D, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x7D, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x7D, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x7D, 3, PHI2, MI_IR_LOAD);
    
    // Version 1 - Carry from LB + X (Add 1 cycle)
    loadInstructionROM(VER1, 0x7D, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER1, 0x7D, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER1, 0x7D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x7D, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER1, 0x7D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x7D, 1, PHI2, MI_ALU_X_B);    // Load HB into ALU
    loadInstructionROM(VER1, 0x7D, 1, PHI2, MI_ALU_FORCE_CARRY);    // Set Carry In
    loadInstructionROM(VER1, 0x7D, 2, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0x7D, 2, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_ADH_OUT); 
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_A_OUT);
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER1, 0x7D, 2, PHI2, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER1, 0x7D, 3, PHI1, MI_A_LOAD);
    loadInstructionROM(VER1, 0x7D, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x7D, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0x7D, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x7D, 4, PHI2, MI_IR_LOAD);
    
    // ADC abs, Y (79) - NZCV - 4 or 5 cycles
    cu.instructions[0x79].set("ADC", InstructionDef.ABSOLUTE_Y);
    
    // Version 0 - No carry from LB + Y 
    loadInstructionROM(VER0, 0x79, 0, PHI1, MI_PC_INC); 
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_PCL_OUT);    // Operand 1 (Low Address Byte)
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_ALU_Y_2);    // Load DB into ALU-Y (ALU_Y_2, ALU_Y_3)
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_Y_OUT);      // Load X into ALU-X (X_OUTPUT, ALU_X_A)
    loadInstructionROM(VER0, 0x79, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x79, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER0, 0x79, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER0, 0x79, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x79, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER0, 0x79, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x79, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x79, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_ADH_OUT); 
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER0, 0x79, 2, PHI1, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x79, 2, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x79, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x79, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x79, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x79, 3, PHI2, MI_IR_LOAD);
    
    
    // Version 1 - Carry from LB + Y (Add 1 cycle)
    loadInstructionROM(VER1, 0x79, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER1, 0x79, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER1, 0x79, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x79, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER1, 0x79, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x79, 1, PHI2, MI_ALU_X_B);    // Load HB into ALU
    loadInstructionROM(VER1, 0x79, 1, PHI2, MI_ALU_FORCE_CARRY);    // Set Carry In
    loadInstructionROM(VER1, 0x79, 2, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0x79, 2, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_ADH_OUT); 
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_A_OUT);
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_ALU_Y_2);  // B input (DB)
    loadInstructionROM(VER1, 0x79, 2, PHI2, MI_ALU_Y_3);  // B input (DB)
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER1, 0x79, 3, PHI1, MI_A_LOAD);
    loadInstructionROM(VER1, 0x79, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x79, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0x79, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x79, 4, PHI2, MI_IR_LOAD);
    
    // AND # (29) - NZ - 2 cycles
    cu.instructions[0x29].set("AND", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0x29, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x29, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x29, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x29, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x29, 0, PHI2, MI_ALU_Y_3);  // AND
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x29, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x29, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x29, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x29, 1, PHI2, MI_IR_LOAD);
    
    // ASL A (0A) - NZC - 2 cycles
    cu.instructions[0x0A].set("ASL A", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x0A, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x0A, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x0A, 0, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0x0A, 0, PHI1, MI_ALU_Y_3);  // Loading the same value into both sides of the ALU shifts left
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x0A, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x0A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x0A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x0A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x0A, 1, PHI2, MI_IR_LOAD);
    
    // BIT zpg (24) - NZV - 3 cycles
    /* bits 7 and 6 of operand are transfered to bit 7 and 6 of SR (N,V);
       the zeroflag is set to the result of operand AND accumulator */
       
    cu.instructions[0x24].set("BIT", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0x24, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x24, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x24, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x24, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x24, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0x24, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x24, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0x24, 1, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x24, 1, PHI1, MI_ALU_Y_3);  // A & B
    loadInstructionROM(VER0, 0x24, 1, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x24, 1, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x24, 1, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_P_FROM_WB);
    loadInstructionROM(VER0, 0x24, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x24, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x24, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x24, 1, PHI2, MI_IR_LOAD);
     
    // BCC (90), BCS (B0), BEQ (F0), BMI (30), BNE (D0), BPL (10), BVC (50), BVS (70)
    // Bxx rel - 2, 3 or 4 cycles
    cu.instructions[0x10].set("BPL", InstructionDef.RELATIVE);
    cu.instructions[0x30].set("BMI", InstructionDef.RELATIVE);
    cu.instructions[0x50].set("BVC", InstructionDef.RELATIVE);
    cu.instructions[0x70].set("BVS", InstructionDef.RELATIVE);
    cu.instructions[0x90].set("BCC", InstructionDef.RELATIVE);
    cu.instructions[0xB0].set("BCS", InstructionDef.RELATIVE);
    cu.instructions[0xD0].set("BNE", InstructionDef.RELATIVE);
    cu.instructions[0xF0].set("BEQ", InstructionDef.RELATIVE);
    int[] branch_opcodes = {0x10, 0x30, 0x50, 0x70, 0x90, 0xB0, 0xD0, 0xF0};
    for(int br_opcode : branch_opcodes) {
      // Default - branch not taken - 2 cycles
      loadInstructionROM(VER0, br_opcode, 0, PHI1, MI_PC_INC);
      loadInstructionROM(VER0, br_opcode, 1, PHI1, MI_PC_INC);
      loadInstructionROM(VER0, br_opcode, 1, PHI2, MI_PCL_OUT);
      loadInstructionROM(VER0, br_opcode, 1, PHI2, MI_PCH_OUT);
      loadInstructionROM(VER0, br_opcode, 1, PHI2, MI_IR_LOAD);
      
      // Ver 1 - branch taken, no page transition - 3 cycles
      loadInstructionROM(VER1, br_opcode, 0, PHI1, MI_PC_INC);
      loadInstructionROM(VER1, br_opcode, 0, PHI2, MI_PCLR_OUT);    // Current PC value (branch operation) onto R bus
      loadInstructionROM(VER1, br_opcode, 0, PHI2, MI_RB_WB);
      loadInstructionROM(VER1, br_opcode, 0, PHI2, MI_T_LOAD);     // Store PC value in T register for now
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_PCL_OUT);    // Operand (Offset)
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_PCH_OUT);
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_ALU_Y_2);    // Load Offset (from DB) into ALU-Y (ALU_Y_2, ALU_Y_3)
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_ALU_Y_3);
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_T_OUT);
      loadInstructionROM(VER1, br_opcode, 1, PHI1, MI_ALU_X_A);    // Load PCL (branch operation location) into ALU-X
      loadInstructionROM(VER1, br_opcode, 1, PHI2, MI_ALU_OUT);
      loadInstructionROM(VER1, br_opcode, 1, PHI2, MI_PCL_LOAD);
      loadInstructionROM(VER0, br_opcode, 2, PHI2, MI_PCL_OUT);
      loadInstructionROM(VER0, br_opcode, 2, PHI2, MI_PCH_OUT);
      loadInstructionROM(VER0, br_opcode, 2, PHI2, MI_IR_LOAD);
      
      // Ver 2 - branch taken, next page transition
      loadInstructionROM(VER2, br_opcode, 0, PHI1, MI_PC_INC);
      loadInstructionROM(VER2, br_opcode, 0, PHI2, MI_PCLR_OUT);    // Current PC value (branch operation) onto R bus
      loadInstructionROM(VER2, br_opcode, 0, PHI2, MI_RB_WB);
      loadInstructionROM(VER2, br_opcode, 0, PHI2, MI_T_LOAD);     // Store PC value in T register for now
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_PCL_OUT);    // Operand (Offset)
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_PCH_OUT);
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_ALU_Y_2);    // Load Offset (from DB) into ALU-Y (ALU_Y_2, ALU_Y_3)
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_ALU_Y_3);
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_T_OUT);
      loadInstructionROM(VER2, br_opcode, 1, PHI1, MI_ALU_X_A);    // Load PCL (branch operation location) into ALU-X
      loadInstructionROM(VER2, br_opcode, 1, PHI2, MI_ALU_OUT);
      loadInstructionROM(VER2, br_opcode, 1, PHI2, MI_PCL_LOAD);
      loadInstructionROM(VER2, br_opcode, 2, PHI1, MI_PCHR_OUT);
      loadInstructionROM(VER2, br_opcode, 2, PHI1, MI_ALU_X_A);    // Load PCH (branch operation location) into ALU-X
      loadInstructionROM(VER2, br_opcode, 2, PHI1, MI_ALU_FORCE_CARRY);    // Set ALU Carry In to 1
      loadInstructionROM(VER2, br_opcode, 2, PHI2, MI_ALU_OUT);    // Output the result of PCH + 1
      loadInstructionROM(VER2, br_opcode, 2, PHI2, MI_PCH_LOAD);
      loadInstructionROM(VER2, br_opcode, 3, PHI2, MI_PCL_OUT);
      loadInstructionROM(VER2, br_opcode, 3, PHI2, MI_PCH_OUT);
      loadInstructionROM(VER2, br_opcode, 3, PHI2, MI_IR_LOAD);
      
      // Ver 3 - branch taken, previous page transition
      loadInstructionROM(VER3, br_opcode, 0, PHI1, MI_PC_INC);
      loadInstructionROM(VER3, br_opcode, 0, PHI2, MI_PCLR_OUT);    // Current PC value (branch operation) onto R bus
      loadInstructionROM(VER3, br_opcode, 0, PHI2, MI_RB_WB);
      loadInstructionROM(VER3, br_opcode, 0, PHI2, MI_T_LOAD);     // Store PC value in T register for now
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_PCL_OUT);    // Operand (Offset)
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_PCH_OUT);
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_ALU_Y_2);    // Load Offset (from DB) into ALU-Y (ALU_Y_2, ALU_Y_3)
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_ALU_Y_3);
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_T_OUT);
      loadInstructionROM(VER3, br_opcode, 1, PHI1, MI_ALU_X_A);    // Load PCL (branch operation location) into ALU-X
      loadInstructionROM(VER3, br_opcode, 1, PHI2, MI_ALU_OUT);
      loadInstructionROM(VER3, br_opcode, 1, PHI2, MI_PCL_LOAD);
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_PCHR_OUT);
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_ALU_X_A);    // Load PCH (branch operation location) into ALU-X
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_ALU_Y_0);
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_ALU_Y_1);
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_ALU_Y_2);
      loadInstructionROM(VER3, br_opcode, 2, PHI1, MI_ALU_Y_3);    // Set ALU-Y to #FF (-1)
      loadInstructionROM(VER3, br_opcode, 2, PHI2, MI_ALU_OUT);    // Output the result of PCH - 1
      loadInstructionROM(VER3, br_opcode, 2, PHI2, MI_PCH_LOAD);
      loadInstructionROM(VER3, br_opcode, 3, PHI2, MI_PCL_OUT);
      loadInstructionROM(VER3, br_opcode, 3, PHI2, MI_PCH_OUT);
      loadInstructionROM(VER3, br_opcode, 3, PHI2, MI_IR_LOAD);
    }
    
    // BRK (00) - 7 cycles
    // Version 0 - BRK Software interrupt and IRQ Hardware interrupt
    cu.instructions[0x00].set("BRK", InstructionDef.DUMMY);
    loadInstructionROM(VER0, 0x00, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x00, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x00, 1, PHI2, MI_PCHR_OUT); // Push HB of PC
    loadInstructionROM(VER0, 0x00, 1, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x00, 1, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x00, 2, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x00, 2, PHI2, MI_PCLR_OUT); // Push LB of PC
    loadInstructionROM(VER0, 0x00, 2, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x00, 2, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x00, 3, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x00, 3, PHI2, MI_P_OUT);    // Push Status Register
    loadInstructionROM(VER0, 0x00, 3, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x00, 3, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x00, 4, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x00, 4, PHI2, MI_ADH_FF);
    loadInstructionROM(VER0, 0x00, 4, PHI2, MI_INTVEC_LO);
    loadInstructionROM(VER0, 0x00, 4, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x00, 4, PHI2, MI_PCL_LOAD);
    loadInstructionROM(VER0, 0x00, 5, PHI1, MI_ADH_FF);
    loadInstructionROM(VER0, 0x00, 5, PHI1, MI_INTVEC_HI);
    loadInstructionROM(VER0, 0x00, 5, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0x00, 5, PHI1, MI_PCH_LOAD);
    loadInstructionROM(VER0, 0x00, 5, PHI2, MI_P_I_LOAD);  // Sets the interrupt disable flag (for software interrupts, the B bit will also be set here)
    loadInstructionROM(VER0, 0x00, 5, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x00, 6, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x00, 6, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x00, 6, PHI2, MI_IR_LOAD);
    
    // Version 1 - RESET
    loadInstructionROM(VER1, 0x00, 1, PHI2, MI_PCHR_OUT); // Push HB of PC
    loadInstructionROM(VER1, 0x00, 1, PHI2, MI_S_OUT);
    loadInstructionROM(VER1, 0x00, 2, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER1, 0x00, 2, PHI2, MI_PCLR_OUT); // Push LB of PC
    loadInstructionROM(VER1, 0x00, 2, PHI2, MI_S_OUT);
    loadInstructionROM(VER1, 0x00, 3, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER1, 0x00, 3, PHI2, MI_P_OUT);    // Push Status Register
    loadInstructionROM(VER1, 0x00, 3, PHI2, MI_S_OUT);
    loadInstructionROM(VER1, 0x00, 4, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER1, 0x00, 4, PHI2, MI_ADH_FF);
    loadInstructionROM(VER1, 0x00, 4, PHI2, MI_INTVEC_LO);
    loadInstructionROM(VER1, 0x00, 4, PHI2, MI_DB_WB);
    loadInstructionROM(VER1, 0x00, 4, PHI2, MI_PCL_LOAD);
    loadInstructionROM(VER1, 0x00, 5, PHI1, MI_ADH_FF);
    loadInstructionROM(VER1, 0x00, 5, PHI1, MI_INTVEC_HI);
    loadInstructionROM(VER1, 0x00, 5, PHI1, MI_DB_WB);
    loadInstructionROM(VER1, 0x00, 5, PHI1, MI_PCH_LOAD);
   // loadInstructionROM(VER1, 0x00, 5, PHI2, MI_P_I_LOAD);  // Sets the interrupt disable flag
  //  loadInstructionROM(VER1, 0x00, 5, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER1, 0x00, 6, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0x00, 6, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x00, 6, PHI2, MI_IR_LOAD);
    
    // Version 2 - NMI
    loadInstructionROM(VER2, 0x00, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER2, 0x00, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER2, 0x00, 1, PHI2, MI_PCHR_OUT); // Push HB of PC
    loadInstructionROM(VER2, 0x00, 1, PHI2, MI_S_OUT);
    loadInstructionROM(VER2, 0x00, 1, PHI2, MI_RB_DB);
    loadInstructionROM(VER2, 0x00, 2, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER2, 0x00, 2, PHI2, MI_PCLR_OUT); // Push LB of PC
    loadInstructionROM(VER2, 0x00, 2, PHI2, MI_S_OUT);
    loadInstructionROM(VER2, 0x00, 2, PHI2, MI_RB_DB);
    loadInstructionROM(VER2, 0x00, 3, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER2, 0x00, 3, PHI2, MI_P_OUT);    // Push Status Register
    loadInstructionROM(VER2, 0x00, 3, PHI2, MI_S_OUT);
    loadInstructionROM(VER2, 0x00, 3, PHI2, MI_RB_DB);
    loadInstructionROM(VER2, 0x00, 4, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER2, 0x00, 4, PHI2, MI_ADH_FF);
    loadInstructionROM(VER2, 0x00, 4, PHI2, MI_INTVEC_LO);
    loadInstructionROM(VER2, 0x00, 4, PHI2, MI_DB_WB);
    loadInstructionROM(VER2, 0x00, 4, PHI2, MI_PCL_LOAD);
    loadInstructionROM(VER2, 0x00, 5, PHI1, MI_ADH_FF);
    loadInstructionROM(VER2, 0x00, 5, PHI1, MI_INTVEC_HI);
    loadInstructionROM(VER2, 0x00, 5, PHI1, MI_DB_WB);
    loadInstructionROM(VER2, 0x00, 5, PHI1, MI_PCH_LOAD);
    loadInstructionROM(VER2, 0x00, 5, PHI2, MI_P_I_LOAD);  // Sets the interrupt disable flag (for software interrupts, the B bit will also be set here)
    loadInstructionROM(VER2, 0x00, 5, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER2, 0x00, 6, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER2, 0x00, 6, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER2, 0x00, 6, PHI2, MI_IR_LOAD);
    
    // CLC (18) - C=0
    cu.instructions[0x18].set("CLC", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x18, 0, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x18, 0, PHI1, MI_P_FROM_IR5);
    loadInstructionROM(VER0, 0x18, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x18, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x18, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x18, 1, PHI2, MI_IR_LOAD);
    
    // CLI (58) - I=0
    cu.instructions[0x58].set("CLI", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x58, 0, PHI1, MI_P_I_LOAD);
    loadInstructionROM(VER0, 0x58, 0, PHI1, MI_P_FROM_IR5);
    loadInstructionROM(VER0, 0x58, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x58, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x58, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x58, 1, PHI2, MI_IR_LOAD);
    
    // CLV (B8) - V=0
    cu.instructions[0xB8].set("CLV", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xB8, 0, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0xB8, 0, PHI1, MI_P_FROM_IR5);
    loadInstructionROM(VER0, 0xB8, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xB8, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xB8, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xB8, 1, PHI2, MI_IR_LOAD);
     
    // CMP # (C9) - NZC - 2 cycles
    cu.instructions[0xC9].set("CMP", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0xC9, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_ALU_Y_0);
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_ALU_Y_1);  // ~B
    loadInstructionROM(VER0, 0xC9, 0, PHI2, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xC9, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xC9, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xC9, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xC9, 1, PHI2, MI_IR_LOAD);

    // DEX (CA) - NZ - 2 cycles
    cu.instructions[0xCA].set("DEX", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_X_OUT);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_ALU_Y_0);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_ALU_Y_2);
    loadInstructionROM(VER0, 0xCA, 0, PHI1, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0xCA, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xCA, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xCA, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xCA, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xCA, 0, PHI2, MI_X_LOAD);
    loadInstructionROM(VER0, 0xCA, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xCA, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xCA, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xCA, 1, PHI2, MI_IR_LOAD);
    
    // DEY (88) - NZ - 2 cycles
    cu.instructions[0x88].set("DEY", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_Y_OUT);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_ALU_Y_0);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_ALU_Y_2);
    loadInstructionROM(VER0, 0x88, 0, PHI1, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0x88, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x88, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x88, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x88, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x88, 0, PHI2, MI_Y_LOAD);
    loadInstructionROM(VER0, 0x88, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x88, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x88, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x88, 1, PHI2, MI_IR_LOAD);
    
    // EOR # (49) - NZ - 2 cycles
    cu.instructions[0x49].set("EOR", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0x49, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x49, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x49, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x49, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x49, 0, PHI2, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0x49, 0, PHI2, MI_ALU_Y_2);  // Exclusive OR
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x49, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x49, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x49, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x49, 1, PHI2, MI_IR_LOAD);
    
    // INC zpg (E6) - ZC - 5 Cycles
    cu.instructions[0xE6].set("INC", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0xE6, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xE6, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xE6, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xE6, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xE6, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xE6, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xE6, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xE6, 1, PHI1, MI_ALU_X_B);
    loadInstructionROM(VER0, 0xE6, 1, PHI1, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xE6, 1, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xE6, 1, PHI2, MI_T_LOAD);
    loadInstructionROM(VER0, 0xE6, 1, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xE6, 1, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xE6, 1, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xE6, 2, PHI1, MI_T_OUT);
    loadInstructionROM(VER0, 0xE6, 2, PHI1, MI_RB_DB);
    loadInstructionROM(VER0, 0xE6, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xE6, 2, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xE6, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xE6, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xE6, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xE6, 4, PHI2, MI_IR_LOAD);
    
    // INC abs (EE) - ZC - 6 Cycles
    cu.instructions[0xEE].set("INC", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0xEE, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xEE, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xEE, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xEE, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xEE, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xEE, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xEE, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xEE, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xEE, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xEE, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0xEE, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xEE, 2, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0xEE, 2, PHI1, MI_ALU_X_B);
    loadInstructionROM(VER0, 0xEE, 2, PHI1, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xEE, 2, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xEE, 2, PHI2, MI_T_LOAD);
    loadInstructionROM(VER0, 0xEE, 2, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xEE, 2, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xEE, 2, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xEE, 3, PHI1, MI_T_OUT);
    loadInstructionROM(VER0, 0xEE, 3, PHI1, MI_RB_DB);
    loadInstructionROM(VER0, 0xEE, 3, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xEE, 3, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0xEE, 5, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xEE, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xEE, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xEE, 5, PHI2, MI_IR_LOAD);
       
    // INX (E8) - NZ
    cu.instructions[0xE8].set("INX", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xE8, 0, PHI1, MI_X_OUT);
    loadInstructionROM(VER0, 0xE8, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xE8, 0, PHI1, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xE8, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xE8, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xE8, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xE8, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xE8, 0, PHI2, MI_X_LOAD);
    loadInstructionROM(VER0, 0xE8, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xE8, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xE8, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xE8, 1, PHI2, MI_IR_LOAD);
    
    // INY (C8) - NZ
    cu.instructions[0xC8].set("INY", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xC8, 0, PHI1, MI_Y_OUT);
    loadInstructionROM(VER0, 0xC8, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xC8, 0, PHI1, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xC8, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xC8, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xC8, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xC8, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xC8, 0, PHI2, MI_Y_LOAD);
    loadInstructionROM(VER0, 0xC8, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xC8, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xC8, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xC8, 1, PHI2, MI_IR_LOAD);
    
    
    // JMP abs (4c) - 3 cycles
    cu.instructions[0x4c].set("JMP", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0x4c, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x4c, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x4c, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x4c, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x4c, 0, PHI2, MI_T_LOAD);    // Load low byte of jump address into T register
    loadInstructionROM(VER0, 0x4c, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x4c, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x4c, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x4c, 1, PHI2, MI_ALU_X_B);    // Load high byte of jump address into ALU's latch
    loadInstructionROM(VER0, 0x4c, 2, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x4c, 2, PHI1, MI_PCH_LOAD);    
    loadInstructionROM(VER0, 0x4c, 2, PHI2, MI_T_OUT);
    loadInstructionROM(VER0, 0x4c, 2, PHI2, MI_RB_WB);
    loadInstructionROM(VER0, 0x4c, 2, PHI2, MI_PCL_LOAD);
    loadInstructionROM(VER0, 0x4c, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x4c, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x4c, 3, PHI2, MI_IR_LOAD);
    
    
    // JSR (20) - 6 cycles
    cu.instructions[0x20].set("JSR", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0x20, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x20, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x20, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x20, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x20, 0, PHI2, MI_T_LOAD);    // Load low byte of jump address into T register
    loadInstructionROM(VER0, 0x20, 1, PHI1, MI_PC_INC);  // Takes PC to two bytes past the JSR instruction
    loadInstructionROM(VER0, 0x20, 1, PHI2, MI_PCHR_OUT); // Push HB of PC
    loadInstructionROM(VER0, 0x20, 1, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x20, 1, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x20, 2, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x20, 2, PHI2, MI_PCLR_OUT);  // Push LB of PC
    loadInstructionROM(VER0, 0x20, 2, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x20, 2, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x20, 3, PHI1, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x20, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x20, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x20, 3, PHI2, MI_ALU_X_B);    // Load high byte of jump address into ALU's latch
    loadInstructionROM(VER0, 0x20, 4, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x20, 4, PHI1, MI_PCH_LOAD);    
    loadInstructionROM(VER0, 0x20, 4, PHI2, MI_T_OUT);
    loadInstructionROM(VER0, 0x20, 4, PHI2, MI_RB_WB);
    loadInstructionROM(VER0, 0x20, 4, PHI2, MI_PCL_LOAD);
    loadInstructionROM(VER0, 0x20, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x20, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x20, 5, PHI2, MI_IR_LOAD);
    
    // LDA zpg (A5) - NZ
    cu.instructions[0xA5].set("LDA", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0xA5, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA5, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA5, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA5, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA5, 0, PHI2, MI_ADL_LOAD);
   // loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA5, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xA5, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA5, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA5, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA5, 2, PHI2, MI_IR_LOAD);
   
    // LDA # (A9) - NZ
    cu.instructions[0xA9].set("LDA", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0xA9, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA9, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0xA9, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA9, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA9, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA9, 1, PHI2, MI_IR_LOAD);
  
    // LDA abs (AD) - NZ
    cu.instructions[0xAD].set("LDA", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0xAD, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xAD, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xAD, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xAD, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xAD, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xAD, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xAD, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xAD, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xAD, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xAD, 1, PHI2, MI_ADH_LOAD);
   // loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xAD, 2, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xAD, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xAD, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xAD, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xAD, 3, PHI2, MI_IR_LOAD);
    
    // LDA zpg, X (B5) - NZ
    cu.instructions[0xB5].set("LDA", InstructionDef.ZERO_PAGE_X);
    loadInstructionROM(VER0, 0xB5, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_PCL_OUT);  // Operand (Zero Page address of data)
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_ALU_Y_2);      // Load DB into ALU-Y (ALU_Y_2, ALU_Y_3)
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_X_OUT);      // Load X into ALU-X (X_OUTPUT, ALU_X_A)
    loadInstructionROM(VER0, 0xB5, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xB5, 1, PHI1, MI_ALU_OUT);  // Output the result of DB + X
    loadInstructionROM(VER0, 0xB5, 1, PHI1, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_ADL_OUT); 
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_ADH_00);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xB5, 1, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0xB5, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xB5, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xB5, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xB5, 2, PHI2, MI_IR_LOAD);
    
    // LDA abs, X (BD) - NZ
    cu.instructions[0xBD].set("LDA", InstructionDef.ABSOLUTE_X);
    
    // Version 0 - No carry from LB + X 
    loadInstructionROM(VER0, 0xBD, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_PCL_OUT);    // Operand 1 (Low Address Byte)
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_ALU_Y_2);    // Load DB into ALU-Y (ALU_Y_2, ALU_Y_3)
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_X_OUT);      // Load X into ALU-X (X_OUTPUT, ALU_X_A)
    loadInstructionROM(VER0, 0xBD, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0xBD, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER0, 0xBD, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER0, 0xBD, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xBD, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER0, 0xBD, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xBD, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xBD, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_ADH_OUT); 
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xBD, 2, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xBD, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xBD, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xBD, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xBD, 3, PHI2, MI_IR_LOAD);
    
    // Version 1 - Carry from LB + X (Add 1 cycle)
    loadInstructionROM(VER1, 0xBD, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER1, 0xBD, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER1, 0xBD, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0xBD, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER1, 0xBD, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0xBD, 1, PHI2, MI_ALU_X_B);    // Load HB into ALU
    loadInstructionROM(VER1, 0xBD, 1, PHI2, MI_ALU_FORCE_CARRY);    // Set Carry In
    loadInstructionROM(VER1, 0xBD, 2, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0xBD, 2, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_ADH_OUT); 
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_DB_WB);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER1, 0xBD, 2, PHI2, MI_A_LOAD);
    loadInstructionROM(VER1, 0xBD, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0xBD, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0xBD, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0xBD, 4, PHI2, MI_IR_LOAD);
   
   
    /* LDA (ind, X) - LDA ($LL,X)     operand is zeropage address; effective address is word in (LL + X, LL + X + 1), inc. without carry: C.w($00LL + X)
       6 cycles
       e.g. LDA ($20, X)  // X = 04   Mem 0024 = 51 (LB); Mem 0025 = C0 (HB) so data for Acc is in C051
       
       1.1 PCL/PCH out to Address Bus; ALU load DB (B-Input) into LHS; X out onto R-Bus; ALU load R (A-Input) into RHS
       1.2 X out onto R-Bus; ALU load R (A-Input) into X and internal register into Y
       2.1 ALU out onto W-Bus; Load into ADL
       2.2 ADL out and ADH = 0x00 onto Address Bus; DB-WB; Load W-Bus into T 
       3.1 ALU load internal register into Y (and 00 into X implicit); Force ALU Carry In (OP + X + 1)
       3.2 ALU out onto W-Bus; Load into ADL
       4.1 ADL out and ADH = 0x00 onto Address Bus; ALU load DB (B-Input) into X;
       4.2 ALU out onto W-Bus; Load W-Bus into ADL
       5.1 T out onto R-Bus; RB-WB; Load W-Bus into ADH
       5.2 ADL & ADH out onto Address Bus; DB-WB; Load S.Z, S.N (ALU); Load A from W-Bus; Inc PC; End of instruction
    */
    // LDA (ind, X) (A1) - NZ
    cu.instructions[0xA1].set("LDA", InstructionDef.INDIRECT_X);
    loadInstructionROM(VER0, 0xA1, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_ALU_X_B);    // Load value at PC into ALU X side
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_X_OUT);
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0xA1, 0, PHI2, MI_ALU_Y_3);    // Load X register value into ALU Y side
    loadInstructionROM(VER0, 0xA1, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xA1, 1, PHI1, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xA1, 1, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xA1, 1, PHI2, MI_ADH_00);
    loadInstructionROM(VER0, 0xA1, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA1, 1, PHI2, MI_T_LOAD);  // Load value at MEM[PC] + X
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_ALU_X_B);    // Load value at PC into ALU X side
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_X_OUT);
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0xA1, 2, PHI1, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER0, 0xA1, 2, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xA1, 2, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xA1, 3, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xA1, 3, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xA1, 3, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xA1, 3, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0xA1, 3, PHI2, MI_T_OUT);
    loadInstructionROM(VER0, 0xA1, 3, PHI2, MI_RB_WB);
    loadInstructionROM(VER0, 0xA1, 3, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA1, 4, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xA1, 5, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA1, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA1, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA1, 5, PHI2, MI_IR_LOAD);
    
    /*
      LDA (ind), Y - B1 - LDA ($LL),Y     operand is zeropage address; effective address is word in (LL, LL + 1) incremented by Y with carry: C.w($00LL) + Y
      5 or 6 cycles depending on carry
      e.g. LDA ($20), Y // Y = 04; Mem 0020 = 51 (LB); Mem 0021 = C0 (HB) so data for Acc is in $C051 + 04 = $C055
      // Version 0 - No carry from LB + Y
      1.1 - PCL/PCH out to Address Bus; DB-WB; Load into ADL;
      1.2 - ADL out and ADH = 0x00 to Address Bus; ALU load DB (B-Input) into LHS; Y out onto R-Bus; ALU load R (A-Input) into RHS
      2.1 - ALU out to W-Bus; Load into T Register // Stores low-byte of target address + Y
      2.2 - Increment ADL
      3.1 - ADL out and ADH = 0x00 to Address Bus; ALU load DB (B-Input) into LHS;
      3.2 - ALU out onto W-Bus; Load W-Bus into ADH
      4.1 - T out onto R-Bus; RB-WB; Load W-Bus into ADL
      4.2 - ADL & ADH out onto Address Bus; DB-WB; Load S.Z, S.N (ALU); Load A from W-Bus; Inc PC; End of instruction
      
      // Version 1 - Carry from LB + Y
      2.x - As Ver 0
      3.1 - As Ver 0 but set ALU Carry In
      3.2 - As Ver 0
      4.x - As Ver 0 but move Inc PC and End of Instruction to 5.x
    */
    // LDA (ind), Y (B1) - NZ - 5 cycles
    cu.instructions[0xB1].set("LDA", InstructionDef.INDIRECT_Y);
    loadInstructionROM(VER0, 0xB1, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xB1, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xB1, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xB1, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xB1, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_ALU_X_B);    // Load value at AD into ALU X side
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_Y_OUT);
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0xB1, 1, PHI1, MI_ALU_Y_3);    // Load Y register value into ALU Y side
    loadInstructionROM(VER0, 0xB1, 1, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xB1, 1, PHI2, MI_T_LOAD);
    loadInstructionROM(VER0, 0xB1, 2, PHI1, MI_ADL_INC);
    loadInstructionROM(VER0, 0xB1, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xB1, 2, PHI2, MI_ADH_00);
    loadInstructionROM(VER0, 0xB1, 2, PHI2, MI_ALU_X_B);
    loadInstructionROM(VER0, 0xB1, 3, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xB1, 3, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0xB1, 3, PHI2, MI_T_OUT);
    loadInstructionROM(VER0, 0xB1, 3, PHI2, MI_RB_WB);
    loadInstructionROM(VER0, 0xB1, 3, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xB1, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xB1, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xB1, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xB1, 4, PHI2, MI_IR_LOAD);
    
    // Version 1 - Carry from LB + Y - 6 cycles
    loadInstructionROM(VER1, 0xB1, 1, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER1, 0xB1, 1, PHI2, MI_T_LOAD);
    loadInstructionROM(VER1, 0xB1, 2, PHI1, MI_ADL_INC);
    loadInstructionROM(VER1, 0xB1, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER1, 0xB1, 2, PHI2, MI_ADH_00);
    loadInstructionROM(VER1, 0xB1, 2, PHI2, MI_ALU_X_B);
    loadInstructionROM(VER1, 0xB1, 2, PHI2, MI_ALU_FORCE_CARRY);
    loadInstructionROM(VER1, 0xB1, 3, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0xB1, 3, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER1, 0xB1, 3, PHI2, MI_T_OUT);
    loadInstructionROM(VER1, 0xB1, 3, PHI2, MI_RB_WB);
    loadInstructionROM(VER1, 0xB1, 3, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_ADH_OUT);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_DB_WB);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER1, 0xB1, 4, PHI1, MI_A_LOAD);
    loadInstructionROM(VER1, 0xB1, 5, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0xB1, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0xB1, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0xB1, 5, PHI2, MI_IR_LOAD);
    
    // LDX # (A2) - NZ - 2 cycles
    cu.instructions[0xA2].set("LDX", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0xA2, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA2, 0, PHI2, MI_X_LOAD);
    loadInstructionROM(VER0, 0xA2, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA2, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA2, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA2, 1, PHI2, MI_IR_LOAD);
    
    // LDX zpg (A6) - NZ - 2 cycles
    cu.instructions[0xA6].set("LDX", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0xA6, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA6, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA6, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA6, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA6, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_ADH_00);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_DB_WB);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_X_LOAD);
    loadInstructionROM(VER0, 0xA6, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA6, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA6, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA6, 1, PHI2, MI_IR_LOAD);
    
    // LDY # (A0) - NZ - 2 cycles
    cu.instructions[0xA0].set("LDY", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0xA0, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA0, 0, PHI2, MI_Y_LOAD);
    loadInstructionROM(VER0, 0xA0, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA0, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA0, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA0, 1, PHI2, MI_IR_LOAD);
    
    // LSR A (4A) - NZC - 2 cycles
    cu.instructions[0x4A].set("LSR A", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x4A, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x4A, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x4A, 0, PHI1, MI_ALU_SR); 
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x4A, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x4A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x4A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x4A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x4A, 1, PHI2, MI_IR_LOAD);
    
    // NOP (EA) - 2 cycles
    cu.instructions[0xEA].set("NOP", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xEA, 1, PHI1, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xEA, 1, PHI1, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xEA, 1, PHI1, MI_IR_LOAD);
    loadInstructionROM(VER0, 0xEA, 1, PHI2, MI_PC_INC);
    
    // ORA # (09) - NZ - 2 cycles
    cu.instructions[0x09].set("ORA", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0x09, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_ALU_Y_2);
    loadInstructionROM(VER0, 0x09, 0, PHI2, MI_ALU_Y_3);  // AND
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x09, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x09, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x09, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x09, 1, PHI2, MI_IR_LOAD);
    
    
    // PHA (48) - 3 cycles
    cu.instructions[0x48].set("PHA", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x48, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x48, 0, PHI1, MI_S_OUT);
    loadInstructionROM(VER0, 0x48, 0, PHI1, MI_RB_DB);
    loadInstructionROM(VER0, 0x48, 0, PHI2, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x48, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x48, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x48, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x48, 2, PHI2, MI_IR_LOAD);
    
    // PHP (08) - 3 cycles
    cu.instructions[0x08].set("PHP", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x08, 0, PHI1, MI_P_OUT);
    loadInstructionROM(VER0, 0x08, 0, PHI1, MI_S_OUT);
    loadInstructionROM(VER0, 0x08, 0, PHI1, MI_RB_DB);
    loadInstructionROM(VER0, 0x08, 0, PHI2, MI_S_COUNT);  // Count down
    loadInstructionROM(VER0, 0x08, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x08, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x08, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x08, 2, PHI2, MI_IR_LOAD);
    
    // PLA (68) - NZ - 4 cycles
    cu.instructions[0x68].set("PLA", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x68, 0, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_DB_WB);  // Count up
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x68, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x68, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x68, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x68, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x68, 3, PHI2, MI_IR_LOAD);
    
    // PLP (28) - 4 cycles
    cu.instructions[0x28].set("PLP", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x28, 0, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x28, 0, PHI2, MI_S_OUT);
    loadInstructionROM(VER0, 0x28, 0, PHI2, MI_DB_WB); 
    loadInstructionROM(VER0, 0x28, 0, PHI2, MI_P_LOAD);
    loadInstructionROM(VER0, 0x28, 3, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x28, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x28, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x28, 3, PHI2, MI_IR_LOAD);
    
    // ROL A (2A) - NZC - 2 cycles
    cu.instructions[0x6A].set("ROL A", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x2A, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x2A, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x2A, 0, PHI1, MI_ALU_Y_1);
    loadInstructionROM(VER0, 0x2A, 0, PHI1, MI_ALU_Y_3);  // Loading the same value into both sides of the ALU shifts left
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x2A, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x2A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x2A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x2A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x2A, 1, PHI2, MI_IR_LOAD);
    
    // ROR A (6A) - NZC - 2 cycles
    cu.instructions[0x6A].set("ROR A", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x6A, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x6A, 0, PHI1, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x6A, 0, PHI1, MI_ALU_SR);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_ALU_OUT);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_A_LOAD);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x6A, 0, PHI2, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x6A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x6A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x6A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x6A, 1, PHI2, MI_IR_LOAD);
    
    // RTI (40) - 6 cycles
    cu.instructions[0x40].set("RTI", InstructionDef.IMPLIED);   
    loadInstructionROM(VER0, 0x40, 0, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x40, 0, PHI2, MI_S_OUT);    // Output to ADL and implies ADH = 01 to access stack page
    loadInstructionROM(VER0, 0x40, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x40, 0, PHI2, MI_P_LOAD);   // Restore status register
    loadInstructionROM(VER0, 0x40, 1, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x40, 1, PHI2, MI_S_OUT);    // Output to ADL and implies ADH = 01 to access stack page
    loadInstructionROM(VER0, 0x40, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x40, 1, PHI2, MI_PCL_LOAD); // Set LB of return address
    loadInstructionROM(VER0, 0x40, 2, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x40, 2, PHI2, MI_S_OUT);    // Output to ADL and implies ADH = 01 to access stack page
    loadInstructionROM(VER0, 0x40, 2, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x40, 2, PHI2, MI_PCH_LOAD); // Set LB of return address
    loadInstructionROM(VER0, 0x40, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x40, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x40, 5, PHI2, MI_IR_LOAD);
    
    // RTS (60) - 6 cycles
    cu.instructions[0x60].set("RTS", InstructionDef.IMPLIED);   
    loadInstructionROM(VER0, 0x60, 0, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x60, 0, PHI2, MI_S_OUT);    // Output to ADL and implies ADH = 01 to access stack page
    loadInstructionROM(VER0, 0x60, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x60, 0, PHI2, MI_PCL_LOAD); // Store LB of return address
    loadInstructionROM(VER0, 0x60, 1, PHI1, MI_S_COUNT);  // Count up
    loadInstructionROM(VER0, 0x60, 1, PHI2, MI_S_OUT);    // Output to ADL and implies ADH = 01 to access stack page
    loadInstructionROM(VER0, 0x60, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x60, 1, PHI2, MI_PCH_LOAD);
    loadInstructionROM(VER0, 0x60, 2, PHI1, MI_PC_INC);
    //loadInstructionROM(VER0, 0x60, 2, PHI1, MI_PC_INC); // DO WE NEED THIS TOO?
    loadInstructionROM(VER0, 0x60, 5, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x60, 5, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x60, 5, PHI2, MI_IR_LOAD);
    
    // SBC # (E9) - NVZC
    cu.instructions[0xE9].set("SBC", InstructionDef.IMMEDIATE);
    loadInstructionROM(VER0, 0xE9, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_ALU_X_A);  // ACC
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_ALU_Y_0);  // B input (DB)
    loadInstructionROM(VER0, 0xE9, 0, PHI2, MI_ALU_Y_1);  // B input (DB)
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_P_V_LOAD);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0xE9, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xE9, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xE9, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xE9, 1, PHI2, MI_IR_LOAD);
    
    // SEC (38) - C=1
    cu.instructions[0x38].set("SEC", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x38, 0, PHI1, MI_P_C_LOAD);
    loadInstructionROM(VER0, 0x38, 0, PHI1, MI_P_FROM_IR5);
    loadInstructionROM(VER0, 0x38, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x38, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x38, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x38, 1, PHI2, MI_IR_LOAD);
    
    
    // SEI (78) - I=1
    cu.instructions[0x78].set("SEI", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x78, 0, PHI1, MI_P_I_LOAD);
    loadInstructionROM(VER0, 0x78, 0, PHI1, MI_P_FROM_IR5);
    loadInstructionROM(VER0, 0x78, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x78, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x78, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x78, 1, PHI2, MI_IR_LOAD);
    
    // STA zpg (85) - 3 cycles
    cu.instructions[0x85].set("STA", InstructionDef.ZERO_PAGE);
    loadInstructionROM(VER0, 0x85, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x85, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x85, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x85, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x85, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0x85, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x85, 1, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x85, 1, PHI2, MI_ADH_00);
    loadInstructionROM(VER0, 0x85, 1, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x85, 1, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x85, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x85, 2, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x85, 2, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x85, 2, PHI2, MI_IR_LOAD);
    
    // STA abs (8D) - 4 cycles
    cu.instructions[0x8D].set("STA", InstructionDef.ABSOLUTE);
    loadInstructionROM(VER0, 0x8D, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x8D, 0, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x8D, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x8D, 0, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x8D, 0, PHI2, MI_ADL_LOAD);
    loadInstructionROM(VER0, 0x8D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x8D, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x8D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x8D, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x8D, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0x8D, 2, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x8D, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x8D, 2, PHI2, MI_ADH_OUT);
    loadInstructionROM(VER0, 0x8D, 2, PHI2, MI_A_OUT);
    loadInstructionROM(VER0, 0x8D, 2, PHI2, MI_RB_DB);
    loadInstructionROM(VER0, 0x8D, 3, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x8D, 3, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x8D, 3, PHI2, MI_IR_LOAD);
    
    // STA abs, X (9D) - 5 cycles
    cu.instructions[0x9D].set("STA", InstructionDef.ABSOLUTE_X);
    
    // Version 0 - No carry from LB + X 
    loadInstructionROM(VER0, 0x9D, 0, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_PCL_OUT);    // Operand 1 (Low Address Byte)
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_ALU_Y_2);    // Load DB into ALU-Y (ALU_Y_2, ALU_Y_3)
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_ALU_Y_3);
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_X_OUT);      // Load X into ALU-X (X_OUTPUT, ALU_X_A)
    loadInstructionROM(VER0, 0x9D, 0, PHI2, MI_ALU_X_A);
    loadInstructionROM(VER0, 0x9D, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER0, 0x9D, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER0, 0x9D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x9D, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER0, 0x9D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x9D, 1, PHI2, MI_DB_WB);
    loadInstructionROM(VER0, 0x9D, 1, PHI2, MI_ADH_LOAD);
    loadInstructionROM(VER0, 0x9D, 2, PHI1, MI_ADL_OUT);
    loadInstructionROM(VER0, 0x9D, 2, PHI1, MI_ADH_OUT); 
    loadInstructionROM(VER0, 0x9D, 2, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0x9D, 2, PHI1, MI_RB_DB);
    loadInstructionROM(VER0, 0x9D, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x9D, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x9D, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x9D, 4, PHI2, MI_IR_LOAD);
    
    // Version 1 - Carry from LB + X
    loadInstructionROM(VER1, 0x9D, 1, PHI1, MI_ALU_OUT);    // Output the result of DB + X...
    loadInstructionROM(VER1, 0x9D, 1, PHI1, MI_ADL_LOAD);   // and load back into the ADL Register
    loadInstructionROM(VER1, 0x9D, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x9D, 1, PHI2, MI_PCL_OUT);    // Operand 2 (High Address Byte)
    loadInstructionROM(VER1, 0x9D, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x9D, 1, PHI2, MI_ALU_X_B);    // Load HB into ALU
    loadInstructionROM(VER1, 0x9D, 1, PHI2, MI_ALU_FORCE_CARRY);    // Set Carry In
    loadInstructionROM(VER1, 0x9D, 2, PHI1, MI_ALU_OUT);
    loadInstructionROM(VER1, 0x9D, 2, PHI1, MI_ADH_LOAD);
    loadInstructionROM(VER1, 0x9D, 2, PHI2, MI_ADL_OUT);
    loadInstructionROM(VER1, 0x9D, 2, PHI2, MI_ADH_OUT); 
    loadInstructionROM(VER1, 0x9D, 2, PHI2, MI_A_OUT);
    loadInstructionROM(VER1, 0x9D, 2, PHI2, MI_RB_DB);
    loadInstructionROM(VER1, 0x9D, 4, PHI1, MI_PC_INC);
    loadInstructionROM(VER1, 0x9D, 4, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER1, 0x9D, 4, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER1, 0x9D, 4, PHI2, MI_IR_LOAD);
    
    // TAX (AA) - NZ
    cu.instructions[0xAA].set("TAX", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xAA, 0, PHI1, MI_X_LOAD);
    loadInstructionROM(VER0, 0xAA, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xAA, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xAA, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xAA, 1, PHI2, MI_IR_LOAD);
    
    // TAY (A8) - NZ
    cu.instructions[0xA8].set("TAY", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_A_OUT);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xA8, 0, PHI1, MI_Y_LOAD);
    loadInstructionROM(VER0, 0xA8, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xA8, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xA8, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xA8, 1, PHI2, MI_IR_LOAD);
    
    // TXA (8A) - NZ
    cu.instructions[0x8A].set("TXA", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_X_OUT);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x8A, 0, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x8A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x8A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x8A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x8A, 1, PHI2, MI_IR_LOAD);
    
    // TSX (BA) - NZ
    cu.instructions[0xBA].set("TSX", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_SR_OUT);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0xBA, 0, PHI1, MI_X_LOAD);
    loadInstructionROM(VER0, 0xBA, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0xBA, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0xBA, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0xBA, 1, PHI2, MI_IR_LOAD);
    
    // TXS (9A) - NZ
    cu.instructions[0x9A].set("TXS", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_X_OUT);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x9A, 0, PHI1, MI_S_LOAD);
    loadInstructionROM(VER0, 0x9A, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x9A, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x9A, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x9A, 1, PHI2, MI_IR_LOAD);
     
    // TYA (98) - NZ
    cu.instructions[0x98].set("TYA", InstructionDef.IMPLIED);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_Y_OUT);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_RB_WB);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_P_Z_LOAD);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_P_N_LOAD);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_P_FROM_ALU);
    loadInstructionROM(VER0, 0x98, 0, PHI1, MI_A_LOAD);
    loadInstructionROM(VER0, 0x98, 1, PHI1, MI_PC_INC);
    loadInstructionROM(VER0, 0x98, 1, PHI2, MI_PCL_OUT);
    loadInstructionROM(VER0, 0x98, 1, PHI2, MI_PCH_OUT);
    loadInstructionROM(VER0, 0x98, 1, PHI2, MI_IR_LOAD);
    
  }

 /*
  ABS, X/Y Instructions with additional cycle if crossing a page boundary
  
  ADC (7D, 79)
  AND (3D, 39)
  CMP (DD, D9)
  EOR (5D, 59)
  LDA (BD, D9)
  LDX (    BE)
  LDY (BC)
  ORA (1D, 19)
  SBC (FD, F9)
 */ 
}
