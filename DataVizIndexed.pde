//====================================================================================
// Converts the SARS-CoV-2 genome to a textile design for the GlitchTextiles COVID-19 collection
// Written from self-quarantine by Phillip David Stearns May 6th, 2020
// Genome source: https://www.ncbi.nlm.nih.gov/nuccore/NC_045512.2?report=fasta

//====================================================================================
// libraries

import controlP5.*;
import java.util.*;

//====================================================================================
// Global variables

//Control Frame Dimensions and Location
int controls_w = 420;
int controls_h = 550;

boolean loading = false;

//main window dimensions and location
int graphics_width = 384;
int graphics_height = 500;
BitSet rawBits = new BitSet();
Swatches palette, sequence, randomized;
int palette_depth = 6; //bits
int palette_size = int(pow(2, palette_depth));
PGraphics rendered;
byte[] rawBytes;
int offset, step, linearScale, sortMode;
int order = 0; // index for assigning base pair values
int order_shift = 0; // when mapped to index the palette, this shifts the index
boolean invert, PCW, mapped;
String renderMode; // HORIZONTAL, VERTICAL, DIAGONAL, LINEAR
String colorMode, diagDir;

int chan1_depth=1;
int chan2_depth=1;
int chan3_depth=1;
int rgb_depth=0;
int pixel_depth=6;
int bit_offset=0;

String sequencePath;

String[] sequences, sequenceList;
int selection = 0;

boolean open = false;
String data_type = "DNA"; // DNA, BYTE

public void setup() {
  size(850, 550);

  setDepth(chan1_depth, chan2_depth, chan3_depth);

  //load the palette: convert from hex values in a .txt to Swatches object
  palette = new Swatches(loadStrings(dataPath("")+"/palette/palette.txt"));

  //create a randomized palette from a copy
  randomized = new Swatches();
  randomized.replaceSwatches(palette.copySwatches().randomize());

  //load the data for the sequences
  sequencePath = dataPath("")+"/sequences/"; //absolute path to included sequences
  sequences = new File(sequencePath).list(); //list of sequence filenames
  sequenceList = sequences.clone();
  for (int i = 0; i < sequences.length; i++) {
    sequences[i] = sequencePath+sequences[i]; //prepends absolute path to filenames
  }

  offset = 0; // start of the sequence
  step = 100; //for use with keybindings, increments offset
  diagDir = "DOWN";
  renderMode = "HORIZONTAL";
  colorMode = "RGB";
  sortMode = 0;
  PCW = false;
  linearScale = 3;

  //needs to be done when setting sortMode
  sortPalette(sortMode);
  //needs to be done when new sequences are loaded
  loadData(sequences[selection]);

  //setup GUI
  initGUI();
  noSmooth();

  background(0);
}

public void draw() {
  if (!loading) {
    background(0);
    sequence = dataToSwatches(offset);
    rendered = render(renderMode, colorMode, invert);
    for (int i = 0; i < shifters.length; ++i) {
      if (shifters[i].isActive()) {
        shifters[i].process(rendered);
      }
    }
    image(rendered, controls_w, GUIBuffer);
  }
}
