int damp = 8;
int riprad = 3;
int WplayingNum = 0;
float disturbtime = 0;

PImage myImage;
int[] lastmap;
int[] ripplemap;
int[] texture;

void iniwaterBuffer(){
  lastmap = new int[width * height];
  ripplemap = new int[width * height];
  for( int i = 0; i < width * height; i++){
    ripplemap[i] = 0;
    lastmap[i] = 0;
   }  
   
  myImage = loadImage("flicker.jpg");//water
  myImage.resize(width, height);
  myImage.loadPixels();
  texture = myImage.pixels;
}


void ripple(){
  disturb(floor(mousePos.x), floor(mousePos.y));
  getCurrent(); 
  
}

void getCurrent(){
  int loseSpeed  = floor(map(WplayingNum, 0, 12, 8, 5));
  loadPixels();
  for( int y = 1; y < height -1 ; y++ ){
    for ( int x = 1; x < width -1; x++){
      int index = y * width + x;
      ripplemap[index] = ( lastmap[index + 1] + lastmap[index - 1] + lastmap[index - width] + lastmap[index + width]) / 2 - ripplemap[index];
      // for damping  
      //ripplemap[index] -= ripplemap[index] >> 5;
      ripplemap[index] -= ripplemap[index] >> loseSpeed;
      //rendering the water
      if(lastmap[index] != ripplemap[index]){
        int Xoffset = ripplemap[index - 1] - ripplemap[index + 1];
        int Yoffset = ripplemap[index - width] - ripplemap[index + width];
        int shadow = Xoffset - Yoffset;
        int Newind = (y + Yoffset) * width + x + Xoffset;
        int newX = Newind % width;
        int newY = Newind / width;
        //check bounce
        if( newX < 1) newX = 1;
        if( newX > width - 1) newX = width -1;
        if( newY < 1) newY = 1;
        if( newY > height -1) newY = height -1;
        pixels[index] = texture[newY * width + newX];       
      }
      if(ripplemap[index] < 1 && ripplemap[index] > -1) ripplemap[index] = 0;
    }
  }
  updatePixels();
  //swap
  int[] temp = new int[width * height];
  temp = lastmap;
  lastmap = ripplemap;
  ripplemap = temp;
}

boolean comeout = false;
boolean stillplay = false;

void disturb(int dx, int dy){
  int playingnum = 0;
  //to judge whether contiune to display;
  for( int i = 0; i < numsounds; i++){
     if(waterSounds[i].isplay == true) {
       playingnum ++;
     }
  }
  WplayingNum = playingnum;
  if(playingnum > 0){
    stillplay = true;
  }else{
    stillplay = false;
  }
  
  if(PmousePos.x != mousePos.x || PmousePos.y != mousePos.y || stillplay){
    comeout = true;
  }
  else{
    comeout = false;
  }
  
  if(comeout){
  int posX = dx;
  int posY = dy;
  if(posX>0){
    //check edge
    if( posX - riprad <= 1) posX = riprad + 1;
    if( posX + riprad >= width - 1 ) posX = width - riprad - 1;
    if( posY - riprad <= 1) posY = riprad + 1;
    if( posY + riprad >= height - 1) posY = height - riprad - 1;
  for ( int yRan = posY - riprad; yRan < posY + riprad; yRan++){
    for( int xRan = posX - riprad; xRan < posX + riprad; xRan++){
      ripplemap[yRan * width + xRan] += 128;
    }
  }
  }
  }
   
}