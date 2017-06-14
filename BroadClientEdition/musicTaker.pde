class musictaker{
  boolean Wmusic, Fmusic;
  boolean isplay, stay, onemore;
  int theindex;
  SoundFile playingSound;
  int gridX, gridY;
  float amp, decaytime, incretime, opacity, duration, starttime;
  float jumptime;
  //constructor
  musictaker(SoundFile theSound, int Index){
    Wmusic = false;
    Fmusic = false;
    isplay = false;
    theindex = Index;
    playingSound = theSound;
    gridX = Index % 4;
    gridY = floor(Index / 4);
    amp = 0;
    decaytime = 0;
    incretime = 0;
    opacity = 0.0;
    duration = playingSound.duration();
    starttime = 0.0;
    jumptime = 0.0;
    stay = false;
    onemore = false;
  }
  void display(){
    fill(255, opacity);
    rect(gridX * 0.25 *width, gridY * 0.25 * height, width/4, height/4);
  }
  
  void begin(){
    if(!onemore){
    amp = 0; 
    }
    playingSound.amp(amp);
    jumptime = second % duration;
    playingSound.jump(jumptime); 
    starttime = second;
    decaytime = 0; 
    opacity = 255;
    isplay = true;
    stay = true;
    onemore = false;
    //playingSound.play();
  }
  
  void Wdecay(){
    decaytime += 0.02;
    if(amp > 0.02){
      amp = pow(0.5, decaytime);
    }
    else amp = 0;
    playingSound.amp(amp);
    opacity = map(amp, 0.1, 1, 0, 255);
  } 
  
  void Fdecay(){
    decaytime += 0.04;
    if(amp > 0.02){
      amp = pow(0.5, decaytime);
    }
    else amp = 0;
    playingSound.amp(amp);
    opacity = map(amp, 0.1, 1, 0, 255);
    
    
    
  }
  
  void stop(){
    playingSound.stop();
  }
  
  void WcurrentPlay(){
    if(abs(amp - Dep) > 0.02){
     float offset = Dep - amp;
     amp = amp + 0.05 * offset;
     playingSound.amp(amp); 
     //print(amp);
    }
    if(second > starttime + (duration - jumptime)){
     isplay = false;
     opacity = 0;
     onemore = true;
    }
  }
    void FcurrentPlay(){
     println(amp);
    if(abs(amp - 0.65*Dep) > 0.02){
     float offset = Dep - amp;
     amp = amp + 0.04 * offset;
     playingSound.amp(amp); 
    }
    if(second > starttime + (duration - jumptime)){
     isplay = false;
     opacity = 0;
     onemore = true;
    }
  }
}