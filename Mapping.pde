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
