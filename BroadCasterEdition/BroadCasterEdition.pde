import processing.sound.*;
import org.openkinect.processing.*;
import oscP5.*;
import netP5.*;

boolean start = false;
int change = 0;
float second = 0.0;

void setup(){
  fullScreen();
  //size(800,800);
  frameRate(60);
  
  iniBroadCaster(); //initialize the broadCaster
  
  iniTracker(); //initialize the kinect tracker 
 
  iniwaterBuffer();//initialize the ripple buffer and source picture in ripple, in the ripple file
  
  inifireBuffer();//initialize the fire buffer and source picture in fire, in the fire file

  iniWaterMusic();// initialize the water musictakers
  
  iniFireMusic();// initialize the fire musictakers
}

void draw(){
  background(0);
  second = millis()/1000.0;
  trackbegin(0);//choose the track type, 0 for mouse, 1 for kinect
  if(start){
   ripple();
   playwaterSound();
  }
  PmousePos = mousePos.copy();
  //judge whether to send the data out
  if( myNetAddressList.size()>0){
    Datasend();
    fire();
    playfireSound();
    PclientMouse = clientMouse.copy();
  }
}


void keyPressed(){
  if(keyCode == SHIFT && change == 0){
    change = 1;
  }else if(keyCode == SHIFT && change == 1){
    change = 0;
  }
  
  adjustThresHold();
}