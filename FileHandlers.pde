String outputPath;
int frameIndex;

boolean run = true;
boolean save = false;

//====================================================================================
// Load the Sequence

public void loadSequence(String path) {
  rawData = loadBytes(path);
  sequence = dataToSwatches(rawData);
  redraw();
}
