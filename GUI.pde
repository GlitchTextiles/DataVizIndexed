//////////////////////////////////////////////
// GUI
//////////////////////////////////////////////

int GUIBuffer=10;
int GUISize=30;

RadioButton sequence_radio, render_radio, mapping_radio, color_radio, sort_radio, data_type_radio;
Slider order_slider, shift_slider, depth_slider, ch1_slider, ch2_slider, ch3_slider;
ScrollableList sequence_select;
Shifter[] shifters = new Shifter[8];
ControlP5 cp5;
Label label;

public void initGUI() {

  cp5 = new ControlP5(this);

  for (int i = 0; i < shifters.length; ++i) {
    shifters[i] = new Shifter(grid(0) - GUIBuffer, grid(9) - GUIBuffer, GUISize, GUIBuffer, this);
    shifters[i].hide();
  }
  cp5.addTextlabel("Shifter Section")
    .setText("Shifters")
    .setPosition(grid(0), grid(7))
    ;

  //controls

  cp5.addBang("quit")
    .setPosition(grid(0), grid(0))
    .setSize(GUISize, GUISize)
    .setLabel("quit")
    ;
  label = cp5.getController("quit").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addBang("save")
    .setPosition(grid(2), grid(0))
    .setSize(GUISize, GUISize)
    .setLabel("save")
    ;
  label = cp5.getController("save").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addBang("open")
    .setPosition(grid(4), grid(0))
    .setSize(GUISize, GUISize)
    .setLabel("open")
    ;
  label = cp5.getController("open").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addSlider("seq_offset")
    .setLabel ("INDEX")
    .setRange(0, 1)
    .setSize(9*(GUISize+GUIBuffer), GUISize)
    .setPosition(grid(0), grid(1))
    ;

  render_radio = cp5.addRadioButton("render_mode")
    .setLabel("render mode")
    .setPosition(grid(0), grid(2))
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
    .setPosition(grid(5)+5, grid(2))
    .setSize(GUISize-10, GUISize-10)
    .setLabel("/")
    .setValue(0)
    ;
  label = cp5.getController("direction").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  color_radio = cp5.addRadioButton("color_mode")
    .setLabel("color mode")
    .setPosition(grid(0), grid(4))
    .setSize(GUISize, GUISize)
    .setItemsPerRow(4)
    .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
    .setSpacingRow(GUIBuffer)
    .addItem("RGB", 0)
    .addItem("HSV", 1)
    .addItem("AVG", 2)
    .activate(0)
    .setValue(0)
    .show();
  ;

  cp5.addBang("dec_linear_scale")
    .setPosition(grid(7)+5, grid(2))
    .setSize(GUISize-10, GUISize-10)
    .setLabel("-")
    ;
  label = cp5.getController("dec_linear_scale").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addBang("inc_linear_scale")
    .setPosition(grid(8)+5, grid(2))
    .setSize(GUISize-10, GUISize-10)
    .setLabel("+")
    ;
  label = cp5.getController("inc_linear_scale").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addToggle("invert")
    .setPosition(grid(0), grid(3))
    .setSize(GUISize, GUISize)
    .setLabel("invert")
    .setValue(0)
    ;
  label = cp5.getController("invert").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  mapping_radio = cp5.addRadioButton("mapping")
    .setLabel("mapping")
    .setPosition(grid(2), grid(3))
    .setSize(GUISize, GUISize)
    .setItemsPerRow(4)
    .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
    .setSpacingRow(GUIBuffer)
    .addItem("DIRECT", 0)
    .addItem("MAPPED", 1)
    .activate(0)
    .setValue(0)
    ;

  order_slider = cp5.addSlider("order")
    .setLabel ("order")
    .setPosition(grid(6), grid(3))
    .setRange(0, orders.length-1)
    .setSize(120, GUISize)
    .setNumberOfTickMarks(orders.length-1)
    ;

  shift_slider = cp5.addSlider("shift")
    .setLabel ("shift")
    .setPosition(grid(6), grid(4))
    .setRange(0, palette.swatches.size()-palette_size-1)
    .setSize(120, GUISize)
    .setNumberOfTickMarks(palette.swatches.size()-palette_size)
    .hide()
    ;

  data_type_radio = cp5.addRadioButton("data_type")
    .setLabel("data_type")
    .setPosition(grid(6), grid(5))
    .setSize(GUISize, GUISize)
    .setItemsPerRow(2)
    .setSpacingColumn((GUISize+GUIBuffer)+GUIBuffer)
    .setSpacingRow(GUIBuffer)
    .addItem("DNA", 0)
    .addItem("BYTES", 1)
    .activate(0)
    .setValue(0)
    ;  

  sort_radio = cp5.addRadioButton("sort_mode")
    .setLabel("sort_mode")
    .setPosition(grid(0), grid(4))
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
    .setPosition(grid(3), grid(6))
    .setSize(GUISize, GUISize)
    .setLabel("randomize")
    .hide()
    ;
  label = cp5.getController("generate").getCaptionLabel();
  label.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(5);

  cp5.addButtonBar("layer")
    .setLabel("layer")
    .setPosition(grid(0), grid(8))
    .setSize(8*GUISize+7*GUIBuffer, GUISize)
    .addItems(split("1 2 3 4 5 6 7 8", " "))
    ;

  cp5.addToggle("enable_all")
    .setPosition(grid(8), grid(8))
    .setSize(GUISize, GUISize)
    .setLabel("EN\nALL")
    ;
  label = cp5.getController("enable_all").getCaptionLabel();
  label.align(ControlP5.CENTER, CENTER);

  cp5.addBang("reset_all")
    .setPosition(grid(9), grid(8))
    .setSize(GUISize, GUISize)
    .setLabel("RESET\nALL")
    ;
  label = cp5.getController("reset_all").getCaptionLabel();
  label.align(ControlP5.CENTER, CENTER);

  cp5.addScrollableList("select_sequence")
    .setLabel("select sequence")
    .setPosition(grid(6), grid(0))
    .setSize(3*(GUISize+GUIBuffer), 5*GUISize)
    .setBarHeight(GUISize)
    .setItemHeight(GUISize)
    .addItems(Arrays.asList(sequenceList))
    .close()
    ;

  // controls for color channel depth
  ch1_slider = cp5.addSlider("set_chan1_depth")
    .setLabel("ch1")
    .setPosition(grid(6), grid(6))
    .setSize(120, GUISize/3)
    .setRange(0, 8)
    .setValue(1)
    .setNumberOfTickMarks(9)
    .hide()
    ;

  ch2_slider = cp5.addSlider("set_chan2_depth")
    .setLabel("ch2")
    .setPosition(grid(6), grid(6)+2*(GUISize+GUIBuffer)/3)
    .setSize(120, GUISize/3)
    .setRange(0, 8)
    .setValue(1)
    .setNumberOfTickMarks(9)
    .hide()
    ;

  ch3_slider = cp5.addSlider("set_chan3_depth")
    .setLabel("ch3")
    .setPosition(grid(6), grid(6)+4*(GUISize+GUIBuffer)/3)
    .setSize(120, GUISize/3)
    .setRange(0, 8)
    .setValue(1)
    .setNumberOfTickMarks(9)
    .hide()
    ; 

  depth_slider = cp5.addSlider("depth")
    .setLabel("depth")
    .setPosition(grid(6), grid(3))
    .setSize(120, GUISize)
    .setRange(1, 6)
    .setValue(1)
    .setNumberOfTickMarks(6)
    .hide()
    ;
}

