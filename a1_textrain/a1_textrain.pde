/**
    CSci-4611 Assignment #1 Text Rain
**/


import processing.video.*;

// Global variables for handling video data and the input selection screen

String[] cameras;
Capture cam;
Movie mov;
PImage inputImage;
PImage img;
boolean inputMethodSelected = false;
PFont f;
String[] messages;
//String message = "THIS IS A TEXT RAIN";
int threshold = 100;
Boolean debug_flag = false;
Letter[][] letters;
int count = 0;
int letternum = 3;
int j = 0;


void setup() {
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  img = createImage(width, height, RGB);
  letters = new Letter[letternum][width]; 
  f = loadFont("Times-Bold-20.vlw");
  textFont(f);
  messages = new String[letternum];
  messages[0] = "THIS IS A TEXT RAIN";
  messages[1] = "new rain added to the scene";
  messages[2] = "This is for CSCI4611";
}


void draw() {
  // When the program first starts, draw a menu of different options for which camera to use for input
  // The input method is selected by pressing a key 0-9 on the keyboard
  if (!inputMethodSelected) {
    cameras = Capture.list();
    int y=40;
    text("O: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
    y += 40; 
    for (int i = 0; i < min(9,cameras.length); i++) {
      text(i+1 + ": " + cameras[i], 20, y);
      y += 40;
    }
    return;
  }


  // This part of the draw loop gets called after the input selection screen, during normal execution of the program.

  
  // STEP 1.  Load an image, either from a movie file or from a live camera feed. Store the result in the inputImage variable
  
  if ((cam != null) && (cam.available())) {
    cam.read();
    img.copy(cam, 0,0,cam.width,cam.height, 0,0,inputImage.width,inputImage.height);
    
    for (int i = 0; i < img.pixels.length; i++) { //mirror image
      inputImage.pixels[i] = img.pixels[i-i%img.width+(img.width-1)-i%img.width];
    }

    inputImage.filter(GRAY);
    inputImage.filter(BLUR,2);
  }
  else if ((mov != null) && (mov.available())) {
    mov.read();
    inputImage.copy(mov, 0,0,mov.width,mov.height, 0,0,inputImage.width,inputImage.height);
  }
  
  if (debug_flag) {
    inputImage.filter(THRESHOLD, ((float)threshold/255));
    set(0, 0, inputImage);  
  
  } else {
    set(0, 0, inputImage);  
  }
  // Fill in your code to implement the rest of TextRain here..
  inputImage.loadPixels();
  
  if (count == 0) {
    int x = int(random(1,8));
    color c = color(random(0,255), random(0,255), random(0,255));
    for (int i = 0; i < width; i++) {  
      letters[j][i] = new Letter(x,int(random(-100 * 4, 0)),messages[j].charAt(i % messages[j].length()), c); 
      x += int(random(1,5)) * textWidth(messages[j].charAt(i % messages[j].length()));
    }
  }
  for (int k = 0; k <= j; k++) {
    for (int i = 0; i < letters[j].length; i++) {
      letters[k][i].display();
      if (letters[k][i].y >= 0 & letters[k][i].y < 719 & letters[k][i].x >= 0 & letters[k][i].x < 1280) {
          if (green(inputImage.pixels[inputImage.width * (letters[k][i].y) + letters[k][i].x]) <= threshold) {
            letters[k][i].liftup();
          } else {
            letters[k][i].dropdown(); 
          }
      } else {
          letters[k][i].dropdown(); 
     }
    }   
   }
  count++;
  
  if (count == 200) {
    if (j < letternum - 1) {
      count = 0;
      j++;
    }
  }
      

}

// A class to describe a single Letter
class Letter {
  char letter;
  int x,y;
  int dropspeed = int(random(1,5));
  int upspeed = 10;
  color colr;

  Letter (int x_, int y_, char letter_, color c) {
    x = x_;
    y = y_;
    letter = letter_; 
    colr = c;
  }

  // Display the letter
  void display() {
    fill(colr);
    textAlign(LEFT);
    text(letter,x,y);
  }

  // letters drop down
  void dropdown() {
    y += dropspeed;
    if (y > 720) {
      y = int(random(-100, 0));
      dropspeed = int(random(1,5));
    }
  }
  
  //letters move up
  void liftup() {
    y -= upspeed;
  }
}

void keyPressed() {
  
  if (!inputMethodSelected) {
    // If we haven't yet selected the input method, then check for 0 to 9 keypresses to select from the input menu
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        println("Offline mode selected.");
        mov = new Movie(this, "TextRainInput.mov");
        mov.loop();
        inputMethodSelected = true;
      }
      else if ((input >= 1) && (input <= 9)) {
        println("Camera " + input + " selected.");           
        // The camera can be initialized directly using an element from the array returned by list():
        cam = new Capture(this, cameras[input-1]);
        cam.start();
        inputMethodSelected = true;
      }
    }
    return;
  }


  // This part of the keyPressed routine gets called after the input selection screen during normal execution of the program
  // Fill in your code to handle keypresses here..
  
  if (key == CODED) {
    if (keyCode == UP) {
      // up arrow key pressed
      threshold += 10;
    }
    else if (keyCode == DOWN) {
      // down arrow key pressed
      threshold -= 10;
    }
  }
  else if (key == ' ') {
     debug_flag = !debug_flag;
  } 
  
}
