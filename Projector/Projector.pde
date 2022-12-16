/*
Snapshot - The App
By: Max Nielsen
IAT 222 - D104
18-11-2022
*/

// --- Libraries --- //
import ddf.minim.*;
import controlP5.*;
import java.io.*;
import java.lang.*;
import java.nio.file.*;

// --- Constants --- //
// Highest level game states
final int START = 0;
final int WAITING = 1;
final int INTERACT = 2;
final int CREATING = 3;
final int DISPLAYING = 4;
final int RESTARTING = 5;
final int PAUSE = 10;

// Holding game states
int state = START;
int prevState;
boolean started = false;

String comic_path = "E:/Snapshot/data/comics/";
String session_path = "E:/Snapshot/data/sessions/";
String sessions_path = "E:/Snapshot/data/sessions/";
String img_path = "E:/IMG/";

String session_comic_path;
String session_text_path;
String session_photos_path;
String session_ai_path;


int numComics = 1; 
int session = 0; 
int numPanels = 0; // Including main comic image (0.png)
int minNumPanels = 2;  // What the smallest comic is
int currPanel = 1;

String[] userInput;

// --- Assets --- //
PFont font, fontBold, fontItalic, fontBoldItalic, fontButton;
PImage[] comic, AIComic, IRLComic;

int imgPadding;
int narrPadding;
int narrAlpha;
PVector narrPos;
PVector narrDim;
UI ui;
ControlP5 cp5;
Button play, restart, controls, resume, quit, leave, restartLevel, menu;

int timer = 120*60; // 2 mins sec

void setup() {
  createSession();
  
  // Window
  size(1200, 1080, P2D);
  surface.setLocation(100, 100);
  colorMode(RGB, 255, 255, 255, 60);  // Alpha is set to 60 to match frame rate 
  state = START;  // Starting the game at the start :>  
  ui = new UI();
  smooth();
  
  // Fonts
  font = loadFont("medium.vlw");
  fontBold = loadFont("bold.vlw");
  
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
      ui.renderStart();
      testDisplaying();
      break;
    case(DISPLAYING):
      beginDisplaying();
      ui.renderDisplaying();
      testForSessionChange();
      break;
    case(RESTARTING):
      restart();
      break;
  }
}

void testDisplaying() {
  if(!started && numOfFiles(session_text_path) == 1) {
    numPanels = numOfFiles(comic_path) - 1;
    started = true; 
  }
  if(numOfFiles(session_ai_path) == numPanels-1 && numOfFiles(session_photos_path) == numPanels-1) {
    started = false;
    delay(1000);  // Allow for image to completely transfer
    state = DISPLAYING;
  }
}

void testForSessionChange() {
  timer--;
  if(session < numOfFiles(sessions_path) - 1)
    if(numOfFiles(sessions_path + (session+1) + "/" + "/ai/") >= 2)
      state = RESTARTING;
  else if(timer < 0)
    state = RESTARTING;
  else if(timer == 119*60)
    saveFrame("session #" + session + ".png");
}

void restart() {
  comic_path = "E:/Snapshot/data/comics/";
  session_path = "E:/Snapshot/data/sessions/";
  sessions_path = "E:/Snapshot/data/sessions/";
  img_path = "E:/IMG/";
  timer = 120 * 60;
  createSession();
  state = START;
}
