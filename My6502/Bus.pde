final int FLOATING = 999;

/*
NEED NEW BUS DRIVER COMPONENTS - ONE FOR ADDRESS LOW (0xFA..0xFF); ONE FOR ADDRESS HIGH (0x00, 0x01, 0xFF)

ADL DRIVER
- Driven by "external" NMI, RES, IRQ inputs (all ACTIVE LOW on HARDWARE but ACTIVE HIGH in SOFTWARE)
- Driven by CW_INTVEC_HI and CW_INTVEC_LO control wires
  - D0 driven directly by CW_INTVEC_HI
  - D1 driven by NMI || IRQ || BRK - NOTE FOR HARDWARE THIS WILL BE !(~NMI && (!(~IRQ && !BRK)))
  - D2 driven by RES || IRQ || BRK - NOTE FOR HARDWARE THIS WILL BE !(~RES && (!(~IRQ && !BRK)))
  - D3..D7 all set HIGH
  - OE driven by CW_INTVEC_HI || CW_INTVEC_LO (NOTE FOR HARDWARE THIS WILL BE !(CW_INTVEC_HI || CW_INTVEC_LO) as ~OE pins on 74HC541 are ACTIVE LOW

ADH DRIVER
- Driven by CW_ADH_00, CW_ADH_01 and CW_ADH_FF
  - D0, D2..D7 all driven by CW_ADH_FF
  - D1 driven by CW_ADH_01 || CW_ADH_FF
  - OE driven by CW_ADH_00 || CW_ADH_01 || CW_ADH_FF (NOTE FOR HARDWARE THIS WILL BE !(CW_ADH_00 || CW_ADH_01 || CW_ADH_FF) as ~OE pins on 74HC541 are ACTIVE LOW

*/

class BusDriver extends Component {
  Bus output_bus;
  
  void setOutput(Bus b) {
    output_bus = b;
  }
  
}

class ADHDriver extends BusDriver {
  ControlBit adh_00, adh_01, adh_FF;
  
  ADHDriver() {
    adh_00 = new ControlBit();
    adh_01 = new ControlBit();
    adh_FF = new ControlBit();
  }
  
  void update() {
    value = 0;
    if(adh_01.enabled()) {
      value = 0x01;
    } else if(adh_FF.enabled()) {
      value = 0xFF;
    }
       
    if(adh_00.enabled() || adh_01.enabled() || adh_FF.enabled()) {
      output_bus.setDriver(this);
    }
  }
}

class ADLDriver extends BusDriver {
  ControlBit int_vec_lo, int_vec_hi;
  ControlBit int_brk, int_irq, int_nmi, int_res;
  
  ADLDriver(ControlBit irq, ControlBit nmi, ControlBit res) {
    int_vec_lo = new ControlBit();
    int_vec_hi = new ControlBit();
    
    int_brk = new ControlBit();
    
    int_irq = irq;
    int_nmi = nmi;
    int_res = res;
  }
  
  void update() {
    value = 0xF8; // 11111000;
    value |= bool2int(int_vec_hi.enabled());  // Bit 0
    value |= (bool2int(int_brk.enabled() | int_irq.enabled() | int_nmi.enabled()) << 1); // Bit 1
    value |= (bool2int(int_brk.enabled() | int_irq.enabled() | int_res.enabled()) << 2); // Bit 2
    
    if(int_vec_lo.enabled() || int_vec_hi.enabled()) {
      output_bus.setDriver(this);
    }
  }
}


class Bus {
  String display_name;
  
  Component driver;
  
  boolean show_decimal;
  
  Bus(String name) {
    display_name = name;
    show_decimal = false;
  }
  
  void setDriver(Component d) {
   // println("Bus " + display_name + " Driven by Component " + d.display_name);
    driver = d;
  }
  
  void clearDriver() {
    //println("Bus " + display_name + " Driver Cleared");
    driver = null;
  }
   
  int getBusValue() {
    if(driver == null) {
      return FLOATING; 
    }
    return driver.value;
  }
  
  void display(float x, float y) {
    int value = getBusValue();
    String dec_value = str(show_twos_comp ? byte(value) : value);
   
    textFont(font_disp);
    fill(0, 0, 128);
    
    textAlign(LEFT, TOP);
    text(this.display_name, x, y);
    
    textFont(font_disp);
    fill(0);
    if(value != FLOATING) {
      text(hex(value, 2), x + 100, y);
      text(binary(value, 8), x + 150, y);
      if(show_decimal) {
        textAlign(RIGHT, TOP);
        text(dec_value, x + 300, y);
      }
    } else {
      text("--", x + 100, y);
      text("--------", x + 150, y);
      if(show_decimal) {
        textAlign(RIGHT, TOP);
        text("---", x + 300, y);
      }
    }
  }
}
