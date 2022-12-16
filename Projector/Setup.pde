void resetNarrValues() {
  narrPadding = 25;
  narrAlpha = 60;
  narrDim = new PVector(900, 450);
  narrPos = new PVector(width/2, height/2);
}

void createSession() {
  //numComics = numOfFiles(comic_path);
  session = numOfFiles(session_path) - 1;
  println(session);
  session_path = session_path + session + "/";
  
  session_comic_path = session_path + "comic/";
  session_text_path = session_path + "text/";
  session_photos_path = session_path + "photos/";
  session_ai_path = session_path + "ai/";
  
  
  numPanels = numOfFiles(comic_path) - 1;
  
 }
