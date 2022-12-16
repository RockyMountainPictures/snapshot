void chooseComic() {
  // Init comic + frames
  int rand = floor(random(numComics)) + 1;
  comic_path = "comics/" + rand + "/";
  println(rand, " ", comic_path);
  numPanels = numOfFiles(comic_path);
  
  println("Number of Panels: " + numPanels);
  println("Number of Random: " + rand);
  println("Comic Path: " + comic_path);
  
  userInput = new String[numPanels-1];
  comic = new PImage[numPanels];
  loadPanels(comic, comic_path);
  
  // Test copying times
  int start = millis();
  
  try {
    copyFiles(comic_path, session_comic_path, numPanels, ".png");
  }
  catch (IOException e) {
    println("Error: Can't open file!");
  }  
  
  int end = millis();
  int duration = end-start;
  println("Time Elapsed Copying: " + duration);
  state = INTERACT;
}

// Load sequential panles into array by their name
// Naming Scheme: Entire comic should be 0.png, first panel 1.png, last panel numPanels.png
void loadPanels(PImage[] array, String name) {
  for(int i = 0; i < array.length; i++)
      array[i] = loadImage(name + i + ".png");
}

void loadIRLPanels(PImage[] array, String name) {
  for(int i = 0; i < array.length; i++)
      array[i] = loadImage(name + (i+1) + ".jpg");
}

// Finds the number of files in a folder using java.io & java.lang.
int numOfFiles(String folder) {
  File file = new File(dataPath(folder));
  String[] listPath = file.list();
  return listPath.length;
}

// Copy files from source to destination. Uses java.nio.file;
void copyFiles(String source_path, String dest_path, int numFiles, String extension) throws IOException {
  for(int i = 0; i < numFiles; i++) {
    File source = new File(dataPath(source_path + i + extension));
    File dest = new File(dataPath(dest_path + i + extension));
    Files.copy(source.toPath(), dest.toPath());
  }
}

// Copy files from source to destination. Uses java.nio.file;
void copyFile(String source_path, String dest_path) throws IOException {
    File source = new File(dataPath(source_path));
    File dest = new File(dataPath(dest_path));
    Files.copy(source.toPath(), dest.toPath());
}


void testForStart() {
  if(numOfFiles(session_comic_path) > minNumPanels) {
    delay(1000);  // Allow for all the panels to transfer over
    state = INTERACT;
  }
}

void testForAIImages() {
  if(numOfFiles(session_ai_path) == numPanels-1) {
    started = false;
    delay(1000);  // Allow for image to completely transfer
    state = DISPLAYING;
  }
}

void beginDisplaying() {
  if(!started) {
    
    comic = new PImage[numPanels];
    loadPanels(comic, session_comic_path);
    AIComic = new PImage[numPanels-1];
    println("testing the loading of panels");
    loadPanels(AIComic, session_ai_path);
    IRLComic = new PImage[numPanels-1];
    loadIRLPanels(IRLComic, session_photos_path);
    started = true;
    delay(100);
  }
}

String insertNewLines(String sentence, int index) {
  int lines = floor(sentence.length()/index);
  for(int j = 0; j < lines; j++) {
    int i = index * (j + 1);
    if(i > sentence.length()) {
      i = sentence.length();
    }
    char c = sentence.charAt(i);
    while(c != ' ' && i > 1) {
      i--;
      c = sentence.charAt(i);
    }
    sentence = insert(sentence, "\n", i);
  }
  return sentence;
}

String insert(String original, String toInsert, int position){
  String p1 = original.substring(0,position);
  String p2 = original.substring(position+1);
  return p1 + toInsert + p2;
}
