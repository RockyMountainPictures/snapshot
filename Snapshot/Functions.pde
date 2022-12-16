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
  timer--;
  if(timer < 0) {
    println("Cannot retrieve image");
    for (int i = 0; i < numPanels-1; i++) {
      File f = new File(session_ai_path + i + ".png");
      if(!f.isFile()) {
        try {
          copyFile(couldNotGenerateIMG, session_ai_path + i + ".png");
        } catch (Exception ex) {
          ex.printStackTrace(); 
        }
      }
    }
    state = DISPLAYING;
  }
}

void beginDisplaying() {
  if(!started) {
    AIComic = new PImage[numPanels-1];
    println("testing the loading of panels");
    loadPanels(AIComic, session_ai_path);
    started = true;
    timer = 10*60;  // 5 sec
    delay(100);
  }
}

void handleInteraction() {
  if (!started) {
    initInteractGUI();
    started = true;
  }
}

void initInteractGUI() {
  cp5.addTextfield("Input").setPosition(width/2 - 296, height - 200).setSize(400, 50).keepFocus(true).setAutoClear(false).setFocus(true).setFont(fontButton);
  cp5.addBang("Next").setPosition(width/2 + 156, height - 200 - 5).setSize(150, 60).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setFont(fontButton);
}

void Next() {
  String input[] = {cp5.get(Textfield.class,"Input").getText()};
  cp5.get(Textfield.class,"Input").clear();
  saveStrings("data/" + session_text_path + currPanel + ".txt", input);
  try {
      exec("python", "E:\\AI_" + currPanel + ".py", "E:\\Snapshot\\data\\sessions\\" + session + "\\text\\" + currPanel + ".txt", str(session));
    } catch (Exception ex) {
         ex.printStackTrace();
    }
  if(currPanel == numPanels-1) {
    cp5.get(Textfield.class,"Input").hide();
    cp5.get(Bang.class,"Next").hide();
    started = false;
    state = CREATING;
  }
  currPanel++;
}
