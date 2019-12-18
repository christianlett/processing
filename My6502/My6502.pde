PFont font_head;
PFont font_disp;
PFont font_screen;

int ram_pages = 256;
int ram_page_display = 0;

boolean show_screen;

boolean show_twos_comp;
boolean auto_mem_display;  // Automatically jump to the currently accessed memory page
boolean show_disassembly;

Clock clock;

ControlUnit control_unit;

ArrayList<Register> registers;
ArrayList<Bus> buses;
ArrayList<Buffer> buffers;

RAM ram;

Register instruction_reg;
Register a_reg;
Register x_reg;
Register y_reg;
CounterRegister stack_reg;
CounterRegister pcl;
CounterRegister pch;
Register add_high_reg;
CounterRegister add_low_reg;
Register t_reg;

StatusRegister stat;

Buffer data_to_write;
Buffer read_to_data;
Buffer read_to_write;

ALU alu;

Bus db, rb, wb, adhb, adlb;

ADHDriver adh_driver;
ADLDriver adl_driver;

// External IO Pins
IOPin io_irq, io_nmi, io_res, io_rw;

ControlBit ir_brk; // BRK instruction

//Screen screen;

void settings() {
  size(1024, 700);
}

void setup() {
  frameRate(100);
  
  // Fonts
  font_head = loadFont("ShareTechMono-Regular-14.vlw"); //DialogInput.bold-20.vlw");
  font_disp = loadFont("ShareTechMono-Regular-20.vlw");//"DialogInput.plain-20.vlw");
  font_screen = loadFont("AndaleMono-12.vlw");
  
  show_screen = false;
  show_twos_comp = false;
  auto_mem_display = true;
  show_disassembly = true;
  
  clock = new Clock(100, 2); // 100ms period, 2 phases
  
  
  // Create buses
  db = new Bus("DATA");    // Data Bus (EXTERNAL TO CPU)
  db.show_decimal = true;
  rb = new Bus("READ");    // Read Bus
  wb = new Bus("WRITE");   // Write Bus
  adlb = new Bus("ABL");   // Address Bus Low (EXTERNAL TO CPU)
  adhb = new Bus("ABH");   // Address Bus High (EXTERNAL TO CPU)
  
  registers = new ArrayList<Register>();
  buses = new ArrayList<Bus>();
  buffers = new ArrayList<Buffer>();
  
  
  ram = new RAM(ram_pages);
  ram.data_bus = db;
  ram.address_bus_low = adlb;
  ram.address_bus_high = adhb;
   
 
  // Set reset vector - currently to $1000
  ram.data[0xFFFC] = 0x00;
  ram.data[0xFFFD] = 0x10;
  
  // BRK/IRQ vector
  ram.data[0xFFFE] = 0x50;
  ram.data[0xFFFF] = 0x20;
  
  
  // TEST PROGRAMS BEGIN
  // 01 - Fibonacci Sequence
  ram.data[0x1000] = 0xA9;  // LDA # (A9);
  ram.data[0x1001] = 0x00;
  ram.data[0x1002] = 0x8D;  // STA abs
  ram.data[0x1003] = 0x00;
  ram.data[0x1004] = 0x20;  // 0x2000
  ram.data[0x1005] = 0xA9;  // LDA # (A9);
  ram.data[0x1006] = 0x01;
  ram.data[0x1007] = 0x8D;  // STA abs
  ram.data[0x1008] = 0x01;
  ram.data[0x1009] = 0x20;  // 0x2000
  ram.data[0x100A] = 0xA2;  // LDX # (A2);
  ram.data[0x100B] = 0x01;  // 0x01
  ram.data[0x100C] = 0xA0;  // LDY # (A0);
  ram.data[0x100D] = 0x00;  // 0x00
  ram.data[0x100E] = 0x18;  // CLC
  ram.data[0x100F] = 0x79;  // ADC abs, Y
  ram.data[0x1010] = 0x00;  
  ram.data[0x1011] = 0x20;  // 0x2000 + x
  ram.data[0x1012] = 0xE8;  // INX
  ram.data[0x1013] = 0x9D;  // STA abs, X
  ram.data[0x1014] = 0x00;  
  ram.data[0x1015] = 0x20;  // 0x2000 + x
  ram.data[0x1016] = 0xC8;  // INY
  ram.data[0x1017] = 0x4C;  // JMP
  ram.data[0x1018] = 0x0E;  
  ram.data[0x1019] = 0x10;  // 0x1004
  
 
  // TEST PROGRAMS END
  
  // Create registers
  instruction_reg = new Register("IR", Clock.PHI1);
  instruction_reg.setInput(db);
  instruction_reg.show_decimal = false;
  
  // External IO Pins
  io_irq = new IOPin("IRQ", true);
  io_nmi = new IOPin("NMI", true);
  io_res = new IOPin("RES", true);
  io_rw = new IOPin("READ", "WRITE");
  
  ir_brk = new ControlBit();
  
  // Control Unit
  control_unit = new ControlUnit(instruction_reg);
  
  control_unit.connectComponentControlInput(CW_IR_LOAD, instruction_reg.load_enable);
  
  // Create constant line drivers
  adh_driver = new ADHDriver();
  adh_driver.setOutput(adhb);
  control_unit.connectComponentControlInput(CW_ADH_00, adh_driver.adh_00);
  control_unit.connectComponentControlInput(CW_ADH_01, adh_driver.adh_01);
  control_unit.connectComponentControlInput(CW_ADH_FF, adh_driver.adh_FF);
  
  adl_driver = new ADLDriver(io_irq, io_nmi, io_res);
  adl_driver.setOutput(adlb);
  control_unit.connectComponentControlInput(CW_INT_BRK, adl_driver.int_brk);
  control_unit.connectComponentControlInput(CW_INTVEC_LO, adl_driver.int_vec_lo);
  control_unit.connectComponentControlInput(CW_INTVEC_HI, adl_driver.int_vec_hi);
 
  a_reg = new Register("A", Clock.PHI1);
  a_reg.setInput(wb);
  a_reg.setOutput(rb);
  control_unit.connectComponentControlInput(CW_A_LOAD, a_reg.load_enable);
  control_unit.connectComponentControlInput(CW_A_OUT, a_reg.output_enable_1);
  
  stack_reg = new CounterRegister("STACK", Clock.PHI1);
  stack_reg.setInput(wb);
  stack_reg.setOutput1(adlb);
  stack_reg.setOutput2(rb);
 // stack_reg.setDefaultValue(0xFF);  // Goes top to bottom
  stack_reg.show_decimal = false;
  stack_reg.count_direction.setState(true); // Default to count down
  control_unit.connectComponentControlInput(CW_S_LOAD, stack_reg.load_enable);
  control_unit.connectComponentControlInput(CW_S_OUT, stack_reg.output_enable_1);
  control_unit.connectComponentControlInput(CW_SR_OUT, stack_reg.output_enable_2);
  control_unit.connectComponentControlInput(CW_S_COUNT, stack_reg.count_enable);
  control_unit.connectComponentControlInput(CW_S_COUNT_DIR, stack_reg.count_direction);
  
  add_high_reg = new Register("ADH", Clock.PHI1);
  add_high_reg.setInput(wb);
  add_high_reg.setOutput(adhb);
  add_high_reg.show_decimal = false;
  control_unit.connectComponentControlInput(CW_ADH_LOAD, add_high_reg.load_enable);
  control_unit.connectComponentControlInput(CW_ADH_OUT, add_high_reg.output_enable_1);
  
  add_low_reg = new CounterRegister("ADL", Clock.PHI1);
  add_low_reg.setInput(wb);
  add_low_reg.setOutput(adlb);
  add_low_reg.show_decimal = false;
  add_low_reg.count_direction.setState(false);  // Always count up
  control_unit.connectComponentControlInput(CW_ADL_LOAD, add_low_reg.load_enable);
  control_unit.connectComponentControlInput(CW_ADL_OUT, add_low_reg.output_enable_1);
  control_unit.connectComponentControlInput(CW_ADL_INC, add_low_reg.count_enable);
  
  x_reg = new Register("X", Clock.PHI1);
  x_reg.setInput(wb);
  x_reg.setOutput(rb);
  //x_reg.setDefaultValue(69);
  control_unit.connectComponentControlInput(CW_X_LOAD, x_reg.load_enable);
  control_unit.connectComponentControlInput(CW_X_OUT, x_reg.output_enable_1);
  
  y_reg = new Register("Y", Clock.PHI1);
  y_reg.setInput(wb);
  y_reg.setOutput(rb);
  control_unit.connectComponentControlInput(CW_Y_LOAD, y_reg.load_enable);
  control_unit.connectComponentControlInput(CW_Y_OUT, y_reg.output_enable_1);
 
  stat = new StatusRegister();
  stat.setInput(wb);
  stat.setOutput(rb);
  control_unit.connectComponentControlInput(CW_P_LOAD, stat.load_enable);
  control_unit.connectComponentControlInput(CW_P_C_LOAD, stat.load_c);
  control_unit.connectComponentControlInput(CW_P_Z_LOAD, stat.load_z);
  control_unit.connectComponentControlInput(CW_P_I_LOAD, stat.load_i);
  control_unit.connectComponentControlInput(CW_P_V_LOAD, stat.load_v);
  control_unit.connectComponentControlInput(CW_P_N_LOAD, stat.load_n);
  control_unit.connectComponentControlInput(CW_P_FROM_WB, stat.load_from_wb);
  control_unit.connectComponentControlInput(CW_P_FROM_ALU, stat.load_from_alu);
  control_unit.connectComponentControlInput(CW_P_FROM_IR5, stat.load_from_ir);
  control_unit.connectComponentControlInput(CW_P_OUT, stat.output_enable_1);
  control_unit.p = stat;
 
  
  pcl = new CounterRegister("PCL", Clock.PHI1);
  pcl.setInput(wb);
  pcl.setOutput1(adlb);
  pcl.setOutput2(rb);
  pcl.count_direction.setState(false);  // Always count up
  pcl.show_decimal = false;
  control_unit.connectComponentControlInput(CW_PCL_OUT, pcl.output_enable_1);
  control_unit.connectComponentControlInput(CW_PCLR_OUT, pcl.output_enable_2);
  control_unit.connectComponentControlInput(CW_PCL_LOAD, pcl.load_enable);
  control_unit.connectComponentControlInput(CW_PC_INC, pcl.count_enable);
 
  pch = new CounterRegister("PCH", Clock.PHI1);
  pch.setInput(wb);
  pch.setOutput1(adhb);
  pch.setOutput2(rb);
  pch.count_direction.setState(false);  // Always count up
  pch.show_decimal = false;
  control_unit.connectComponentControlInput(CW_PCH_OUT, pch.output_enable_1);
  control_unit.connectComponentControlInput(CW_PCHR_OUT, pch.output_enable_2);
  control_unit.connectComponentControlInput(CW_PCH_LOAD, pch.load_enable);
  
  pcl.cascaded_register = pch;
    
  t_reg = new Register("T", Clock.PHI1);
  t_reg.setInput(wb);
  t_reg.setOutput(rb);
  control_unit.connectComponentControlInput(CW_T_LOAD, t_reg.load_enable);
  control_unit.connectComponentControlInput(CW_T_OUT, t_reg.output_enable_1);
  
  // ALU
  alu = new ALU();
  alu.a_input_bus = rb;
  alu.b_input_bus = db;
  alu.output_bus = wb;
  alu.status_reg = stat;
  control_unit.connectComponentControlInput(CW_ALU_X_A, alu.logic_op_x_a);
  control_unit.connectComponentControlInput(CW_ALU_X_B, alu.logic_op_x_b);
  control_unit.connectComponentControlInput(CW_ALU_Y_0, alu.logic_op_y_0);
  control_unit.connectComponentControlInput(CW_ALU_Y_1, alu.logic_op_y_1);
  control_unit.connectComponentControlInput(CW_ALU_Y_2, alu.logic_op_y_2);
  control_unit.connectComponentControlInput(CW_ALU_Y_3, alu.logic_op_y_3);
  control_unit.connectComponentControlInput(CW_ALU_CIN, alu.carry_in);
  control_unit.connectComponentControlInput(CW_ALU_FORCE_CARRY, alu.force_carry);
  control_unit.connectComponentControlInput(CW_ALU_OUT, alu.output_enable);
  control_unit.connectComponentControlInput(CW_ALU_ROTATE, alu.rotate);
  
  
  registers.add(instruction_reg);
  registers.add(a_reg);
  registers.add(x_reg);
  registers.add(y_reg);
  registers.add(t_reg);
  registers.add(stack_reg);
  registers.add(pch);
  registers.add(pcl);
  registers.add(add_high_reg);
  registers.add(add_low_reg);
  registers.add(stat);
  
  buses.add(db);
  buses.add(rb);
  buses.add(wb);
  buses.add(adhb);
  buses.add(adlb);
 
  data_to_write = new Buffer(db, wb);
  control_unit.connectComponentControlInput(CW_DB_WB, data_to_write.open);
  
  read_to_data = new Buffer(rb, db);
  control_unit.connectComponentControlInput(CW_RB_DB, read_to_data.open);
  
  read_to_write = new Buffer(rb, wb);
  control_unit.connectComponentControlInput(CW_RB_WB, read_to_write.open);
  
  buffers.add(data_to_write);
  buffers.add(read_to_data);
  buffers.add(read_to_write);
  
  //screen = new Screen();
  
  reset();
}

