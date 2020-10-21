//====================================================================================
// sortPalette

public void sortPalette(int mode) {
  switch(mode) {
  case 0:
    Collections.sort(palette.swatches, new SwatchSortColor());
    break;
  case 1:
    Collections.sort(palette.swatches, new SwatchSortHue());
    break;
  case 2:
    Collections.sort(palette.swatches, new SwatchSortSaturation());
    break;
  case 3:
    Collections.sort(palette.swatches, new SwatchSortBrightness());
    break;
  case 4:
    Collections.sort(palette.swatches, new SwatchSortBrightSat());
    break;
  case 5:
    Collections.sort(palette.swatches, new SwatchSortSatBright());
    break;
  case 6:
    palette=randomized.copySwatches();
    break;
  }
}

//====================================================================================
// Comparators

public class SwatchSortColor implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return s2.getColor() - s1.getColor();
  }
}

public class SwatchSortHue implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return int(100*s1.getHue() - 100*s2.getHue());
  }
}

public class SwatchSortSaturation implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return int(100*s1.getSaturation() - 100*s2.getSaturation());
  }
}

public class SwatchSortBrightness implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return int(100*s2.getBrightness() - 100*s1.getBrightness());
  }
}

public class SwatchSortBrightSat implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return int(100*(s2.getBrightness()-s2.getSaturation()) - 100*(s1.getBrightness()-s1.getSaturation()));
  }
}

public class SwatchSortSatBright implements Comparator<Swatch> {
  @Override
  public int compare(Swatch s1, Swatch s2) {
    return int(100*(s2.getSaturation()+s2.getBrightness()) - 100*(s1.getSaturation()+s1.getBrightness()));
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
