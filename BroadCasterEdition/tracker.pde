// recording the current depth, representing the amplitude
float Dep = 1.0;
float Depoffset = 1.0;
float thisVolume = 1.0;

KinectTracker tracker;
PVector trackPos;
PVector mousePos;
PVector PmousePos;

void iniTracker(){
  tracker = new KinectTracker(this);
  trackPos = new PVector(0,0);
  mousePos = new PVector(0,0);
  PmousePos = new PVector(0,0);
}

class KinectTracker {

  // Depth threshold
  int threshold = 1555;

  // Raw location
  PVector loc;
  
  // previous location
  PVector Ploc; 

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;

  // What we'll show the user
  PImage display;
  
  //Kinect2 class
  Kinect2 kinect2;
  
  KinectTracker(PApplet pa) {
    
    //enable Kinect2
    kinect2 = new Kinect2(pa);
    kinect2.initDepth();
    kinect2.initDevice();
    
    // Make a blank image
    display = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
    
    // Set up the vectors
    loc = new PVector(0, 0);
    Ploc = new PVector(0,0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect2.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;
    float sumD = 0;

    for (int x = 68; x < kinect2.depthWidth - 100; x++) {
      for (int y = 40; y < kinect2.depthHeight - 180; y++) {
        // Mirroring the image
        int offset = kinect2.depthWidth - x - 1 + y * kinect2.depthWidth;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth > 0 && rawDepth < threshold) {
          sumX += x;
          sumY += y;
          sumD += rawDepth;
          count++;
          
        }
      }
    }
    // As long as we found something
    if (count > 5) {
      loc.set(sumX/count, sumY/count);
      loc.x = map(loc.x, 68, kinect2.depthWidth -100 ,width, 0);
      loc.y = map(loc.y, 40, kinect2.depthHeight-175, 0, height);
      //println(loc.x);
     // Dep = sumD/count; 
     // Depoffset = Dep - threshold;
     
    }
    else{
      loc = Ploc;
      //Dep = 0.0;
      // Depoffset = 0.1;
    }

    // Interpolating the location, doing it arbitrarily for now
    //lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    //lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
    Ploc = loc;
    thisVolume = map(Depoffset, 0 , 200, 0.1, 1.1);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect2.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect2.depthWidth; x++) {
      for (int y = 0; y < kinect2.depthHeight; y++) {
        // mirroring image
        int offset = (kinect2.depthWidth - x - 1) + y * kinect2.depthWidth;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y*display.width;
        if (rawDepth > 0 && rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(150, 50, 50);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
    
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}

void trackbegin(int i){
  tracker.track();
  trackPos = tracker.getPos();
  if( i == 0){
  mousePos.set(mouseX, mouseY);
  }else{
    mousePos = tracker.getPos().copy();
  } 
  if(mousePos.x != PmousePos.x){
    start = true;
  }
  fill(100, 250, 50, 200);
  noStroke();
 // ellipse(width - mousePos.x, mousePos.y, 50, 50);
}

void adjustThresHold(){
  int t = tracker.getThreshold();
  if (key == CODED) {
   if (keyCode == UP) {
     t +=5;
     tracker.setThreshold(t);
   } else if (keyCode == DOWN) {
     t -=5;
     tracker.setThreshold(t);
   }
  } 
}