void reset() {
  for(Register r : registers) {
    r.reset();
  }
  control_unit.reset();
  pcl.value = ram.data[0xFFFC];
  pch.value = ram.data[0xFFFD];
}

void keyPressed() {
  if(key == ' ')  {
    clock.setRunMode(Clock.STEP);
  } else if(key == 'c' || key == 'C') {
    clock.setRunMode(Clock.RUNNING);
  } else if(key == 'a' || key == 'A') {
    auto_mem_display = !auto_mem_display;
  } else if(key == 'd' || key == 'D') {
    show_disassembly = !show_disassembly;
  } else if(key == 'R') {
    reset();
  } else if(key == 'i' || key == 'I') {
    // IRQ
    io_irq.toggleState();
  } else if(key == 'n' || key == 'N') {
    // NMI
    io_nmi.toggleState();
  } else if(key == 's' || key == 'S') {
    show_screen = !show_screen;
  } else if(key == '2') {
    show_twos_comp = !show_twos_comp;
  } else if(keyCode == DOWN) {
    ram_page_display++;
    if(ram_page_display >= ram_pages) {
      ram_page_display = ram_pages - 1;
    }
  } else if (keyCode == UP) {
    ram_page_display--;
    if(ram_page_display < 0) {
      ram_page_display = 0;
    }
  } else if(keyCode == LEFT) {
    ram_page_display = 0;   
  } else if(keyCode == RIGHT) {
    ram_page_display = ram_pages - 1;
  }
}

