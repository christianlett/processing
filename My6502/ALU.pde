/*
   A = a_input_bus.value
   B = b_input_bus.value
   
   3 2 1 0  Operation Hex
   =======================
   0 0 0 0  0x00      0x0
   1 1 1 1  0xFF      0xF
   1 0 1 0  A         0xA
   0 1 0 1  !A        0x5
   1 1 0 0  B         0xC
   0 0 1 1  !B        0x3
   1 1 1 0  A | B     0xE
   1 0 0 0  A & B     0x8
   0 1 1 0  A ^ B     0x6
  
   These operands will output to Y.
   We'll need four control bits to achieve this.
  
   X will either be 0, A or B:
   
   3 2 1 0  Operation
   ==================
   0 0 0 0  0x00
   1 0 1 0  A
   1 1 0 0  B
   
   So we only need two control bits for the X side, since bit-0 is always 0 and bit 3 is always 1 if either bit 1 or 2 are 1 (b3 = b1 | b2)
   
   X and Y go to the Adder circuit along with the current Carry bit (C) to generate the result
   Inst X      Y      C    Res
  
   ADC  A      B      0    A + B
   AND  0      A & B  0    A & B
   ASL  A      A      0    <-A    - Accumulator
   ASL  B      B      0    <-B    - Memory
   CMP
   
   DEC  B      0xFF   0    B - 1  
   DEx  A      0xFF   0    A - 1
   EOR  0      A ^ B  0    A ^ B
   INC  B      0      1    B + 1
   INx  A      0      1    A + 1
   LDx  0      B      0    B      - Possibly not required?
   ORA  0      A | B  0    A | B
   ROL
   SBC  A      !B     0    A - B
  
*/

class ALU extends Component {
  int display_value;
  Bus a_input_bus;
  Bus b_input_bus;
  Bus output_bus;
  
  //Register b_input_reg;
  
  StatusRegister status_reg;
  
  boolean sr_enable;
  ControlBit output_enable;
  ControlBit logic_op_x_a;
  ControlBit logic_op_x_b;
  ControlBit logic_op_y_0;
  ControlBit logic_op_y_1;
  ControlBit logic_op_y_2;
  ControlBit logic_op_y_3;
  ControlBit carry_in;
  ControlBit force_carry;
  ControlBit rotate;
  
  // These will be a mini 4-bit register that's part of the ALU and linked directly to the status register
  boolean c_out, v_out;
  boolean x_n_out, y_n_out; // These two just report if either input is negative (bit 7 == 1)
  
 // int latched_value;
        
  ALU() {
    display_name = "ALU";
  
    output_enable   = new ControlBit();
    logic_op_x_a    = new ControlBit();
    logic_op_x_b    = new ControlBit();
    logic_op_y_0    = new ControlBit();
    logic_op_y_1    = new ControlBit();
    logic_op_y_2    = new ControlBit();
    logic_op_y_3    = new ControlBit();
    carry_in        = new ControlBit();
    force_carry     = new ControlBit();
    rotate          = new ControlBit();
    reset();
  }
  
  void reset() {
  }
  
  // x can be a, b or 0
  int x_operation() {
    int x_oper = (logic_op_x_a.enabled() ? 2 : 0) + (logic_op_x_b.enabled() ? 4: 0);
    if(x_oper > 0) {
      x_oper += 8;
    }
    
    // Going to represent this as a switch-case statement but in hardware it will be a 8 dual 4:1 multiplexers!
    switch(x_oper) {
      case 0x0:
        return 0x0;
      case 0xA:
        return a_input_bus.getBusValue();
      case 0xC:
        return b_input_bus.getBusValue();
      default:
        return 0x0;
    }
  }
  
