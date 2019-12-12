/*
  Screen
  Draws a C64-style screen as a separate window
  
*/
class Screen extends PApplet {
  int rows, cols;
  color[] colours;
  
  final static int BORDER_WIDTH = 40;
  final static int CHAR_WIDTH = 8;
  final static int CHAR_HEIGHT = 8;
  
  Screen() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(400, 280);
  }
  
  public void setup() { 
    surface.setTitle("My6502");
  }
  
  public void draw() {
    if(!show_screen) {
      surface.setVisible(false);
      return;
    } 
    surface.setVisible(true);
    noStroke();
    background(0x6C, 0x5E, 0xB5);  // C64 border colour - light blue
    fill(0x35, 0x28, 0x79);  // C64 dark blue
    rect(BORDER_WIDTH, BORDER_WIDTH, 40 * CHAR_WIDTH, 25 * CHAR_HEIGHT);
    
    textFont(font_screen);
    fill(0x6C, 0x5E, 0xB5);
    textAlign(LEFT, TOP);
    int c = 0;
    int r = 0;
    for(int i=0; i<1000; i++) {
      c = i % 40;
      r = i / 40;
      text(ram.charAtAddr(i), BORDER_WIDTH + (c * CHAR_WIDTH), BORDER_WIDTH + (r * CHAR_HEIGHT));
    }
  }
}
