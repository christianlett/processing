class Register extends Component {
  int default_value;
 
  // Registers can have only one input bus but can output to multiple buses
  Bus input_bus;
  Bus output_bus_1;
  Bus output_bus_2;
  
  ControlBit load_enable;
  ControlBit output_enable_1;
  ControlBit output_enable_2;
  
  int active_phase;
   
  Register(String name, int active_phase) {
    default_value = 0;
    this.display_name = name;
    this.active_phase = active_phase;
      
    load_enable = new ControlBit();
    output_enable_1 = new ControlBit();
    output_enable_2 = new ControlBit();
     
    // Assume we want to display this register and display its value in decimal as well as hex & binary
    show = true;  
    show_decimal = true;
    
    reset();
  }
 

  void setDefaultValue(int def) {
      default_value = def;
  }
  
  void reset() {
    value = default_value;
  }
  
  void setInput(Bus bus) {
    this.input_bus = bus;
  }
  
  void setOutput1(Bus bus) {
    this.output_bus_1 = bus;
  }
  
  void setOutput2(Bus bus) {
    this.output_bus_2 = bus;
  }
  
  // A nicer looking way of setting the output if a single output bus (like most)
  void setOutput(Bus bus) {
    this.output_bus_1 = bus;
  }
  //<>// //<>//
   
  void update(Clock c) {
    if(output_enable_1.enabled()) {
     // println("Register " + display_name + " Output Enable active - outputting value " + str(value) + " onto bus " + output_bus_1.display_name);
      output_bus_1.setDriver(this);
    }
    
    if(output_enable_2.enabled()) {
      //println("Register " + display_name + " Output Enable active - outputting value " + str(value) + " onto bus " + output_bus_1.display_name);
      output_bus_2.setDriver(this);
    }
    
    if(c.currentState() != Clock.STATE_RISING) return; 
    
    if(load_enable.enabled()) {
      //println("Register " + display_name + " Load Enable active - loading value " + str(input_bus.getBusValue()) + " from bus " + input_bus.display_name + " into register");
      this.value = input_bus.getBusValue();
    }
    
  }
  
  void display(float x, float y) {
    String dec_value = str(show_twos_comp ? byte(this.value) : this.value);
    textFont(font_disp);
    fill(0, 0, 128);
    
    textAlign(LEFT, TOP);
    text(this.display_name, x, y);
    
    textFont(font_disp);
    fill(0);
    text(hex(this.value, 2), x + 100, y);
    
    text(binary(this.value, 8), x + 150, y);
    
    if(show_decimal) {
      textAlign(RIGHT, TOP);
      text(dec_value, x + 290, y);
      textAlign(LEFT, TOP);
    }
    
    if(!load_enable.enabled()) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text("L", x + 310, y);
    
    
    if(!output_enable_1.enabled()) {
      fill(128);
      textFont(font_disp);
    } else {
      fill(255, 0, 0);
      textFont(font_disp);
    }
    text((output_bus_2 == null) ? "O" : "O1", x + 340, y);
    
    if(output_bus_2 != null) {
      if(!output_enable_2.enabled()) {
        fill(128);
        textFont(font_disp);
      } else {
        fill(255, 0, 0);
        textFont(font_disp);
      }
      text("O2", x + 370, y);
    }
  }
  
}

// CounterRegister
// Represents a register that can self-count (Program Counter and Stack), both up and down
class CounterRegister extends Register {
  ControlBit count_enable;
  ControlBit count_direction; // ~up/down
  
  CounterRegister cascaded_register;
  
  CounterRegister(String display_name, int active_phase) {
    super(display_name, active_phase);
    cascaded_register = null;
    
    count_enable = new ControlBit();
    count_direction = new ControlBit(); // true = UP; false = DOWN
    
    reset();
  }
  
  void reset() {
    super.reset();
  }
  
  
  
  // Returns true if carrying a bit over
  boolean countUp() {
    value++;
    if(value > 255) {
      value = 0;
      return true;
    }
    return false;
  }
  
  // Returns true if carrying a bit over
  boolean countDown() {
    value--;
    if(value < 0) {
      value = 255;
      return true;
    }
    return false;
  }
  
  boolean count() {
    if(count_direction.enabled()) {
      return countDown();
    }
    return countUp();
  }
  
  void update(Clock c) {
    super.update(c);
    
    if(c.currentState() != Clock.STATE_RISING) return;
    
    if(count_enable.enabled()) {
      if(count() && cascaded_register != null) {
          cascaded_register.count();
      }
    }
  }
}


