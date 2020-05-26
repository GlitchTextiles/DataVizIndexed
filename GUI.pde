//////////////////////////////////////////////
// GUI
//////////////////////////////////////////////

int row[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
int col[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
int GUIBuffer=10;
int GUISize=30;

RadioButton sequence_radio, render_radio, mapping_radio, color_radio, sort_radio;

public class ControlFrame extends PApplet {

  int w, h, x, y;
  String name="";
  PApplet parent;
  ControlP5 cp5;
  boolean shift = false;
  float value = 0.0;

  public ControlFrame(PApplet _parent, int _x, int _y, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    name = _name;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    controlP5.Label label;
    surface.setSize(w, h);
    surface.setLocation(x, y);
    cp5 = new ControlP5(this);
    frameRate(10);

    //controls
    cp5.addBang("quit")
      .setPosition(h(0), v(0))
      .setSize(GUISize, GUISize)
      .setLabel("quit")
      ;
    label = cp5.getController("quit").getCaptionLabel();
    label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
    label.getStyle().setPaddingLeft(5);

    cp5.addBang("save")
      .setPosition(h(2), v(0))
      .setSize(GUISize, GUISize)
      .setLabel("save")
      ;
    label = cp5.getController("save").getCaptionLabel();
    label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
    label.getStyle().setPaddingLeft(5);

    sequence_radio = cp5.addRadioButton("select_sequence")
      .setLabel("sequence")
      .setPosition(h(0), v(1))
      .setSize(GUISize, GUISize)
      .setItemsPerRow(4)
      .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
      .setSpacingRow(GUIBuffer)
      .addItem("RdRP", 3)
      .addItem("N", 2)
      .addItem("S", 0)
      .addItem("ALL", 1)
      .activate(0)
      .setValue(0)
      ;

    cp5.addSlider("start")
      .setLabel ("start")
      .setRange(0, 1)
      .setSize(this.width-(2*GUIBuffer)-GUISize, GUISize)
      .setPosition(h(0), v(2));
    ;

    render_radio = cp5.addRadioButton("render_mode")
      .setLabel("render mode")
      .setPosition(h(0), v(3))
      .setSize(GUISize, GUISize)
      .setItemsPerRow(4)
      .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
      .setSpacingRow(GUIBuffer)
      .addItem("H", 0)
      .addItem("V", 1)
      .addItem("D", 2)
      .addItem("L", 3)
      .activate(0)
      .setValue(0)
      ;
    cp5.addToggle("direction")
      .setPosition(h(5)+5, v(3))
      .setSize(GUISize-10, GUISize-10)
      .setLabel("!")
      .setValue(0)
      ;
    label = cp5.getController("direction").getCaptionLabel();
    label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
    label.getStyle().setPaddingLeft(5);

    color_radio = cp5.addRadioButton("color_mode")
      .setLabel("color mode")
      .setPosition(h(0), v(4))
      .setSize(GUISize, GUISize)
      .setItemsPerRow(4)
      .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
      .setSpacingRow(GUIBuffer)
      .addItem("RGB", 0)
      .addItem("HSV", 1)
      .addItem("AVG", 2)
      .activate(0)
      .setValue(0)
      ;

    cp5.addToggle("invert")
      .setPosition(h(0), v(5))
      .setSize(GUISize, GUISize)
      .setLabel("invert")
      .setValue(0)
      ;
    label = cp5.getController("invert").getCaptionLabel();
    label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
    label.getStyle().setPaddingLeft(5);

    mapping_radio = cp5.addRadioButton("mapping")
      .setLabel("mapping")
      .setPosition(h(2), v(5))
      .setSize(GUISize, GUISize)
      .setItemsPerRow(4)
      .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
      .setSpacingRow(GUIBuffer)
      .addItem("GROUP", 0)
      .addItem("INDEX", 1)
      .activate(0)
      .setValue(0)
      ;

    cp5.addSlider("order")
      .setLabel ("order")
      .setPosition(h(6), v(5))
      .setRange(0, orders.length-1)
      .setSize(120, GUISize)
      .setNumberOfTickMarks(orders.length-1)
      ;

    cp5.addSlider("shift")
      .setLabel ("shift")
      .setPosition(h(6), v(6))
      .setRange(0, palette.swatches.size()-64-1)
      .setSize(120, GUISize)
      .setNumberOfTickMarks(palette.swatches.size()-64)
      .hide()
      ;

    sort_radio = cp5.addRadioButton("sort_mode")
      .setLabel("sort_mode")
      .setPosition(h(0), v(6))
      .setSize(GUISize, GUISize)
      .setItemsPerRow(3)
      .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
      .setSpacingRow(GUIBuffer)
      .addItem("COLOR", 0)
      .addItem("HUE", 1)
      .addItem("SAT", 2)
      .addItem("BRIGHT", 3)
      .addItem("BR-SAT", 4)
      .addItem("SAT-BR", 5)
      .addItem("RAND", 6)
      .activate(0)
      .setValue(0)
      .hide()
      ;

    cp5.addBang("generate")
      .setPosition(h(3), v(8))
      .setSize(GUISize, GUISize)
      .setLabel("randomize")
      .hide()
      ;
    label = cp5.getController("generate").getCaptionLabel();
    label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
    label.getStyle().setPaddingLeft(5);
  }

  public void draw() {
    background(0);
  }

  // helpers for positioning GUI elements

  int v(int c) {
    return col[c]*(GUISize+GUIBuffer)+GUIBuffer;
  }

  int h(int r) {
    return row[r]*(GUISize+GUIBuffer)+GUIBuffer;
  }

  // GUI object fuctions

  public void order(int theValue) {
    order = theValue;
    sequence = dataToSwatches(rawData);
  }

  public void shift(int theValue) {
    order_shift = theValue;
    sequence = dataToSwatches(rawData);
  }
  
  public void direction(int theValue) {
    switch(theValue) {
    case 0:
      diagDir = "DOWN";
      break;
    case 1:
      diagDir = "UP";
      break;
    }
  }

  public void invert(int theValue) {
    invert = boolean(theValue);
  }

  public void generate() {
    randomized.randomize();
    if (mapped) sortPalette(sortMode);
    sequence = dataToSwatches(rawData);
  }

  public void sort_mode(int theValue) {
    if (theValue >= 0) sortMode = theValue;
    if (mapped) sortPalette(sortMode);
    sequence = dataToSwatches(rawData);
  }

  public void mapping(int theValue) {
    switch(theValue) {
    case 1:
      mapped = true;
      sort_radio.show();
      cp5.getController("generate").show();
      cp5.getController("shift").show();
      sortPalette(sortMode);
      break;
    case 0: // colors are mapped acording to grouped nucleotide values
      mapped = false;
      sort_radio.hide();
      cp5.getController("generate").hide();
      cp5.getController("shift").hide();
      break;
    }
    sequence = dataToSwatches(rawData);
  }

  public void color_mode(int theValue) {
    switch(theValue) {
    case 0:
      colorMode = "RGB";
      break;
    case 1:
      colorMode = "HSB";
      break;
    case 2:
      colorMode = "AVG";
      break;
    }
  }

  public void quit() {
    exit();
  }

  public void save() {
    save_file();
  }

  public void select_sequence(int theValue) {
    if (theValue >=0) {
      loadSequence(sequences[theValue]);
      offset = int(cp5.getController("start").getValue() * sequence.swatches.size());
    }
  }

  public void render_mode(int theValue) {
    switch(theValue) {
    case 0:
      renderMode = "HORIZONTAL";
      break;
    case 1:
      renderMode = "VERTICAL";
      break;
    case 2:
      renderMode = "DIAGONAL";
      break;
    case 3:
      renderMode = "LINEAR";
      break;
    }
  }

  public void start(float theValue) {
    offset = int(theValue * sequence.swatches.size());
  }

  void mouseReleased() {
    parent.redraw();
  }
}
