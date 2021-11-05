//====================================================================================
// Shifter Class

public class Shifter {

  private boolean active;
  private String mode, direction;
  private int  noise_octaves, position_x, position_y, size, buffer, seed;
  private float shift, start, end, scale, noise_falloff;
  private ControlP5 controls;
  Label label;
  Range range;
  PApplet parent;

  public Shifter(int x, int y, int size, int buffer, PApplet applet) {
    this.size=size;
    this.buffer=buffer;
    this.position_x = x;
    this.position_y = y;
    this.active = false;
    this.mode = "CHOP";
    this.direction = "HORIZONTAL";
    this.start = 0.0;
    this.end = 0.0;
    this.shift = 0.0;
    this.scale = 0.0;
    this.noise_octaves = 4;
    this.noise_falloff = 0.5;
    this.seed = 0;
    this.parent = applet;
    initControls();
  }

  public void initControls() {
    this.controls = new ControlP5(parent);

    controls.addToggle("active")
      .setLabel("enable")
      .setPosition(gridx(0), gridy(0))
      .setSize(size, size)
      .plugTo(this, "setActive")
      .setValue(0)
      ;
    label = controls.getController("active").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    range = controls.addRange("the_range")
      .setLabel("range")
      .setPosition(gridx(1), gridy(0))
      .setSize(8*(size+buffer), size)
      .setHandleSize(buffer)
      .setRange(0, 1)
      .plugTo(this, "setRange")
      .setRangeValues(0, 1)
      ;
    label = controls.getController("the_range").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    controls.addButtonBar("effect")
      .setPosition(gridx(0), gridy(1))
      .setSize(2*size+buffer, size)
      .addItems(split("chop warp", " "))
      .plugTo(this, "setMode")
      .setValue(0)
      ;

    //direction of shift Left-Right, Up-Down (LRUD)
    controls.addButtonBar("LRUD")
      .setPosition(gridx(2), gridy(1))
      .setSize(2*size+buffer, size)
      .addItems(split("H V", " "))
      .plugTo(this, "setDirection")
      .setValue(0)
      .update()
      ;

    controls.addSlider("shift_pixels")
      .setPosition(gridx(0), gridy(2))
      .setSize(4*(size)+3*buffer, size)
      .setLabel("shift")
      .setRange(-3.0, 3.0)
      .plugTo(this, "setShift")
      .setValue(0)
      ;
    label = controls.getController("shift_pixels").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    controls.addSlider("amplitude")
      .setPosition(gridx(4), gridy(2))
      .setSize(2*(size)+buffer, size)
      .setLabel("scale")
      .setRange(0, 1)
      .plugTo(this, "setScale")
      .setValue(0)
      ;
    label = controls.getController("amplitude").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    controls.addSlider("octaves")
      .setPosition(gridx(0), gridy(3))
      .setSize(2*(size)+buffer, size)
      .setRange(1, 10)
      .setNumberOfTickMarks(9)
      .snapToTickMarks(true)
      .plugTo(this, "setOctaves")
      .setValue(4)
      ;
    label = controls.getController("octaves").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    controls.addSlider("fade")
      .setPosition(gridx(4), gridy(3))
      .setSize(2*(size)+buffer, size)
      .setRange(0, 1)
      .plugTo(this, "setFalloff")
      .setValue(.5)
      ;

    controls.addSlider("noise_seed")
      .setPosition(gridx(7), gridy(2))
      .setSize(2*(size)+buffer, size)
      .setLabel("seed")
      .setRange(-1, 1)
      .plugTo(this, "setSeed")
      .setValue(0)
      ;
    label = controls.getController("noise_seed").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);

