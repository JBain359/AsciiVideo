import processing.video.*;

Capture video;

boolean toggleColorScreen = false;
float screenOpacity = 50;

int charSet = 1;

boolean toggleAscii = true;

//array of characters in order of how dense they are
char[] charGradient =  { '$' , '@' , 'B' , '%' , '8' , '&' , 'W' , 'M' , '#' , '*' , 'o' , 'a' , 'h' , 'k' , 'b' , 'd' , 'p' , 'q' , 'w' , 'm' , 'Z' , 'O' , '0' , 'Q' ,
                         'L' , 'C' , 'J' , 'U' , 'Y' , 'X' , 'z' , 'c' , 'v' , 'u' , 'n' , 'x' , 'r' , 'j' , 'f' , 't' , '/' , '|' , '(' , ')' , '1' , '{' ,
                         '}' , '[' , ']' , '?' , '-' , '_' , '+' , '~' , '<' , '>' , 'i' , '!' , 'l' , 'I' , ';' , ':' , ',' , '"' , '^' , '`' , '`' , '.' ,  ' '} ;
int characterWidth = 7; 
color bg = color(255);

PFont f;

void setup(){
  size(640,480);
  video = new Capture(this, width, height);
  video.start();
  f = createFont(PFont.list()[charSet], characterWidth);
  textFont(f);
  noStroke();
}

void captureEvent(Capture video){
  video.read();
}

void draw(){

    if(toggleAscii){
      Asciiize(video);
    }else{
    loadPixels();
    image(video,0,0);
    }
  
}

void Asciiize(PImage image){
  
  loadPixels();
  background(bg);

  
  int loc = 0;
  //loop through all of the pixels
  for(int x = 0 ; x < width; x+=characterWidth){
    for(int y = 0; y < height; y+=characterWidth){
      //calculate where it is that the pixel is located in the pixels Array
      loc = x + y*image.width;
      color currentColor = image.pixels[loc];
      
      //creates a color screen that makes the color of the frame and ascii pop a bit more
      if(toggleColorScreen){
        fill(currentColor,screenOpacity);
        rect(x,y,characterWidth,characterWidth);
      }
      
      //sets color for the ascii
      fill(currentColor);
      //finding how dark the color is
      float r = red(currentColor);
      float g = green(currentColor);
      float b = blue(currentColor);
      float avgC = (r+b+g)/3;
      //fill(avgC); //grayscale
      
      //finding the right character for how dark the color is
      int charDensity = int(map(avgC,0,255,0,charGradient.length-1));
      char stroke = charGradient[charDensity];
         
      text(stroke,x,y);
    }
  }
  
}

void keyPressed(){
   if(key == ' '){
     toggleAscii = !toggleAscii;
   }
   if(key == 'c')
     toggleColorScreen = !toggleColorScreen;
   
   //changing the size of the characters that will represent the frame
   if(keyCode == UP){
     characterWidth += 1;
     textSize(characterWidth);   
   }
   else if(keyCode == DOWN){
     characterWidth-=1;
     textSize(characterWidth);   
   }
   else if(keyCode == RIGHT){ //changing the font
     charSet += 1;
     if(charSet>=PFont.list().length)
       charSet = 0;
     f = createFont(PFont.list()[charSet], characterWidth);
     textFont(f);  
   }
   else if(keyCode == LEFT){
     charSet-=1;
     if(charSet<0)
       charSet = PFont.list().length-1;
     f = createFont(PFont.list()[charSet], characterWidth);
     textFont(f);  
   }
}

void mouseClicked(){
  saveFrame("/output/capture####.jpg");
}
