public void loadSequence(String path) {
  rawData = loadBytes(path);
  sequence = dataToSwatches(rawData);
}

//====================================================================================
// Render the data into a design

public PGraphics render(int start, String renderMode, String colorMode, boolean invert) {
  gui.noLoop();
  int mask = 0;
  PGraphics graphics = createGraphics(screen_width, screen_height); // starting size of a PCW throw design
  if (invert) mask = 0x00ffffff;
  graphics.beginDraw();
  graphics.strokeWeight(1);
  switch(renderMode) {
  case "HORIZONTAL":
    for (int i = 0; i < graphics.height; i++) {
      if (colorMode.equals("RGB")) {
        graphics.stroke(palette.rgbClosest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      } else if (colorMode.equals("HSB")) {
        graphics.stroke(palette.hsbClosest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      } else if (colorMode.equals("AVG")) {
        graphics.stroke(palette.closest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      }
      graphics.line(0, i, graphics.width, i);
    }
    break;
  case "VERTICAL":
    for (int i = 0; i < graphics.width; i++) {
      if (colorMode.equals("RGB")) {
        graphics.stroke(palette.rgbClosest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      } else if (colorMode.equals("HSB")) {
        graphics.stroke(palette.hsbClosest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      } else if (colorMode.equals("AVG")) {
        graphics.stroke(palette.closest(sequence.get((i+start) % sequence.size()).c ^ mask).c);
      }
      graphics.line(i, 0, i, graphics.height);
    }
    break;
  case "DIAGONAL":
    graphics.loadPixels();
    println(diagDir);
    int yp = 0;
    for (int y = 0; y < graphics.height; y++) {
      for (int x = 0; x < graphics.width; x++) {
        
        if (diagDir.equals("DOWN")) {
          yp =(graphics.height-1) -y;
        } else {
          yp = y;
        }
        
        color c = (sequence.get((yp+start+x) % sequence.size()).c ^ mask);
        int p = y*graphics.width+x;
        
        if (colorMode.equals("RGB")) {
          graphics.pixels[p]=palette.rgbClosest(c).c;
        } else if (colorMode.equals("HSB")) {
          graphics.pixels[p]=palette.hsbClosest(c).c;
        } else if (colorMode.equals("AVG")) {
          graphics.pixels[p]=palette.closest(c).c;
        }
      }
    }
    graphics.updatePixels();
    break;
  case "LINEAR":
    graphics.noStroke();
    int h = int(graphics.height/linearScale) + 1;
    int w = int(graphics.width/linearScale) + 1;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        if (colorMode.equals("RGB")) {
          graphics.fill(palette.rgbClosest(sequence.get((y*w+x+start) % sequence.size()).c ^ mask).c);
        } else if (colorMode.equals("HSB")) {
          graphics.fill(palette.hsbClosest(sequence.get((y*w+x+start) % sequence.size()).c ^ mask).c);
        } else if (colorMode.equals("AVG")) {
          graphics.fill(palette.closest(sequence.get((y*w+x+start) % sequence.size()).c ^ mask).c);
        }
        graphics.square(x*linearScale, y*linearScale, linearScale);
      }
    }
    break;
  }
  gui.loop();
  graphics.endDraw();
  return graphics;
}

//====================================================================================
// Stretch the images from 1000 to 1025 lines in a PCW friendly manner

public PGraphics PCWScale(PGraphics graphic) {
  if (graphic == null) {
    println("PGraphics object is not initialized.");
    return null;
  } else if (graphic.height == 1000) {
    PGraphics linesAdded = createGraphics(graphic.width, 1025);
    int row = 0;
    linesAdded.beginDraw();
    linesAdded.loadPixels();
    graphic.loadPixels();
    for (int y = 0; y < linesAdded.height; y++) {
      for (int x = 0; x < linesAdded.width; x++) {
        linesAdded.pixels[y*linesAdded.width+x] = graphic.pixels[row*graphic.width+x];
      }
      if (y % 41 != 0) row++;
    }
    linesAdded.updatePixels();
    linesAdded.endDraw();
    return linesAdded;
  } else {
    println("Incompatible PGraphics size. Height must be 1000px");
    return null;
  }
}

//====================================================================================
// Create a set of swatches from an array of bytes

public Swatches dataToSwatches(byte[] data) {
  Swatches dataSwatches = new Swatches();
  if (mapped) {
    for (int i = 0; i < data.length; i+=3) {
      int index = 0;
      if (i < data.length) index |= ATGCtoInt(char(data[i]))<< 0;
      if (i+1 < data.length) index |= ATGCtoInt(char(data[i+1])) << 2;
      if (i+2 < data.length) index |= ATGCtoInt(char(data[i+2])) << 4;
      color c = palette.get((index + order_shift) % palette.swatches.size()).c;
      dataSwatches.add(c);
    }
  } else {
    for (int i = 0; i < data.length; i+=3) {
      int r = 0;
      int g = 0;
      int b = 0;
      if (i < data.length) r = ATGCtoInt(char(data[i]));
      if (i+1 < data.length) g = ATGCtoInt(char(data[i+1]));
      if (i+2 < data.length) b = ATGCtoInt(char(data[i+2]));
      color c = color(r, g, b);
      dataSwatches.add(c);
    }
  }
  return dataSwatches;
}

//====================================================================================
// Convert ASCII ATGC into scaled 0-255 vaules for RGB channels

int[][] orders = { // effectively swap how color values are assigned to base pairs
  {0, 1, 2, 3}, 
  {0, 1, 3, 2}, 
  {0, 2, 1, 3}, 
  {0, 2, 3, 1}, 
  {0, 3, 1, 2}, 
  {0, 3, 2, 1}, 
  {1, 0, 2, 3}, 
  {1, 0, 3, 2}, 
  {1, 2, 0, 3}, 
  {1, 2, 3, 0}, 
  {1, 3, 0, 2}, 
  {1, 3, 2, 0}, 
  {2, 0, 1, 3}, 
  {2, 0, 3, 1}, 
  {2, 1, 0, 3}, 
  {2, 1, 3, 0}, 
  {2, 3, 0, 1}, 
  {2, 3, 1, 0}, 
  {3, 0, 1, 2}, 
  {3, 0, 2, 1}, 
  {3, 1, 0, 2}, 
  {3, 1, 2, 0}, 
  {3, 2, 0, 1}, 
  {3, 2, 1, 0}
};

public int ATGCtoInt(char c) {

  int value = 0;

  if (mapped) {
    switch(c) {
    case 'A':
      value = orders[order][0];
      break;
    case 'T':
      value = orders[order][1];
      break;
    case 'G':
      value = orders[order][2];
      break;
    case 'C':
      value = orders[order][3];
      break;
    }
  } else {
    switch(c) {
    case 'A':
      value = orders[order][0]*255/3;
      break;
    case 'T':
      value = orders[order][1]*255/3;
      break;
    case 'G':
      value = orders[order][2]*255/3;
      break;
    case 'C':
      value = orders[order][3]*255/3;
      break;
    }
  }
  return value;
}
