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

String comic_path = "comics/";
String session_path = "sessions/";
String couldNotGenerateIMG = "oops.png";

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
PImage[] comic, AIComic;

int imgPadding;
int narrPadding;
int narrAlpha;
PVector narrPos;
PVector narrDim;
UI ui;
ControlP5 cp5;
Button play;

int timer = 15*60; // 15 sec

void setup() {
  createSession();
  
  // Window
  size(1920, 1080, P2D);
  colorMode(RGB, 255, 255, 255, 60);  // Alpha is set to 60 to match frame rate
  surface.setLocation(100, 100);
  state = START;  // Starting the game at the start :>  
  ui = new UI();
  smooth();
  
  // Fonts
  font = loadFont("medium.vlw");
  fontBold = loadFont("bold.vlw");
  fontButton = loadFont("button-b.vlw");
  
  // Text Boxes
  narrPadding = 25;
  narrAlpha = 60;
  narrDim = new PVector(900, 450);
  narrPos = new PVector(width/2, height/2);
  
  // Images
  imgPadding = 25;
  
  // Buttons
  createButton();
}

void draw() {
  switch(state) {
    case(START):
      ui.renderStart();
      break;
    case(WAITING):
      chooseComic();
      break;
    case(INTERACT):
      ui.renderInteract();
      handleInteraction();
      break;
    case(CREATING):
      ui.renderCreating();
      testForAIImages();
      break;
    case(DISPLAYING):
      beginDisplaying();
      ui.renderDisplaying();
      timer--;
      if(timer < 0)
        state = RESTARTING;
      break;
    case(RESTARTING):
      restart();
      break;
    case(PAUSE):
      ui.renderPause();
      break;
  }
}

void restart() {
 comic_path = "comics/";
 session_path = "sessions/";
 couldNotGenerateIMG = "oops.png";
 session = 0; 
 numPanels = 0; // Including main comic image (0.png)
 minNumPanels = 2;  // What the smallest comic is
 currPanel = 1;
 timer = 15*60; // 15 sec
 createSession();
 resetNarrValues();
 play.show();
 started = false;
 comic = null;
 AIComic = null;
 state = START;
}
