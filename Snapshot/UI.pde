// UI: Grouping all screens into a UI class just because I can :>


class UI {
  float alpha = 60;
  
  // Progress Circle
  int rotation=0;
  float el=0;
  int h=0;
  float i =0.5;
  
  int wait = 0;
  
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
  
  void renderStart() {
    renderBackground();
    resetNarrValues();
    narrPos = new PVector(width/2,height/4*1.75);
    renderNarrative("Snapshot", "by MACHINE-14", narrPos, narrDim, narrPadding, 64);
  }
  
  void renderWait() {
    renderBackground();
    renderProgressCircle();
    resetNarrValues();
    narrPos = new PVector(width/2,height/3*2);
    narrDim = new PVector(600, 150);
    narrPadding = 15;
    renderNarrative("Please Standby...", "Waiting for white to begin.", narrPos, narrDim, narrPadding, 36);
  }
 
  void renderInteract() {
    renderBackground();
    resetNarrValues();
    narrPos = new PVector(width/2,height/6);
    narrDim = new PVector(2000, 200);
    renderNarrative("Describe the Comic - Panel #" + currPanel, "Write a one sentence description of the comic panel below.", narrPos, narrDim, narrPadding, 48);
    renderComic();
    renderComicPanel(currPanel);
  }
  
  void renderComic() {
    imageMode(CORNER);
    writeTitle(new PVector(96+256, height/2 - 128-24), "Full Comic", 0, 36);
    image(comic[0], 96, height/2 - 128 + 24, 512, 256);
  }
  
  void renderComicPanel(int panelNum) {
   imageMode(CENTER);
   PImage img = comic[panelNum];
   image(img, width/2, height/2 + imgPadding, 512, 512);
  }
  
  void renderCreating() {
    resetNarrValues();
    narrPos = new PVector(width/2,height/6);
    narrDim = new PVector(2000, 200);
    renderBackground();
    renderProgressCircle();
    renderNarrative("Please Standby...", "Creating images...", narrPos, narrDim, narrPadding, 36);
  }
  
  void renderDisplaying() {
    resetNarrValues();
    renderBackground();
    renderNarrative("Complete!", "Please look at projector for final results.", narrPos, narrDim, narrPadding, 36);
    //renderComic();
    //renderAIComic();
  }
  
  void renderAIComic() {
    imageMode(CENTER);
    float i = numPanels/2 * -1 * 256;
    for(int j = 0; j < numPanels-1; j++) {
      i += 256;
      image(AIComic[j], width/2 + int(i), 512-imgPadding*2, 256, 256);
    }
  }
  
  void renderRestart() {
    renderBackground();
    
    
  }
  
  void renderPause() {
    renderBackground();
    
    
  }
  
  // Render the dialogue with the title, the content, and the positions. Was going to do a fade animation but ran out of time
  void renderNarrative(String speaker, String text, PVector pos, PVector dim, int padding, int alpha) {
    renderTextBox(pos, dim, padding, alpha);
    writeTitle(pos, speaker, padding, alpha);
    writeText(pos, text, padding, alpha);
  }
  
    // Render the text box
  void renderTextBox(PVector pos, PVector dim, int padding, int alpha) {
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
    textFont(fontBold);
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
    textFont(font);
    textSize(size/2);
    fill(250, narrAlpha);
    pushMatrix();
    translate(pos.x, pos.y + padding);
    text(text, 0, 0);
    popMatrix();
  }
  
}
