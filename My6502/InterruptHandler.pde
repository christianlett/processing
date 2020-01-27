class HardwareInterrupt {
  String int_name;
  IOPin pin;
  boolean previous_pin_state;
  boolean maskable;
  int trigger;
  int inst_version;
  boolean pending;
  boolean in_progress;
  
  static final int LEVEL_TRIGGERED = 0;
  static final int EDGE_TRIGGERED = 1;
  
  HardwareInterrupt(String name, IOPin pin, boolean maskable, int trigger, int brk_version) {
    int_name = name;
    this.pin = pin;
    this.previous_pin_state = false;
    this.maskable = maskable;
    this.trigger = trigger;
    this.inst_version = brk_version;
    this.pending = false;
    this.in_progress = false;
  }
  
  void update(boolean ready, boolean i_flag) {
    // Is pin enabled or is interrupt in progress?
    
    String log = int_name + ": ";
    if(!pending && !in_progress) {
      log += "!pending && !in_progress; ";
      if(pin.enabled()) {
        log += "pin.enabled; ";
        if((trigger == EDGE_TRIGGERED && previous_pin_state == false) || trigger == LEVEL_TRIGGERED) {
          log += "triggered; ";
          if((maskable && i_flag == false) || !maskable) {
            log += "pending! ";
            pending = true;
          }
        } 
      }
    }
    
    if(pending && ready) {
      pending = false;
      in_progress = true;
      log += "in progress! ";
    }
    
    if(in_progress) {
      instruction_reg.value = 0x00;  // Force BRK for reset
      control_unit.inst_version = inst_version;
      log += "IN PROGRESS!";
      if(!ready) {
        // The BRK instruction has completed
        in_progress = false;
        log += "ENDED";
      }
    }
    //println(log);
  }
}