/*
Status Register Control Inputs:
Set C
Set Z
Set I
Set V
Set N
From Bus (WB0-7)
From ALU (ALU-C, ALU-V, WB-Z)
From IR5 (Comparator intercepts CLV [10111000] and /output is ANDed with IR5 to give equivalent IR5 input)
Output Enable
*/

class StatusRegister extends Register { 
  ControlBit load_c, load_z, load_i, load_v, load_n;
  ControlBit load_from_wb, load_from_alu, load_from_ir;
  
  boolean alu_c;
  boolean alu_v;
   
 
  StatusRegister() {
    super("STATUS", Clock.PHI1);
    load_c = new ControlBit();
    load_z = new ControlBit();
    load_i = new ControlBit();
    load_v = new ControlBit();
    load_n = new ControlBit();
    load_from_wb = new ControlBit();
    load_from_alu = new ControlBit(); 
    load_from_ir = new ControlBit();
    reset();
  }
  
  
  
  boolean getBit(int bit) {
    int x = 1 << bit;
    return ((this.value & x) == x);
  }
 
  // Used by the ControlUnit
  boolean getC() {
    return getBit(0);
  }
  
  boolean getZ() {
    return getBit(1);
  }
  
  boolean getV() {
    return getBit(6);
  }
  
  boolean getN() {
    return getBit(7);
  }
 
  
  void setBit(int bit, boolean val) {
    int x = 0;
    if(val == true) {
      x = 1;
    }
    this.value ^= (-x ^ this.value) & (1 << bit);
  }
   
  void reset() {
    this.value = 0x30;
  }
  
  void update(Clock c) {
    super.update(c);

    if(c.currentState() != Clock.STATE_RISING) return;
    
    int input_bus_value = input_bus.getBusValue();
    if(load_from_wb.enabled()) {
      //value = input_bus_value;
      if(load_c.enabled()) {
        setBit(0, (input_bus_value & 0x01) == 0x01);
      }
      if(load_z.enabled()) {
        setBit(1, (input_bus_value & 0x02) == 0x02);
      }
      if(load_i.enabled()) {
        setBit(2, (input_bus_value & 0x04) == 0x04);
      }
      if(load_v.enabled()) {
        setBit(6, (input_bus_value & 0x40) == 0x40);
      }
      if(load_n.enabled()) {
        setBit(7, (input_bus_value & 0x80) == 0x80);
      }
    }
    if(load_from_alu.enabled()) {
     // println("(STATUS REG - Load from ALU) CU Step: " + control_unit.step + "; clock phase: " + c.activePhase());
      if(load_c.enabled()) {
        setBit(0, alu.c_out);
      }
      if(load_z.enabled()) {
        setBit(1, (input_bus_value & 0xFF) == 0);         // All bits are zero - handled in hardware via an 8-input NOR gate
      }
      if(load_v.enabled()) {
      //  println("Load V is enabled!");
        setBit(6, alu.v_out);
      }
      if(load_n.enabled()) {
        setBit(7, (input_bus_value & 0x80) == 0x80);
      }
      // A unique case - sets the interrupt-disable flag for IRQ and BRK interrupts
      if(load_i.enabled()) {
        setBit(2, true);
      }
    }
    if(load_from_ir.enabled()) {
      // Bit 5 of the instruction register - used only for set and clear instructions
      boolean ir5 = control_unit.getIR5();
      if(load_c.enabled()) {
        setBit(0, ir5);
      }
      if(load_i.enabled()) {
        setBit(2, ir5);
      }
      if(load_v.enabled()) {
        setBit(6, ir5);
      }
      if(load_n.enabled()) {
        setBit(7, ir5);
      } 
    }
  }
  
  void display(float x, float y) {
    textFont(font_disp);
    fill(0, 0, 128);
    
    textAlign(LEFT, TOP);
    text("STATUS", x, y);
    
    textFont(font_disp);
    fill(0);
    text(hex(this.value, 2), x + 100, y);
    
    String status_str = "NV-BDIZC";
    for(int i = 0; i<8; i++) {
      if(getBit(7-i) == false) {
        textFont(font_disp);
        fill(128);
      } else {
        textFont(font_disp);
        fill(255, 0, 0);
      }
      text(status_str.charAt(i), x + 150 + (i * 11), y);
    }
  }
}