// helpers for positioning GUI elements
boolean shiftersAreLoaded() {
  int nulls = 0;
  for (int i = 0; i < this.shifters.length; ++i) {
    if (this.shifters[i] == null) {
      ++nulls;
    }
  }
  return nulls == 0;
}

int grid(int offset) {
  return offset*(GUISize+GUIBuffer)+GUIBuffer;
}

// GUI object fuctions

public void quit() {
  exit();
}

public void save() {
  save_file();
}

public void open() {
  selectInput("Select a file to process:", "inputSelection");
}

public void set_chan1_depth(int _value) {
    setDepth(_value, chan2_depth, chan3_depth);
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
  }

  public void set_chan2_depth(int _value) {
    setDepth(chan1_depth, _value, chan3_depth);
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
  }

  public void set_chan3_depth(int _value) {
    setDepth(chan1_depth, chan2_depth, _value);
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
  }

public void depth(int value) {
    palette_depth = value;
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
  }

public void enable_all(int the_value) {
  for (int i = 0; i < shifters.length; ++i) {
    shifters[i].controls.getController("active").setValue(the_value);
  }
}

public void reset_all() {
  cp5.getController("enable_all").setValue(0);
  for (int i = 0; i < shifters.length; ++i) {
    shifters[i].reset();
  }
}

