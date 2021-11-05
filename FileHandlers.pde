String outputPath;
String inputPath;
int frameIndex;

boolean run = true;
boolean save = false;

//====================================================================================
// Save functions

  public void open_file() {
    selectInput("Select a file to process:", "inputSelection");
  }

  public void inputSelection(File input) {
    if (input == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + input.getAbsolutePath());
      inputPath=input.getAbsolutePath();
      outputPath=inputPath;
      loadData(inputPath);
    }
  }

public void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    save_still(output.getAbsolutePath());
  }
}

void save_still(String thePath) {
  if (PCW) rendered=PCWScale(rendered);
  rendered.save(thePath);
}


public void save_batch() {
  if (!inputPath.equals("")) {
    selectFolder("Select a file to process:", "batchSelection");
  } else {
    println("Can't batch process. Input file not selected.");
  }
}

public void batchSelection(File dir) {
//  if (dir == null) {
//    println("Window was closed or the user hit cancel.");
//  } else {
//    println("User selected " + dir.getAbsolutePath());
//    outputPath=dir.getAbsolutePath();
//    int last_bit_offset = bit_offset;
//    int last_swap_mode = swap_mode;
//    for (int i = 0; i < pixel_depth; ++i) {
//      for (int j = 0; j < 6; ++j) {
//        cp5.get(Slider.class, "set_bit_offset").setValue(i);
//        swap_mode(j);
//        cp5.get(RadioButton.class, "swap_mode").activate(j);
//        render = bits_to_pixels(raw_bits);
//        saveData(outputPath+"/"+generateFilename());
//      }
//    }
//    bit_offset = last_bit_offset;
//    swap_mode = last_swap_mode;
//  }
}
//====================================================================================
// Load the Sequence

public void loadData(String path) {
  loading = true;
  rawBytes = loadBytes(path);
  rawBits = new BitSet();
  rawBits = bytes_to_bits(rawBytes);
  sequence = dataToSwatches(offset);
  loading = false;
}
