String outputPath;
int frameIndex;

boolean run = true;
boolean save = false;

//====================================================================================
// Open functions

//====================================================================================
// Save functions

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

//====================================================================================
// Load the Sequence

public void loadSequence(String path) {
  rawData = loadBytes(path);
  sequence = dataToSwatches(rawData);
  redraw();
}
