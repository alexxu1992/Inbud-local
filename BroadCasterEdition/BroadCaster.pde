OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 12345;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12345;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

PVector clientMouse; //createfor the clientMessage
PVector PclientMouse;

void iniBroadCaster(){
  //initialize the broadcaster
  oscP5 = new OscP5(this, myListeningPort);
  println(oscP5);
  clientMouse = new PVector(0, 0);
  PclientMouse = new PVector(0, 0);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  println("hey i am here");
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    connect(theOscMessage.netAddress().address()); 
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
  }
  else {
   //oscP5.send(theOscMessage, myNetAddressList);
  clientMouse.x = theOscMessage.get(0).intValue();
  clientMouse.y = theOscMessage.get(1).intValue();
  print(clientMouse.x);
  println("   " + clientMouse.y);
  }
}

void Datasend() {
/* add a value (an integer) to the OscMessage */
OscMessage myMessage = new OscMessage("check");
int addressX = floor(mousePos.x);
int addressY = floor(mousePos.y);
if (addressX > width){
  addressX = width;
}
else if (addressX < 0){
  addressX = 0;
}
if (addressY > height){
  addressX = height;
}
else if (addressY < 0){
  addressY = 0;
}
//adding the message to the oscP5
myMessage.add(addressX);
myMessage.add(addressY);
myMessage.add(second);
/* send the OscMessage to a remote location specified in myNetAddress */
oscP5.send(myMessage, myNetAddressList.get(0));
}


private void connect(String theIPaddress) {
     println("hey i am here");
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }



private void disconnect(String theIPaddress) {
if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.remove(theIPaddress, myBroadcastPort);
       println("### removing "+theIPaddress+" from the list.");
     } else {
       println("### "+theIPaddress+" is not connected.");
     }
       println("### currently there are "+myNetAddressList.list().size());
 }