  int y_operation() {
    int a = a_input_bus.getBusValue();
    int b = b_input_bus.getBusValue();
    
    int y_oper = (logic_op_y_0.enabled() ? 1 : 0) + (logic_op_y_1.enabled() ? 2 : 0) + (logic_op_y_2.enabled() ? 4 : 0) + (logic_op_y_3.enabled() ? 8 : 0);
    
    sr_enable = false;
    
    switch(y_oper) {
      case 0x0:
        return 0x0;
      case 0x3:
        return 0xFF - b; // Just negating b using ~b returns the two's compliment, which messes up subtraction calculations later. e.g. b = 1; ~b = -2, not 254 as required for correct carry over 
      case 0x5:
        return 0xFF - a; // See note above; multiplexer logic will achieve the same goal
      case 0x6:
        return a ^ b;
      case 0x8:
        return a & b;
      case 0xA:
        return a;
      case 0xC:
        return b;
      case 0xE:
        return a | b;
      case 0xF:
        return 0xFF;
      default:
        return 0x0;
    }
  }
 
   
  void update(Clock c) {
    int x_op = x_operation();
    int y_op = y_operation();
    
    // This is the carry flag from the Status Register (P)
    int p_carry = bool2int(carry_in.enabled());
    
    // This logic specifies whether the P.carry or the force carry is used in the adder
    // If rotating (ROL, ROR), this value will be ZERO
    int add_carry = bool2int((carry_in.enabled() | force_carry.enabled()) & !rotate.enabled());
    
    // Always run x and y through the adder
    int res = x_op + y_op + add_carry;
    
    // Shift and Rotate
    if(c.currentState() == Clock.STATE_RISING) {
      if(sr_enable == true) {
        // Shift and Rotate Right
        int lsb = (res & 0x1);
        res = res >> 1;
        if(rotate.enabled()) {
          res |= (lsb << 0x8);  // Move previous LSB to the carry position
          res |= (p_carry << 0x7);
        }
      } else {
       // Shift & Rotate Left
       if(rotate.enabled()) {
         res |= p_carry;
       }
      }
    }
    
    // Ensure we stay in the 8-bit domain
    display_value = res & 0xFF;
    
    if(output_enable.enabled()) {
      output_bus.setDriver(this);
    }    
    
    // Latch the value
    if(c.currentState() == Clock.STATE_RISING) {
      value = display_value;
       
      // Set the internal ALU status register
      c_out = ((res & 0x100) == 0x100);                            // Carrying the MSB over
      v_out = (((~(x_op ^ y_op) & (x_op ^ res)) & 0x80) == 0x80);  // Overflow
      x_n_out = (x_op & 0x80) == 0x80;
      y_n_out = (y_op & 0x80) == 0x80;
    }
  }

  void display(float x, float y) {
    int x_op = x_operation();
    int y_op = y_operation();
  
    textFont(font_disp);
    fill(0, 0, 128);
   
    textAlign(LEFT, TOP);
    text("LHS", x, y);
    text("RHS", x, y + 20);
    text("CARRY IN", x, y + 40);
    text("VALUE", x, y + 60);
    text("LATCHED", x, y + 80);
    text("FLGS OUT", x, y + 100);
    
    textFont(font_disp);
    fill(0);
 
    text(hex(x_op, 2), x + 100, y);
    text(binary(x_op, 8), x + 150, y);
    
    text(hex(y_op, 2), x + 100, y + 20);
    text(binary(y_op, 8), x + 150, y + 20);
    
    text(force_carry.enabled() || carry_in.enabled() ? "01" : "00", x + 100, y + 40); 
    
    text(hex(display_value, 2), x + 100, y + 60);
    text(binary(display_value, 8), x + 150, y + 60);
    
    text(hex(value, 2), x + 100, y + 80);
    text(binary(value, 8), x + 150, y + 80);
    
    textAlign(RIGHT, TOP);
    text(str(show_twos_comp ? byte(x_op) : x_op), x + 300, y);
    text(str(show_twos_comp ? byte(y_op) : y_op), x + 300, y + 20);
    text(str(show_twos_comp ? byte(display_value) : display_value), x + 300, y + 60);
    text(str(show_twos_comp ? byte(value) : value), x + 300, y + 80);
    
    textAlign(LEFT, TOP);
    if(!c_out) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text("C", x + 100, y + 100);
    
    if(!v_out) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text("V", x + 120, y + 100);
    
    if(!x_n_out) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text("LN", x + 140, y + 100);
    
    if(!y_n_out) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text("RN", x + 170, y + 100);
    
    fill(0);
    
    
  }
  
}
