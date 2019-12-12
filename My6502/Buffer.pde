class Buffer {
  ControlBit open;
  
  Bus input_bus, output_bus;
  
  Buffer(Bus input, Bus output) {
    input_bus = input;
    output_bus = output;
    open = new ControlBit();
  }
  
  void update() {
    if(open.enabled()) {
      output_bus.driver = input_bus.driver;
    }
  }
  
  void display(float x, float ys, float ye) {
    noFill();
    strokeWeight(1.5);
    if(open.enabled()) {
      stroke(255, 0, 0);
    } else {
      noStroke();
    }
    
    line(x + 4, ys, x + 2, ys);
    line(x + 2, ys, x + 2, ye);
    line(x + 4, ye, x + 2, ye);
  }
  
}
