//====================================================================================
// Key Bindings
// Available when the design window is active

//void keyPressed() {
  
//  float value; // temp place holder
  
//  switch(key) {
//    //order
//  case '[':
//  value = gui.cp5.getController("order").getValue();
//  if (value > 0) gui.cp5.getController("order").setValue(value-1);
//  break;
//  case ']':
//  value = gui.cp5.getController("order").getValue();
//  if (value < orders.length) gui.cp5.getController("order").setValue(value+1);
//  break;
//  //shift
//  case '{':
//  value = gui.cp5.getController("shift").getValue();
//  if (value > 0) gui.cp5.getController("shift").setValue(value-1);
//  break;
//  case '}':
//  value = gui.cp5.getController("shift").getValue();
//  if (value < palette.swatches.size()-64) gui.cp5.getController("shift").setValue(value+1);
//  break;
//  case ',': // decrease sortMode value
//    if (sortMode > 0) --sortMode;
//    break;
//  case '.':
//    if (sortMode < 6) ++sortMode;
//    break;
//  case '!':
//    selection=0;
//    break;
//  case '@':
//    selection=1;
//    break; 
//  case '#':
//    selection=2;
//    break;
//  case '$':
//    selection=3;
//    break;
//  case '-':
//    if (linearScale>1) --linearScale;
//    break;
//  case '=':
//    ++linearScale;
//    break;
//  case '1':
//    renderMode = "HORIZONTAL";
//    break;
//  case '2':
//    renderMode = "VERTICAL";
//    break;
//  case '3':
//    renderMode = "DIAGONAL";
//    break;
//  case '4':
//    renderMode = "LINEAR";
//    break;
//  case 'i':
//    invert^=true;
//    break;
//  case 'm':
//    if (colorMode.equals("AVG")) {
//      colorMode = "RGB";
//    } else if (colorMode.equals("RGB")) {
//      colorMode = "HSB";
//    } else if (colorMode.equals("HSB")) {
//      colorMode = "AVG";
//    }
//    break;
//  case 'M':
//    mapped = !mapped;
//    break;
//  case 'r':
//    randomized.randomize();
//  break;
//  case 'S':
//    saveFrame("./saved/"+sequences[selection]+"-"+offset+"-"+renderMode+"-"+colorMode+"-"+invert+".gif");
//    break;
//  }
//  switch(keyCode) {
//  case 38: //scroll up
//    offset -= step;
//    break;
//  case 40: //scroll down
//    offset += step;
//    break;
//  }

//  if (key == '!' || key == '@'|| key == '#'|| key == '$') {
//    loadSequence(sequences[selection]);
//  }

//  if (key == 'M' || key == ',' || key == '.' || key == 'r') {
//    if (mapped) sortPalette(sortMode);
//    sequence = dataToSwatches(rawData);
//  }

//  offset = (offset + sequence.size()) % sequence.size();
//}

//void keyReleased() {
//  redraw();
//}