void drawComponentFrame(float x, float y, float w, float h, String label) {
  y -= 16;
  
  noFill();
  stroke(145);
  strokeWeight(1);
  rect(x - 5, y + 4, w, h);
  
  fill(192);
  noStroke();
  rect(x + 3, y, label.length() * 8.5, 5);
   
  textFont(font_head);
  textAlign(LEFT, TOP);
  fill(0);
  text(label, x + 5, y);
}



void draw() {
  background(192);
  
  noStroke();
  fill(185);
  rect(0, 0, width, 40);
  
  stroke(0);
  strokeWeight(2);
    
  clock.drawClock(20, 20);
  
  textFont(font_head);
  textAlign(LEFT, CENTER);
  if(clock.running()) {
    fill(255, 0, 0);
    text("Run", 60, 20);
  } else {
    fill(128);
    text("Step", 60, 20);
  }
  
  if(show_twos_comp) {
    fill(255, 0, 0);
  } else {
    fill(128);
  }  
  text("2s", 120, 20);
  
  if(auto_mem_display) {
    fill(255, 0, 0);
  } else {
    fill(128);
  }
  //textFont(font_head);
  textAlign(CENTER, CENTER);
  rectMode(CORNERS);
  text("Auto Nav", 160, -10, 200, 50);
  
  rectMode(CORNER);
  
  if(show_disassembly) {
    fill(255, 0, 0);
  } else {
    fill(128);
  }
  textAlign(LEFT, CENTER);
  text("Dis", 230, 20);
  
  // At the end of a clock half-cycle (phase), reset the buses so they are all "high impedence"
  // These will get set again during register, RAM and ALU updates if being driven
  if(clock.currentState() == Clock.STATE_HL) {
    for(Bus b : buses) {
      b.clearDriver();
    }
  }
 
  // Update all components in the following order:
  // 1) Control Unit 
  // 2) Registers 
  // 3) Bus Drivers
  // 4) ALU
  // 5) RAM
  // 6) Buffers
  control_unit.update(clock);
  
  for(Register r : registers) {
    r.update(clock);
  }
  
  adl_driver.update();
  adh_driver.update();
  
  alu.update(clock);
  
  ram.update(clock);
  
  for(Buffer b : buffers) {
    b.update();
  }  
  
   
  drawComponentFrame(20, 60, 402, 252, "REGISTERS");
  int ri = 0;
  for(Register r : registers) {
    if(r.show) {
        r.display(20, 60 + (ri * 20));
        ri++;
      }
  }
  
  drawComponentFrame(20, 325, width - 33, 350, "RAM");
  ram.display(20, 320, mouseX, mouseY, mouseButton, auto_mem_display, show_disassembly);
  
  drawComponentFrame(430, 60, 310, 111, "BUSES");
  int bi = 0;
  for(Bus b : buses) {
    b.display(430, 60 + (bi * 20));
    bi++;
  }
  
  data_to_write.display(425, 67, 107);
  read_to_write.display(425, 87, 107);
  read_to_data.display(425, 67, 87);
  
  drawComponentFrame(430, 180, 310, 132, "ALU");
  alu.display(430, 180);
  
  drawComponentFrame(748, 60, 263, 111, "CONTROL UNIT");
  control_unit.display(748, 60);
  
  drawComponentFrame(748, 180, 263, 132, "I/O PINS");
  io_irq.display(748, 180);
  io_nmi.display(748, 220);
  io_res.display(748, 260);
  io_rw.display(849, 180);
 
  clock.update();
  
}


int bool2int(boolean b) {
  return b ? 1 : 0;
}
