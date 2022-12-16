void createSession() {
  //numComics = numOfFiles(comic_path);
  session = numOfFiles(session_path);
  println(session);
  comic_path = "comics/" + numComics + "/";
  session_path = "sessions/" + session + "/";
  
  session_comic_path = session_path + "comic/";
  session_text_path = session_path + "text/";
  session_photos_path = session_path + "photos/";
  session_ai_path = session_path + "ai/";
  

  File path = new File(dataPath(session_path));
  path.mkdir();
  path = new File(dataPath(session_comic_path));
  path.mkdir();
  path = new File(dataPath(session_text_path));
  path.mkdir();
  path = new File(dataPath(session_photos_path));
  path.mkdir();
  path = new File(dataPath(session_ai_path));
  path.mkdir();
 }

void createButton() {
  cp5 = new ControlP5(this);
  color c1 = color(255);  // Text colour
  color c = color(0, 0, 0, .24);  // Button background colour 

  // Play button
  play = cp5.addButton("Play", 0, width/2 - 125, height/16*11, 250, 80);
  play.getCaptionLabel().setFont(font);  // Font
  play.getCaptionLabel().alignX(ControlP5.CENTER);  // Font alignment
  play.setColorLabel(c1);                // Font colour
  play.setColorForeground(c);            // Can't remember
  play.setColorBackground(c);            // Regular button colour
  play.setColorActive(c);                // Hover button colour
  play.getCaptionLabel().setSize(72);    // Font size
  // When hovering...
  play.onEnter(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
    play.setColorLabel(#72D807);
  } } );
  // When leaving button...
  play.onLeave(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
    play.setColorLabel(color(255));
  } } );
  // When clicked... play the game
  play.onClick(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
    play.hide();
    state = WAITING;
  } } ); 
}

void resetNarrValues() {
  narrPadding = 25;
  narrAlpha = 60;
  narrDim = new PVector(900, 450);
  narrPos = new PVector(width/2, height/2);
}
