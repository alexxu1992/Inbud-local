SoundFile[] WaterSound;
musictaker[] waterSounds;
int numsounds = 16;

void iniWaterMusic(){
  WaterSound = new SoundFile[numsounds];
  waterSounds = new musictaker[numsounds]; 
  // Load 16 soundfiles from a folder in a for loop
  for (int i = 0; i < numsounds; i++){
    WaterSound[i] = new SoundFile(this, i + "water.wav");
    waterSounds[i] = new musictaker(WaterSound[i], i);
    waterSounds[i].Wmusic = true;
  }
}

int LastInd = 0;
void playwaterSound(){
 int LocX = 0;
 int LocY = 0;
 LocX = (4*floor(mousePos.x)/width);
 LocY = (4*floor(mousePos.y)/height);
 // judge whether to play on this position 
 int TotalInd = LocY * 4 + LocX;
 if(TotalInd != LastInd){
   waterSounds[LastInd].stay = false;
 }
 if( !waterSounds[TotalInd].stay || waterSounds[TotalInd].onemore){
   waterSounds[TotalInd].begin();
 }
 //To judge whether the current music is finished
 waterSounds[TotalInd].WcurrentPlay();

 // judge whether need to be decay on every position
 for(int i = 0; i < numsounds; i++){
   if(i != TotalInd && waterSounds[i].isplay){
      waterSounds[i].Wdecay();   
      if(waterSounds[i].amp < 0.002){
      waterSounds[i].isplay = false; 
      waterSounds[i].stop();
      }
   }
   //mySounds[i].display();
 }
 LastInd = TotalInd;
}