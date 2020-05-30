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
