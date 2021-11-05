//====================================================================================
// Render the data into a design

public PGraphics render(int start, String renderMode, String colorMode, boolean invert) {

  color[] colors;
  
  int mask = 0;
  PGraphics graphics = createGraphics(graphics_width,  graphics_height); // starting size of a PCW throw design
  if (invert) mask = 0x00ffffff;
  graphics.beginDraw();
  graphics.strokeWeight(1);
  int value = 0;
  switch(renderMode) {
  case "HORIZONTAL":
    for (int i = 0; i < graphics.height; i++) {
      value = sequence.get(i % sequence.size()).c ^ mask;
      if (colorMode.equals("RGB")) {
        graphics.stroke(palette.rgbClosest(value).c);
      } else if (colorMode.equals("HSB")) {
        graphics.stroke(palette.hsbClosest(value).c);
      } else if (colorMode.equals("AVG")) {
        graphics.stroke(palette.closest(value).c);
      }
      graphics.line(-1, i, graphics.width, i);
    }
    break;
  case "VERTICAL":
    for (int i = 0; i < graphics.width; i++) {
      value = sequence.get(i % sequence.size()).c ^ mask;
      if (colorMode.equals("RGB")) {
        graphics.stroke(palette.rgbClosest(value).c);
      } else if (colorMode.equals("HSB")) {
        graphics.stroke(palette.hsbClosest(value).c);
      } else if (colorMode.equals("AVG")) {
        graphics.stroke(palette.closest(value).c);
      }
      graphics.line(i, -1, i, graphics.height);
    }
    break;
  case "DIAGONAL":
    graphics.loadPixels();

    colors = new color[graphics.width+graphics.height];

    for (int i = 0; i < colors.length; i++) {
      color c = (sequence.get((start+i) % sequence.size()).c ^ mask);
      if (colorMode.equals("RGB")) {
        colors[i]=palette.rgbClosest(c).c;
      } else if (colorMode.equals("HSB")) {
        colors[i]=palette.hsbClosest(c).c;
      } else if (colorMode.equals("AVG")) {
        colors[i]=palette.closest(c).c;
      }
    }

    for (int y = 0; y < graphics.height; y++) {
      int i = 0;
      if (diagDir.equals("DOWN")) {
        i = (graphics.height-1) - y;
      } else {
        i = y;
      }
      for (int x = 0; x < graphics.width; x++) {
        int p = y*graphics.width+x;
        graphics.pixels[p]=colors[x+i];
      }
    }

    graphics.updatePixels();
    break;
  case "LINEAR":
    graphics.noStroke();
    int h = int(graphics.height/linearScale) + 1;
    int w = int(graphics.width/linearScale) + 1;
    
    if( h*w > sequence.size()){
      colors = new color[sequence.size()];
    } else {
      colors = new color[h*w];
    }
    
    for (int i = 0; i < colors.length; i++) {
      color c = (sequence.get((start+i) % sequence.size()).c ^ mask);
      if (colorMode.equals("RGB")) {
        colors[i]=palette.rgbClosest(c).c;
      } else if (colorMode.equals("HSB")) {
        colors[i]=palette.hsbClosest(c).c;
      } else if (colorMode.equals("AVG")) {
        colors[i]=palette.closest(c).c;
      }
    }
    
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        graphics.fill(colors[(y*w+x)%colors.length]);
        graphics.square(x*linearScale, y*linearScale, linearScale);
      }
    }
    break;
  }
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
