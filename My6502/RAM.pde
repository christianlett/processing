class RAM extends Component {
  int data[];
  
  Bus address_bus_low;    // #--00 - #--FF  -  READ ONLY
  Bus address_bus_high;   // #00-- - #FF--  -  READ ONLY
  Bus data_bus;           //                -  READ/WRITE
  
  int breakpoint;
  int last_addr;
  
  RAM(int num_pages) {
    int mem_size = num_pages * 256;
    data = new int[mem_size];
    display_name = "RAM";
    
    // Zero out the RAM
    int x = 0;
    for(int i=0; i<mem_size; i++) {
      data[i] = 0x00;  // Fill with zeros!
      x++;
      if(x > 255) x = 0;
    }
    
    breakpoint = -99;
    last_addr = 0;
    
    reset();
  }
  
  void reset() {
    // Do not zero out RAM here!
  }
 
  StringList disassemble(int num_instructions,  int mem_start) {
   // int display_offset = 4; // Show this many instructions prior to the currently executing one
    int inst_count = 0;
    // Assume mem_start contains a valid opcode
    int cur_mem = mem_start;
    StringList disassembly = new StringList();
    // Get instructions before currently executing
    //for(int i=0; i < display_offset; i++) {
      
    //}
    while(inst_count < num_instructions) {
      int opcode = data[cur_mem];
      InstructionDef inst = control_unit.instructions[opcode];
      disassembly.append("0x" + hex(cur_mem, 4) + "   " + inst.disassemble(data, cur_mem));
      cur_mem += inst.arguments + 1;
      inst_count++;
    }
    return disassembly;
  }
  
  void update(Clock c) {
    // Create a 16-bit address by combining the values on the lower and upper address busses
    if(address_bus_high.getBusValue() == FLOATING || address_bus_low.getBusValue() == FLOATING) { return; }
    int addr = address_bus_high.getBusValue() * 256 + address_bus_low.getBusValue();
    last_addr = addr;
    
    if(addr == breakpoint) {
      c.clockStop();
    }
    
    //      _____
    // Read/Write
    if(io_rw.enabled()) { //control_unit.read) {
      value = data[addr];
      data_bus.setDriver(this);
    } else {
      int data_value = data_bus.getBusValue();
      if(data_value != FLOATING) {
        data[addr] = data_value;
      }
        
    }
  }
  
  int getCurrentAddress() {
    int cur_addr = -1;
    if(address_bus_high.getBusValue() != FLOATING && address_bus_low.getBusValue() != FLOATING) { 
      cur_addr = address_bus_high.getBusValue() * 256 + address_bus_low.getBusValue();
    }
    return cur_addr;
  }
  
  boolean hitBreakpoint() {
    return (getCurrentAddress() == breakpoint);
  }
  
  char charAtAddr(int addr) {
    return char(this.data[addr]);
  }
  
  void display(float x, float y, float mouse_x, float mouse_y, int mouse_button, boolean auto_navigate, boolean show_disassembly) {
    textFont(font_disp);
    
    stroke(255, 0, 0);
    strokeWeight(1);
    
    y += 4;
    
    fill(0, 0, 128);
    for(int i=0; i<16; i++) {
      text(hex(i, 2), x + 100 + (i * 38), y + 0);
    }
    
    int cur_addr = getCurrentAddress();
    if(cur_addr == -1) {
      cur_addr = last_addr;
      stroke(255, 0, 0, 128);
    }
    
    if(auto_navigate) {
      ram_page_display = cur_addr / 256; 
    }
    
    if(show_disassembly) {
      fill(0, 0, 128);
      text("DISASSEMBLY", x + 728, y);
    }
    y += 20;
    int row = 0;
    int col = 0;
    for(int i=0; i<256; i++) {
      fill(0);
      int addr = i + ram_page_display * 256;
      if(col == 0) {
        textFont(font_disp);
        fill(0, 0, 128);
        text(hex(addr, 4), x, y + row * 20);
      }
      textFont(font_disp);
      fill(0);
      text(hex(this.data[addr], 2), x + 100 + (col * 38), y + row * 20);
      if(!show_disassembly) {
        text(char(this.data[addr]), x + 719 + (col * 13), y + row * 20);
      }    
      // Draw a box around the currently accessed memory address
      if(addr == cur_addr) {
        noFill();
        rect(x + 98 + (col * 38), y - 2 + row * 20, 27, 17);
        if(!show_disassembly) {
          rect(x + 718 + (col * 13), y - 2 + row * 20, 14, 17);
        }
      }
      
      // Draw a box around the memory address by the mouse pointer
      if((mouse_x > (x + 98 + (col * 38)) && mouse_x < (x + 98 + ((col + 1) * 38)) && mouse_y > (y - 2 + row * 20) && mouse_y < (y - 2 + (row + 1) * 20)) || addr == breakpoint) {
        if(mouse_button == LEFT) {
          breakpoint = addr;
        } else if(mouse_button == RIGHT && addr == breakpoint) {
          breakpoint = -99;
        }
        
        if(addr == breakpoint) {
          noStroke();
          fill(0, 192, 0, 128);
        } else {
          stroke(0, 255, 128);
          noFill();
        }
        rect(x + 98 + (col * 38), y - 2 + row * 20, 27, 17);
        if(!show_disassembly) {
          rect(x + 718 + (col * 13), y - 2 + row * 20, 14, 17);
        }
        stroke(255, 0, 0);
      }
      
      col++;
      if(col > 15) {
        row++;
        col = 0;
      }
    }
    if(show_disassembly) {
      int addr = control_unit.cur_inst_address;
      StringList dis = disassemble(16, addr);
      int line = 0;
      fill(255, 0, 0);
      for(String inst : dis) {
        text(inst, x + 728, y + line * 20);
        fill(0);
        line++;
      }
    }
  }
}
