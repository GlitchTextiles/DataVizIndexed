//====================================================================================
// Create a set of swatches from an array of bytes

public Swatches dataToSwatches(int _start) {
  
  Swatches dataSwatches = new Swatches();

  int qty_swatches = 0;
  int start = 0;
  int end = 0;

  switch(renderMode) {
  case "HORIZONTAL":
    qty_swatches = graphics_height;
    break;
  case "VERTICAL":
    qty_swatches = graphics_width;
    break;
  case "DIAGONAL":
    qty_swatches = graphics_height + graphics_width;
    break;
  case "LINEAR":
    int h = int(graphics_height/float(linearScale)) + 1;
    int w = int(graphics_width/float(linearScale)) + 1;
    qty_swatches = h * w;
    break;
  }

  switch(data_type) {
  case "DNA":

    if (qty_swatches > int(rawBytes.length/3.0)) {
      start = 0;
      end = int(rawBytes.length/3.0);
    } else if ( qty_swatches > int(rawBytes.length/3.0) - _start) {
      start = int(rawBytes.length/3.0) - _start;
      end = int(rawBytes.length/3.0);
    } else {
      start = _start*3;
      end = qty_swatches*3+start;
    }

    if (mapped) {
      for (int i = start; i < end; i+=3) {
        int index = 0;
        if (i < rawBytes.length) index |= ATGCtoInt(char(rawBytes[i]))<< 0;
        if (i+1 < rawBytes.length) index |= ATGCtoInt(char(rawBytes[i+1])) << 2;
        if (i+2 < rawBytes.length) index |= ATGCtoInt(char(rawBytes[i+2])) << 4;
        color c = palette.get((index + order_shift) % palette.swatches.size()).c;
        dataSwatches.add(c);
      }
    } else {
      for (int i = start; i < end; i+=3) {
        int r = 0;
        int g = 0;
        int b = 0;
        if (i < rawBytes.length) r = ATGCtoInt(char(rawBytes[i]));
        if (i+1 < rawBytes.length) g = ATGCtoInt(char(rawBytes[i+1]));
        if (i+2 < rawBytes.length) b = ATGCtoInt(char(rawBytes[i+2]));
        color c = color(r, g, b);
        dataSwatches.add(c);
      }
    }
    break;
  case "BYTE":

    int max_swatches = 0;
    
    if (mapped) {
      max_swatches = int(rawBits.length() / float(palette_depth) );
    } else {
      max_swatches = int(rawBits.length() / float(rgb_depth) );
    }

    if (qty_swatches > max_swatches) {
      start = 0;
      end = max_swatches;
    } else if ( qty_swatches > max_swatches - _start) {
      start = qty_swatches;
      end = max_swatches;
    } else {
      start = _start;
      end = qty_swatches+start;
    }

    if (mapped) { //indexed

      // iterate through raw_bits in blocks of size palette_depth
      for (int i = start; i < end; ++i) {
        int palette_index = 0;
        //iterate over size of palette_depth to extract color index value
        for (int j = 0; j < palette_depth; ++j) {
          palette_index |= int(rawBits.get(i*palette_depth+j)) << j;
        }
        color c = palette.get((palette_index + order_shift) % palette.swatches.size()).c;
        dataSwatches.add(c);
      }
    } else { //direct

      for (int i = start; i < end; i++) {

        int index = 0;

        int chan1 = 0;
        int chan2 = 0; 
        int chan3 = 0; 

        int red = 0;
        int green = 0; 
        int blue = 0; 

        //using some bit shifting voodoo to pack bits into channel values  

        for (int x = 0; x < chan1_depth; x++) {
          int value = 0;
          index = i*rgb_depth + x + bit_offset;
          if (index >=0 && index < rawBits.length() ) value = int(rawBits.get(index)) & 1;
          chan1 |= value << x;
        }
        chan1*=(255/(pow(2, (chan1_depth))-1)); //scale to 0-255

        for (int y = 0; y < chan2_depth; y++) {
          int value = 0;
          index = i*rgb_depth + chan1_depth + y + bit_offset;
          if (index >=0 && index < rawBits.length() ) value = int(rawBits.get(index)) & 1;
          chan2 |= value << y;
        }
        chan2*=(255/(pow(2, (chan2_depth))-1)); //scale to 0-255

        for (int z = 0; z < chan3_depth; z++) {
          int value = 0;
          index = i*rgb_depth + chan1_depth + chan2_depth + z + bit_offset;
          if (index >=0 && index < rawBits.length() ) value = int(rawBits.get(index)) & 1;
          chan3 |= value << z;
        }
        chan3*=(255/(pow(2, (chan3_depth))-1)); //scale to 0-255

        //channel swap
        switch(order) {
        case 0:
          red = chan1;
          green = chan2;
          blue = chan3;
          break;
        case 1:
          red = chan3;
          green = chan1;
          blue = chan2;
          break;
        case 2:
          red = chan2;
          green = chan3;
          blue = chan1;
          break;
        case 3:
          red = chan3;
          green = chan2;
          blue = chan1;
          break;
        case 4:
          red = chan1;
          green = chan3;
          blue = chan2;
          break;
        case 5:
          red = chan2;
          green = chan1;
          blue = chan3;
          break;
        }

        color c = 255 << 24 |red << 16 | green << 8 | blue;
        dataSwatches.add(c);
      }
    }
    break;
  }

  //println("swatch size: "+dataSwatches.size());
  return dataSwatches;
}

//=============================
// Byte mapping functions

// converts from bytes[] to a BitSet object
BitSet bytes_to_bits(byte[] _bytes) {
  BitSet bitset = new BitSet(_bytes.length*8);
  for (int i = 0; i < _bytes.length; i++) {    
    for (int j = 0; j < 8; j++) {    
      bitset.set((i*8) + j, boolean(_bytes[i] >> j & 1));
    }
  }
  return bitset;
}

void setDepth(int depth1, int depth2, int depth3) {
  chan1_depth=depth1;
  chan2_depth=depth2;
  chan3_depth=depth3;
  rgb_depth = chan1_depth + chan2_depth + chan3_depth;
}

void setDepth(int _depth) {
  pixel_depth = _depth;
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