public void layer(int theValue) {
  for ( int i = 0; i < shifters.length; ++i) {
    shifters[i].hide();
  }
  shifters[theValue].show();
}

public void order(int theValue) {
  order = theValue;
  sequence = dataToSwatches(offset);
}

public void shift(int theValue) {
  order_shift = theValue;
  sequence = dataToSwatches(offset);
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

void dec_linear_scale() {
  if (linearScale>1) --linearScale;
}

void inc_linear_scale() {
  ++linearScale;
}

public void invert(int theValue) {
  invert = boolean(theValue);
}

public void generate() {
  randomized.randomize();
  if (mapped) sortPalette(sortMode);
  sequence = dataToSwatches(offset);
}

public void sort_mode(int theValue) {
  if (theValue >= 0) sortMode = theValue;
  if (mapped) sortPalette(sortMode);
  sequence = dataToSwatches(offset);
}

public void mapping(int theValue) {
  switch(theValue) {
  case 1: // colors are mapped to a palette based on an index derived from the data
    mapped = true;
    sort_radio.show();
    color_radio.hide();
    cp5.getController("generate").show();
    sortPalette(sortMode);

    if (data_type=="BYTE") {
      order_slider.hide();
      shift_slider.show();
      depth_slider.show();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    } else {
      order_slider.show();
      shift_slider.show();
      depth_slider.hide();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    }

    break;
  case 0: // color values are interpreted directly from the raw data and scaled to a 24bit color space
    mapped = false;
    sort_radio.hide();
    cp5.getController("generate").hide();
    cp5.getController("shift").hide();
    color_radio.show();

    if (data_type=="BYTE") {
      order_slider.show();
      shift_slider.hide();
      depth_slider.hide();
      ch1_slider.show();
      ch2_slider.show();
      ch3_slider.show();
    } else {
      order_slider.show();
      shift_slider.hide();
      depth_slider.hide();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    }

    break;
  }
  cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
  sequence = dataToSwatches(offset);
}

public void data_type(int theValue) {
  switch(theValue) {
  case 0:
    data_type = "DNA";
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
    order_slider
      .setRange(0, orders.length-1)
      .setSize(120, GUISize)
      .setNumberOfTickMarks(orders.length-1);

    if (mapped) {
      order_slider.show();
      shift_slider.show();
      depth_slider.hide();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    } else {
      order_slider.show();
      shift_slider.hide();
      depth_slider.show();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    }

    break;
  case 1:
    data_type = "BYTE";
    cp5.getController("seq_offset").setValue(cp5.getController("seq_offset").getValue());
    order_slider
      .setRange(0, 5)
      .setSize(120, GUISize)
      .setNumberOfTickMarks(6);

    if (mapped) {
      order_slider.hide();
      shift_slider.show();
      depth_slider.show();
      ch1_slider.hide();
      ch2_slider.hide();
      ch3_slider.hide();
    } else {
      order_slider.show();
      shift_slider.hide();
      depth_slider.hide();
      ch1_slider.show();
      ch2_slider.show();
      ch3_slider.show();
    }

    break;
  }
  sequence = dataToSwatches(offset);
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

public void select_sequence(int theValue) {
  if (theValue >=0) {
    loadData(sequences[theValue]);
    cp5.getController("seq_offset").setValue(0);
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

public void seq_offset(float theValue) {
  switch(data_type) {
  case "DNA":
    offset = int(theValue * rawBytes.length/8.0);
    break;
  case "BYTE":
    if (mapped) {
      offset = int(theValue * rawBits.length()/float(palette_depth));
    } else {
      offset = int(theValue * rawBits.length()/float(rgb_depth));
    }
    break;
  }

}
