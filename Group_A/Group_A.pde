/*
Snapshot - Group A
By: Max Nielsen
IAT 222 - D104
18-11-2022
*/

// --- Libraries --- //
import java.io.*;
import java.lang.*;
import java.nio.file.*;

// --- Constants --- //
// Highest level game states
final int START = 0;
final int WAITING = 1;
final int INTERACT = 2;
final int DISPLAY = 4;
final int RESTART = 5;

// Holding game states
int state = START;
boolean started = false;

String comic_path = "E:/Snapshot/data/comics/";
String session_path = "E:/Snapshot/data/sessions/";
String sessions_path = "E:/Snapshot/data/sessions/";
String img_path = "E:/IMG/";

String session_comic_path;
String session_text_path;
String session_photos_path;

int imgsTaken = 0;
int session = 0; 
int numPanels = 0; // Including main comic image (0.png)
int currPanel = 1;

int prevImgs;

// --- Assets --- //
PFont F_light, F_medium, F_demi, F_bold;
PImage[] comic, AIComic;

int imgPadding;
int narrPadding;
int narrAlpha;
PVector narrPos;
PVector narrDim;
UI ui;

void setup() {
  createSession();
  
  // Window
  size(1920, 1080, P2D);
  colorMode(RGB, 255, 255, 255, 60);  // Alpha is set to 60 to match frame rate 
  state = START;  // Starting the game at the start :>  
  ui = new UI();
  smooth();
  
  // Fonts
  F_light = loadFont("light.vlw");
  F_medium = loadFont("medium.vlw");
  F_demi = loadFont("demi.vlw");
  F_bold = loadFont("bold.vlw");
  
  // Text Boxes
  narrPadding = 25;
  narrAlpha = 60;
  narrDim = new PVector(900, 450);
  narrPos = new PVector(width/2, height/2);
  
  // Images
  imgPadding = 25;
}


void draw() {
  switch(state) {
    case(START):
      ui.Start();
      testStarting();
      break;
    case(WAITING):
      println("WAITING");
      ui.Wait();
      testWaiting();
      break;
    case(INTERACT):
      println("INTERACTING");
      ui.Interact();
      testInteract();
      break;
    case(DISPLAY):
      ui.Display();
      testDisplay();
      break;
    case(RESTART):
      restart();
      state = START;
      break;
  }
}

void testStarting() {
  if(numFiles(session_text_path) == 1) {
    numPanels = numFiles(comic_path) - 1;
    state = WAITING;
  }
  else if(session < numFiles(sessions_path) - 1) {
    delay(500);
    state = RESTART;
  }  
}

void testWaiting() {
  println(imgsTaken, numFiles(session_text_path));
  if(currPanel >= numPanels) {
    state = DISPLAY;
  }
  println(imgsTaken, numFiles(session_text_path));
  if(imgsTaken < numFiles(session_text_path)) {
    println("GOING DOWN A DARK PATH");
    launch("E:/IMG_SYNC.ffs_batch");
    delay(1500);
    prevImgs = numFiles(img_path);
    println("GOING DOWN A DARK PATH2");
    state = INTERACT; 
  }
}

void testInteract() { 
  launch("E:/IMG_SYNC.ffs_batch");
  delay(500);
  println(prevImgs, numFiles(img_path));
  if(prevImgs < numFiles(img_path)) {
    try {
      copyFile(getLastModified(img_path), session_photos_path + currPanel + ".jpg");
    } catch (Exception ex) {
      ex.printStackTrace(); 
    }
    processImg();
    currPanel++;
    imgsTaken++;
    println("Chaning state to waiting");
    state = WAITING;
  }
}

void testDisplay() {
  if(session < numFiles(sessions_path) - 1) {
    delay(500);
    state = RESTART;
  }
}

void restart() {
  comic_path = "E:/Snapshot/data/comics/";
  session_path = "E:/Snapshot/data/sessions/";
  sessions_path = "E:/Snapshot/data/sessions/";
  img_path = "E:/IMG/";
  createSession();
  println("test1");
  imgsTaken = 0;
  numPanels = 0;
  currPanel = 1;
  state = START;
  println("test2");
}

void processImg() {
  PImage original = loadImage(session_photos_path + currPanel + ".jpg");
  PImage cropped = createImage(600, 600, RGB);
  cropped = original.get(100, 0, 600, 600);
  cropped.save(session_photos_path + currPanel + ".jpg");
}
