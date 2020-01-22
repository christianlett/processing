

class Clock {
  int clock_period;
  int num_phases;
  int active_phase;
  int clock_state;
  int run_mode;
  
  boolean clock_stopping;
  
  private int clock_high_time;
  private int clock_low_time;
  private int cur_time;
  private int clock_pulse_start;
  
  final static int PHI1 = 1;
  final static int PHI2 = 2;
  
  
  // CONSTANTS
  final static float PHASE_HIGH_RATIO = 0.90; // Sets how long a phase is high to avoid overlap. Should be less than 1 
 
  // Modes
  final static int STOPPED  = -1;
  final static int RUNNING  =  0;
  final static int STEP     =  1;
  
  // Clock States
  final static int STATE_RISING = 1;  // Low-to-High Transition (Rising Edge)
  final static int STATE_HI     = 2;  // Clock is High
  final static int STATE_FALLING     = 3;  // High-to-Low Transition (Falling Edge)
  final static int STATE_LO     = 4;  // Clock is Low
 
  Clock(int period, int phases) {
    clock_period = period;
    num_phases = phases;
    active_phase = PHI1;
    clock_high_time = int(clock_period * (PHASE_HIGH_RATIO / num_phases));
    clock_low_time = (clock_period - (clock_high_time * num_phases)) / num_phases;
    
    clock_state = STATE_LO;
    
    clock_stopping = false;
    
    run_mode = STOPPED;
  }
  
  void setRunMode(int new_mode) {
    if(run_mode == STOPPED) {
      // Clock is stopped so run mode can be set directly to the new mode
      run_mode = new_mode;
      return;
    }
    if(run_mode == RUNNING) {
      // Clock can only be stopped if running
      clock_stopping = true;
    }
    // If in step mode, do nothing as the mode will reset to stopped when the step is complete
  }
  
   
  // Only valid during run mode
  void clockStop() {
    if(run_mode == RUNNING) {
      clock_stopping = true;
    }
  }
  
  void update() {
    if(run_mode == STOPPED) { 
     // print("_"); 
      return; 
    };
     
    cur_time = millis();
    
    if(clock_state == STATE_LO) {
     // print("_");
      int t = cur_time - clock_pulse_start;
      if(t > clock_low_time) {
        clock_state = STATE_RISING;
        
      //  print(active_phase);
      //  print("/");
      }
      return;
    } 
    if(clock_state == STATE_RISING) {
      clock_state = STATE_HI;
      clock_pulse_start = millis();
      return;
    }
    if(clock_state == STATE_HI) {
     // print("-");
      int t = cur_time - clock_pulse_start;
      if(t > clock_high_time) {
        clock_state = STATE_FALLING;
        
     //  print(active_phase);
     //  print("\\");
      }
      return;
    }
    if(clock_state == STATE_FALLING) {
      clock_state = STATE_LO;
      clock_pulse_start = millis();
    }
    if(run_mode == STEP) {
      run_mode = STOPPED; 
    } else {
      // Running
      if(clock_stopping) {
        run_mode = STOPPED;
        clock_stopping = false;
      }
    }
    active_phase++;
  
    
    if(active_phase > num_phases) {
      active_phase = PHI1;
    }
  }
  
  int activePhase() {
    return active_phase;
  }
  
  int currentState() {
    return clock_state;
  }
  
  boolean running() {
    return run_mode == RUNNING;
  }
  
  private void drawClockPhase(float x, float y, boolean on) {
    stroke(0);
    strokeWeight(2);
    if(on) {
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    rectMode(CENTER);
    rect(x, y, 10, 10);
  }
  
  void drawClock(float x, float y) {
    for(int i=1; i<=num_phases; i++) {
      drawClockPhase(x + (20 * (i-1)), y, active_phase == i && clock_state == STATE_HI);
    }
  }
  
}
