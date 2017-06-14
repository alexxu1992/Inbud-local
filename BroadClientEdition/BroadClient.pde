OscP5 oscP5;

int casterX, casterY;
int myListeningPort = 12345;
int myBroadCastingPort = 12345;

PVector casterPos;

NetAddress myBroadcastLocation; 

void iniBroadClient(){
  // creating my local osc object
  oscP5 = new OscP5(this, myListeningPort);
  // creating the distant address for broadcasting
  myBroadcastLocation = new NetAddress(serverIP, myBroadCastingPort);
  
  casterPos = new PVector(0, 0);
}

// build up the connection with the server
void connectingCaster(){
  OscMessage Contact;
  switch(key){
    case('c'):
     Contact = new OscMessage("/server/connect", new Object[0]);
     oscP5.flush(Contact, myBroadcastLocation); // originally the example use the flush here
     sent = true;
     break;
     
    case('d'):
     Contact = new OscMessage("/server/disconnect", new Object[0]);
     oscP5.flush(Contact, myBroadcastLocation);
     break;
  }
}
// sending out this mousePos message
void Datasend(){
 OscMessage myMessage = new OscMessage("check");
 int addressX = floor(mousePos.x);
 int addressY = floor(mousePos.y);
 if (addressX > width){
  addressX  = width;
 }
 else if (addressX  < 0){
  addressX  = 0;
 }
 if (addressY  > height){
  addressY = height;
 }
 else if (addressY  < 0){
  addressY  = 0;
 }
 //adding these position to the oscMessage
 myMessage.add(addressX);
 myMessage.add(addressY);
 oscP5.send(myMessage, myBroadcastLocation);
}

//accepting the message from the server
void oscEvent(OscMessage theOscMessage){
  casterPos.x = theOscMessage.get(0).intValue();
  casterPos.y = theOscMessage.get(1).intValue();
  second = theOscMessage.get(2).floatValue();
  print(second + "   ");
  print(casterPos.x);
  println("  " + casterPos.y);
}