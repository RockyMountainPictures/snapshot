// UI: Grouping all screens into a UI class just because I can :>


class UI {
  float alpha = 60;
  
  // Progress Circle
  int rotation=0;
  float el=0;
  int h=0;
  float i =0.5;
  
  // Render backgrond image
  void renderBackground() {
  background(10, alpha);  // Solid color behind
  imageMode(CORNERS);
  }
  
  void renderProgressCircle() {
  alpha = 10;
  pushMatrix();
  colorMode(HSB,100);
  translate(width/2,height/2 - narrDim.y/2);
  rotate(rotation);
  fill(h,100,100,50);
  noStroke();
  ellipse(el,el, 25, 25);
  rotation += 60;
  if(el > 60 || el < 0)
     i *= -1;
  el=(el+i)%150;
  h=(h+1)%100;
  popMatrix();
  colorMode(RGB, 255, 255, 255, 60);
  }
  
  void Start() {
    renderBackground();
    renderNarrative("Snapshot", "by MACHINE-14", narrPos, narrDim, narrPadding, 64);
    resetNarrValues();
    writeText(new PVector(width/2, 150), "Please begin on the other side", 0, 64);
    writeText(new PVector(width/2, height - 164), "Please begin on the other side", 0, 64);
  }
  
  void Wait() {
    renderBackground();
    renderProgressCircle();
    narrPos = new PVector(width/2,height/3*2);
    narrDim = new PVector(2000, 200);
    narrPadding = 15;
    renderNarrative("Please Standby...", "Waiting for the other side.", narrPos, narrDim, 20, 48);
  }

  void Interact() {
    renderBackground();
    String[] input = loadStrings(session_text_path + currPanel + ".txt");
    String sentence = input[0];
    resetNarrValues();
    narrPos = new PVector(width/2,height/4);
    narrDim = new PVector(2000, 250);
    renderNarrative("Acting Time - Panel #" + currPanel, "Act out a scene according to the sentence below.\nTake a picture of your scene using the remote.", narrPos, narrDim, narrPadding-5, 48);
    int index = 20;
    if(sentence.length() > index)
      sentence = insertNewLines(sentence, index);
    writeText(new PVector(width/2, height/3*2), '"' + sentence + '"', 0, 64);
  }
  
  void Display() {
    renderBackground();
    resetNarrValues();
    renderNarrative("Complete!", "Your part is finished.\nPlease look at the projector for the final results.", narrPos, narrDim, narrPadding, 64);
  }
  
  // Render the dialogue with the title, the content, and the positions. Was going to do a fade animation but ran out of time
  void renderNarrative(String speaker, String text, PVector pos, PVector dim, int padding, int alpha) {
    renderTextBox(pos, dim, alpha);
    writeTitle(pos, speaker, padding, alpha);
    writeText(pos, text, padding, alpha);
  }
  
    // Render the text box
  void renderTextBox(PVector pos, PVector dim, int alpha) {
    fill(20, alpha);
    stroke(250, alpha);
    strokeWeight(2);
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rect(0, 0, dim.x, dim.y);
    popMatrix();
  }
  
  // Render the title/speaker
  void writeTitle(PVector pos, String speaker, int padding, int size) {
    textAlign(CENTER, TOP);
    textFont(F_bold);
    textSize(size);
    fill(250, narrAlpha);
    pushMatrix();
    translate(pos.x, pos.y - padding*2);
    text(speaker, 0, 0);
    popMatrix();
  }
  
  // Render the dialogue
  void writeText(PVector pos, String text, int padding, int size) {
    textAlign(CENTER, TOP);
    textFont(F_medium);
    textSize(size/2);
    fill(250, narrAlpha);
    pushMatrix();
    translate(pos.x, pos.y + padding);
    text(text, 0, 0);
    popMatrix();
  }
  
}
