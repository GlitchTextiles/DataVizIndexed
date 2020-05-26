//float noiseScaleMin=0.0003;
//float noiseScaleMax=0.005;
//int warp=250;
int steps = 8;
Shifter[] shifters;

void initShifters() {
  shifters = new Shifter[8];
  for (int i = 0; i < shifters.length; ++i) {
    shifters[i] = new Shifter();
  }
}

class Shifter {
  boolean enable;
  String mode, direction;
  int  noise_octaves;
  float shift, start, end, scale, noise_falloff;

  Shifter() {
    enable = false;
    mode = "CHOP";
    direction = "HORIZONTAL";
    start = 0.0;
    end = 0.0;
    shift = 0.0;
    scale = 0.0;
    noise_octaves = 4;
    noise_falloff = 0.5;
  }
  
  void setMode(String mode){
    if (mode.equals("CHOP") || mode.equals("WARP")) this.mode = mode;
  }
  
  void setDirection(String dir){
    if (dir.equals("HORIZONTAL") || dir.equals("VERTICAL")) this.direction = dir;
  }
  
  void setStart(float start) {
    this.start = constrain(start, 0.0, this.end);
  }

  void setEnd(float end) {
    this.end = constrain(end, this.start, 1.0);
  }

  void setShift(float shift) {
    this.shift = constrain(shift, 0.0, 1.0);
  }

  void setScale(float scale) {
    this.scale = constrain(scale, 0.0, 0.01);
  }

  void setOctaves (int octaves) {
    this.noise_octaves = constrain(octaves, 0, 10);
  }

  void setFalloff(float falloff) {
    this.noise_falloff = constrain(falloff, 0.0, 1.0);
  }

  void enable() {
    this.enable=true;
  }

  void disable() {
    this.enable=false;
  }

  boolean isEnabled() {
    return enable;
  }

  PImage process(PImage image) {
    switch(mode) {
    case "CHOP":
      chop(image);
      break;
    case "WARP":
      warp(image);
      break;
    }
    return image;
  }

  PImage chop(PImage image) {
    switch(this.direction) {
    case "HORIZONTAL":
      shiftRows(image, int(start*image.width), int(end*image.width), int(shift*image.width));
      break;
    case "VERTICAL":
      shiftCols(image, int(start*image.height), int(end*image.height), int(shift*image.height));
      break;
    }
    return image;
  }

  PImage warp(PImage image) {
    noiseDetail(noise_octaves, noise_falloff);
    switch(this.direction) {
    case "HORIZONTAL":
      perlinRows(image, int(start*image.width), int(end*image.width), int(shift*image.width), scale);
      break;
    case "VERTICAL":
      perlinCols(image, int(start*image.height), int(end*image.height), int(shift*image.height), scale);
      break;
    }
    return image;
  }

  PImage shiftRows(PImage image, int start, int end, int amount) {
    for (int i = start; i < end; ++i) {
      shiftRow(image, i, amount);
    }
    return image;
  }

  PImage shiftCols(PImage image, int start, int end, int amount) {
    for (int i = start; i < end; ++i) {
      shiftCol(image, i, amount);
    }
    return image;
  }


  PImage perlinRows(PImage image, int start, int end, int amount, float scale) {
    for (int i = start; i < end; ++i) {
      shiftRow(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
    }
    return image;
  }

  PImage perlinCols(PImage image, int start, int end, int amount, float scale) {
    for (int i = start; i < end; ++i) {
      shiftCol(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
    }
    return image;
  }


  PImage shiftRow(PImage image, int row, int amount) {
    if (image != null && row < image.height) {
      int[] pxls = new int[image.width];
      for (int i = 0; i < image.width; ++i) {
        pxls[(i+amount+image.width) % image.width] = image.pixels[row*image.width+i];
      }
      for (int i = 0; i < image.width; ++i) {
        image.pixels[row*image.width+i]=pxls[i];
      }
    }
    return image;
  }

  PImage shiftCol(PImage image, int col, int amount) {
    if (image != null && col < image.width) {
      int[] pxls = new int[image.height];
      for (int i = 0; i < image.height; ++i) {
        pxls[(i+amount+image.height) % image.height] = image.pixels[i*image.width+col];
      }
      for (int i = 0; i < image.height; ++i) {
        image.pixels[i*image.width+col]=pxls[i];
      }
    }
    return image;
  }
}
