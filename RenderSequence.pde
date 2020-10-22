//====================================================================================
// Converts the SARS-CoV-2 genome to a textile design for the GlitchTextiles COVID-19 collection
// Written from self-quarantine by Phillip David Stearns May 6th, 2020
// Genome source: https://www.ncbi.nlm.nih.gov/nuccore/NC_045512.2?report=fasta

//====================================================================================
// libraries

import java.util.*;
import controlP5.*;

//====================================================================================
// Global variables

//Control Frame Dimensions and Location
int controls_w = 410;
int controls_h = 540;

//main window dimensions and location
int screen_width = 768;
int screen_height = 1000;

Swatches palette, sequence, randomized;
PGraphics rendered;
byte[] rawData;
int offset, step, linearScale, sortMode;
int order = 0; // index for assigning base pair values
int order_shift = 0; // when mapped to index the palette, this shifts the index
boolean invert, PCW, mapped;
String renderMode, colorMode, diagDir;

String sequencePath;
String[] sequences, sequenceList;
int selection = 0;

boolean open = false;
String type = "DNA"; // DNA, BYTE, CHAR

public void setup() {
  size(10, 10); // final size of a PPCW throw design

  surface.setSize(screen_width+controls_w, screen_height);


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
  PCW = true;
  linearScale = 3;

  //needs to be done when setting sortMode
  sortPalette(sortMode);
  //needs to be done when new sequences are loaded
  loadSequence(sequences[selection]);

  //setup GUI
  initGUI();
  noSmooth();

  // needed to make sure all the GUI elements load before exiting setup()
  //while ( !shiftersAreLoaded() ) {
  //}
  
  background(0);
}

public void draw() {
  background(0);
  rendered = render(offset, renderMode, colorMode, invert);
  for (int i = 0; i < shifters.length; ++i) {
    if (shifters[i].isActive()) {
      shifters[i].process(rendered);
    }
  }
  image(rendered, controls_w, 0);
}
