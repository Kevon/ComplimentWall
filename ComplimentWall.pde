import processing.video.*;
import blobDetection.*;

import codeanticode.gsvideo.*;

GSCapture video;

int tolerance = 200;

int numPixels;
int[] backgroundPixels;
//Capture video;

int fWidth = 640;
int fHeight = 480;

int b = 0;
int w = 255;

boolean flip = false;
boolean mode = true;

Compliment compliment = new Compliment();

void setup() {

  size(fWidth, fHeight, P2D); 
  
  String[] devices = Capture.list();
  println(devices);
  video = new GSCapture(this, fWidth, fHeight, "Sony HD Eye for PS3 (SLEH 00201)");  
  video.start();
  numPixels = video.width * video.height;
  
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
    
  loadPixels();
  
  smooth();
  
 PFont helvetica = loadFont("HelveticaNeue-Bold-24.vlw");
  
  textFont(helvetica);
}

void draw() {
  if (video.available()){
    int firstX = 0;
    int firstY = 0;
    
    boolean firstWhite = false;
    boolean firstBlack = true;
    
    boolean onScreen = false;

    video.read(); // Read a new video frame

    video.loadPixels(); // Make the pixels of video available
    
    fastBlur(video, 10);

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    
      int y = i/video.width +1;
      int x = video.width-((video.width*y)-i);

      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];

      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      
      int diff = diffR + diffG + diffB;
      
      if (diff > tolerance){
        if (mode == false){
         pixels[i] = color(w, w, w);
        }
        else{
         pixels[i] = color(b, b, b);
        }
         if (firstWhite == false){
           firstWhite = true;
         }
           
           
         if (firstX == 0 && firstWhite == true && firstBlack == true){
            firstX = x;
            firstY = y;
         }
         
         onScreen = true;
      }
      else{
         pixels[i] = color(b, b, b);
         
         if (firstBlack == false && firstWhite == true){
           firstBlack = true;
         }
      }
    }
    video.updatePixels();
    
    if(flip == false){
    compliment.updateLocation(firstX,firstY);
    }
    else if(flip == true){
    compliment.updateLocation(fWidth-firstX,firstY);
    }
    
    if (onScreen == true){
    compliment.drawCompliment();
    }
}
  
}

class Compliment{
  int cY = 0;
  int avgX = 0;
  int previousX = 0;
  int changeInX = 0;
  int avgLength = 5;
  String compliment = "I love you.";
  int l = 0;
  int j = 0;
  int[] avg;
  int[] change;
  String[] compliments;
  
  Compliment(){
  avg = new int[avgLength];
  for (int i = 0; i < avgLength-1; i++){
    avg[i] = 0;
  }
  change = new int[avgLength];
  for (int i = 0; i < avgLength-1; i++){
    change[i] = 0;
  }
  
  compliments = new String[34];
  
  
  compliments[0] = "You're awesome.";
  compliments[1] = "You seem nice.";
  compliments[2] = "You have nice hair.";
  compliments[3] = "I like your outfit.";
  compliments[4] = "That's a nice shirt.";
  compliments[5] = "You have kind eyes.";
  compliments[6] = "You're special.";
  compliments[7] = "You seem smart.";
  compliments[8] = "You have a great voice.";
  compliments[9] = "Your friends are lucky to know you.";
  compliments[10] = "I like you.";
  compliments[11] = "You're so cool.";
  compliments[12] = "You're fun to be around.";
  compliments[13] = "You have good taste in music.";
  compliments[14] = "You seem really photogenic.";
  compliments[15] = "I love you.";
  compliments[16] = "You're in really good shape.";
  compliments[17] = "You look great.";
  compliments[18] = "You're really friendly.";
  compliments[19] = "You're amazing.";
  compliments[20] = "Nice shoes.";
  compliments[21] = "You're super intelligent.";
  compliments[22] = "You're good at what you do.";
  compliments[23] = "You're a 10 out of 10.";
  compliments[24] = "You seem like a fun person.";
  compliments[25] = "You're funny.";
  compliments[26] = "You have a great sence of humor.";
  compliments[27] = "You seem really confident.";
  compliments[28] = "You win at life.";
  compliments[29] = "You have a nice teeth.";
  compliments[30] = "I like your smile.";
  compliments[31] = "You're a fantastic person.";
  compliments[32] = "You're important.";
  compliments[33] = "You're #1!";
  
  newCompliment();
  }
  
  void newCompliment(){
      int num = int(random(compliments.length));
  compliment = compliments[num];
  }
  
  void updateLocation(int x, int y){
    previousX = avgX;
    avg[l] = x;
    l = l+1;
    if(l > avgLength-1){
      l = 0;
    }

    avgX = findAvg(avg);

    cY = y;
    
    if (x == 0 && y == 0){
      newCompliment();
  }
  }
  
  void drawCompliment(){
    int changeInX = avgX - previousX;
    change[j] = changeInX;
        
    if(changeInX > 50){
      newCompliment();
    }
    
    j = j+1;
    if(j > avgLength-1){
      j = 0;
    }
    int avgChange = findAvg(change);
    textSize(24);
    textAlign(CENTER);
    fill(255, 255, 255);

    text(compliment, ((avgX+avgChange*15)+50), (cY+(Math.abs(avgChange)*3))-50); 

  }
  
  int findAvg(int[] a){
    int sum = 0;
    for (int i = 0; i < avgLength-1; i++){
     sum += a[i];
    }
    return(Math.round(sum/avgLength));
  }
}

void keyPressed() {
  if (key == ' '){
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
  }
  else if (keyCode == ENTER){
      negative();
  }
  else if (keyCode == BACKSPACE){
      flip = !flip;
      print(flip);
  }
  else if (keyCode == SHIFT){
      mode = !mode;
  }
  if (key == CODED){
    if (keyCode == UP) {
      tolerance = tolerance+1;
    }
    else if (keyCode == DOWN){
      tolerance = tolerance-1;
    }
}
}

void negative(){
  int temp = 0;
  temp = b;
  b = w;
  w = temp;
  print(w);
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================

void fastBlur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}
