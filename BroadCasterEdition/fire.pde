int Fdamp = 8;
int Friprad = 3;
int FplayingNum = 0;
float FFdisturbtime = 0;

PImage myImage2;
int[] Flastmap;
int[] Fripplemap;
int[] texture2;


void inifireBuffer(){
  Flastmap = new int[width * height];
  Fripplemap = new int[width * height];
  for( int i = 0; i < width * height; i++){
    Fripplemap[i] = 0;
    Flastmap[i] = 0;
   }  
 
  myImage2 = loadImage("fire.jpg");//fire
  myImage2.resize(width, height);
  myImage2.loadPixels();
  texture2 = myImage2.pixels;
}

void fire(){
  Fdisturb(floor(clientMouse.x) , floor(clientMouse.y));
  FgetCurrent();   
}

void FgetCurrent(){
  int loseSpeed  = floor(map(FplayingNum, 0, 12, 7, 4));
  loadPixels();
  for( int y = 1; y < height -1 ; y++ ){
    for ( int x = 1; x < width -1; x++){
      int index = y * width + x;
      Fripplemap[index] = ( Flastmap[index + 1] + Flastmap[index - 1] + Flastmap[index - width] + Flastmap[index + width])/2 - Fripplemap[index];
      // for Fdamping  
     // Fripplemap[index] -= Fripplemap[index] >> floor(random(4,8));
      Fripplemap[index] -= Fripplemap[index] >> loseSpeed;
      //rendering the water
      if(Flastmap[index] != Fripplemap[index]){
        int Xoffset = Fripplemap[index - 50] - Fripplemap[index + 50];
        //int Yoffset = Fripplemap[index - width] - Fripplemap[index + width];
        
        int Yindex1 = index - 20 * width;
        int Yindex2 = index + 20 * width;
        if(Yindex1 < 0) Yindex1 = 0;
        if(Yindex2 > width * height) Yindex2 = width * height -1;
        int Yoffset = Fripplemap[Yindex1] - Fripplemap[Yindex2];
    
        int Newind = (y + Yoffset) * width + x + Xoffset;
        int newX = Newind % width;
        int newY = Newind / width;
        //check bounce
        if( newX < 1) newX = 1;
        if( newX > width - 1) newX = width -1;
        if( newY < 1) newY = 1;
        if( newY > height -1) newY = height -1;
        pixels[index] = texture2[newY * width + newX];       
      }
      if(Fripplemap[index] < 1 && Fripplemap[index] > -1) Fripplemap[index] = 0;
    }
  }
  updatePixels();
  //swap
  int[] temp = new int[width * height];
  temp = Flastmap;
  Flastmap = Fripplemap;
  Fripplemap = temp;
}

boolean Fcomeout = false;
boolean RFcomeout = false;
void Fdisturb(int dx, int dy){
  int playingnum = 0;
  for( int i = 0; i < numsounds; i++){
     if(fireSounds[i].isplay == true) {
       playingnum ++;
     }
  }
  FplayingNum = playingnum;
  //println(playingnum);
  if(playingnum > 0){
    stillplay = true;
  }else{
    stillplay = false;
  }
  
  if(PclientMouse.x != clientMouse.x || PclientMouse.y != clientMouse.y || stillplay){
    Fcomeout = true;
  }
  else{
    Fcomeout = false;
  }
  if(Fcomeout){
  PVector[] distPoints = new PVector[3]; 
  for( int i = 0; i < distPoints.length; i++){
  distPoints[i] = new PVector( dx + random(-10,10), dy +random(-10,10));  
  int posX = floor(distPoints[i].x);
  int posY = floor(distPoints[i].y);
  if(posX>0){
    //check edge
    if( posX - Friprad <= 1) posX = Friprad + 1;
    if( posX + Friprad >= width - 1) posX = width - Friprad - 1;
    if( posY - Friprad <= 1) posY = Friprad + 1;
    if( posY + Friprad >= height - 1) posY = height - Friprad - 1;
 
  for ( int yRan = posY - Friprad; yRan < posY + Friprad; yRan++){
    for( int xRan = posX - Friprad; xRan < posX+Friprad; xRan++){
      Fripplemap[yRan * width + xRan] += 64;
     }
    }
   }
  }
 }
   
}