    controls.addBang("reset_controls")
      .setPosition(gridx(8), gridy(3))
      .setSize(size, size)
      .setLabel("reset")
      .plugTo(this, "reset")
      ;
    label = controls.getController("reset_controls").getCaptionLabel();
    label.align(ControlP5.CENTER, CENTER);
  }

  public void reset() {
    initControls();
  }

  public void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom("the_range")) {
      this.start = theControlEvent.getController().getArrayValue(0);
      this.end = theControlEvent.getController().getArrayValue(1);
    }
  }


  public void show() {
    this.controls.show();
  }

  public void hide() {
    this.controls.hide();
  }

  private int gridx(int offset) {
    return offset*(size+buffer)+buffer+position_x;
  }

  private int gridy(int offset) {
    return offset*(size+buffer)+buffer+position_y;
  }

  public void setMode(int value) {
    switch(value) {
    case 0:
      this.mode = "CHOP";
      break;
    case 1:
      this.mode = "WARP";
      break;
    }
  }

  public void setDirection(int value) {
    switch(value) {
    case 0:
      this.direction = "HORIZONTAL"; 
      break;
    case 1:
      this.direction = "VERTICAL";
      break;
    }
  }

  public void setRange(float[] _value) {
    println(_value);
  }

  public void setStart(float start) {
    this.start = constrain(start, 0.0, this.end);
  }

  public void setEnd(float end) {
    this.end = constrain(end, this.start, 1.0);
  }

  public void setShift(float shift) {
    this.shift = shift;
  }

  public void setScale(float scale) {
    this.scale = scale*0.005;
  }

  public void setOctaves (int octaves) {
    this.noise_octaves = constrain(octaves, 1, 10);
  }

  public void setFalloff(float falloff) {
    this.noise_falloff = constrain(falloff, 0.0, 1.0);
  }

  public void setSeed(float theSeed) {
    this.seed=int(theSeed*100);
  }

  public void setActive(boolean value) {
    this.active=value;
  }

  public boolean isActive() {
    return active;
  }

  public PImage process(PImage image) {

    switch(this.mode) {
    case "CHOP":
      this.chop(image);
      break;
    case "WARP":
      this.warp(image);
      break;
    }
    return image;
  }

  public PImage chop(PImage image) {
    switch(this.direction) {
    case "HORIZONTAL":
      this.shiftRows(image, int(start*image.height), int(end*image.height), int(shift*image.height));
      break;
    case "VERTICAL":
      this.shiftCols(image, int(start*image.width), int(end*image.width), int(shift*image.width));
      break;
    }
    return image;
  }

  public PImage warp(PImage image) {
    noiseSeed(seed);
    noiseDetail(noise_octaves, noise_falloff);
    switch(this.direction) {
    case "HORIZONTAL":
      perlinRows(image, int(start*image.height), int(end*image.height), int(shift*image.height), scale);
      break;
    case "VERTICAL":
      perlinCols(image, int(start*image.width), int(end*image.width), int(shift*image.width), scale);
      break;
    }
    return image;
  }

  public PImage shiftRows(PImage image, int start, int end, int amount) {
    for (int i = start; i < end; ++i) {
      shiftRow(image, i, amount);
    }
    return image;
  }

  public PImage shiftCols(PImage image, int start, int end, int amount) {
    for (int i = start; i < end; ++i) {
      shiftCol(image, i, amount);
    }
    return image;
  }


  public PImage perlinRows(PImage image, int start, int end, int amount, float scale) {
    for (int i = start; i < end; ++i) {
      shiftRow(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
    }
    return image;
  }

  public PImage perlinCols(PImage image, int start, int end, int amount, float scale) {
    for (int i = start; i < end; ++i) {
      shiftCol(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
    }
    return image;
  }


  public PImage shiftRow(PImage image, int row, int amount) {
    if (image != null && row < image.height) {
      int[] pxls = new int[image.width];
      for (int i = 0; i < image.width; ++i) {
        pxls[(i+amount+(3*image.width)) % image.width] = image.pixels[row*image.width+i];
      }
      for (int i = 0; i < image.width; ++i) {
        image.pixels[row*image.width+i]=pxls[i];
      }
    }
    return image;
  }

  public PImage shiftCol(PImage image, int col, int amount) {
    if (image != null && col < image.width) {
      int[] pxls = new int[image.height];
      for (int i = 0; i < image.height; ++i) {
        pxls[(i+amount+(3*image.height)) % image.height] = image.pixels[i*image.width+col];
      }
      for (int i = 0; i < image.height; ++i) {
        image.pixels[i*image.width+col]=pxls[i];
      }
    }
    return image;
  }
}
