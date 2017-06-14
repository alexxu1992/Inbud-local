SoundFile[] FireSound;
musictaker[] fireSounds;
int firenumSounds = 16;

void iniFireMusic(){
  FireSound = new SoundFile[firenumSounds];
  fireSounds = new musictaker[firenumSounds]; 
  // Load 16 fire soundfiles from a folder in a for loop
  for (int i = 0; i < numsounds; i++){
    FireSound[i] = new SoundFile(this,i + "fire.wav");
    fireSounds[i] = new musictaker(FireSound[i], i);
    fireSounds[i].Fmusic = true;
  }
}

int LastFireInd = 0;
void playfireSound(){
 int LocX = 0;
 int LocY = 0;
 //change the position here to control the music
 LocX = (4*floor(mousePos.x)/width);
 LocY = (4*floor(mousePos.y)/height);
 // judge whether to play on this position 
 int TotalInd = LocY * 4 + LocX;
 if(TotalInd != LastFireInd){
   fireSounds[LastFireInd].stay = false;
 }
 if( !fireSounds[TotalInd].stay || fireSounds[TotalInd].onemore){
   fireSounds[TotalInd].begin();
 }
 //To judge whether the current music is finished
 fireSounds[TotalInd].FcurrentPlay();

 // judge whether need to be decay on every position
 for(int i = 0; i < numsounds; i++){
   if(i != TotalInd && fireSounds[i].isplay){
      fireSounds[i].Fdecay();   
      if(fireSounds[i].amp < 0.002){
      fireSounds[i].isplay = false; 
      fireSounds[i].stop();
      }
   }
   //mySounds[i].display();
 }
 LastFireInd = TotalInd;
}