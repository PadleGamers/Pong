//Dele er taget fra ChatGpt

import processing.net.*;

Server myServer;

void setup() {
  size(1000, 800);
  myServer = new Server(this, 5204, "192.168.10.11");
  frameRate(100);
}

float Xball = 500;                      //X-værdi af bold
float Yball = 430;                      //Y-værdi af bold
float Rball = 15;                       //Radius af bold
float Lpadle = 15;                      //Længden af 'Padles'
float Hpadle = 150;                     //Højden af 'Padles'
float Xpadle1 = 30;                     //X-værdi af Padle til venstre
float Ypadle1 = 400-75;         //Y-værdi af Padle til venstre
float Xpadle2 = 1000-Lpadle-30;         //X-værdi af Padle til højre
float speedx= 2f;                       //Fart vandret
float speedy= 1f;                       //Fart Lodret
boolean delay = false;                  //Boolean der fortæller om der har været et delay
int delayCount = 0;                     //Tæller
int count1 = 0;                         //Point-tæller af Padle til venstre
int count2 = 0;                         //Point-tæller af Padle til højre
float Ypadle2 = 0;
float xball = 0;
float yball = 0;
boolean start = false;

String dataIn = "";
String whatClientSaid = "";
int number = 1;

void draw() {
  background(0);
  noStroke();
  Client thisClient = myServer.available();  //ChatGpt
  if (thisClient != null) {   //ChatGpt
    whatClientSaid = thisClient.readString();   //ChatGpt
  }



  //ChatGpt
  if (whatClientSaid != null) {
    if (whatClientSaid.length()>=5) {
      if (whatClientSaid.equals("start")) {
        myServer.write("begin");
        start = true;
      } else if (whatClientSaid.charAt(0) == 'n') {
        if (whatClientSaid.charAt(1) == '1') {
          Ypadle1=float(whatClientSaid.substring(2, whatClientSaid.length()));
          myServer.write("n2"+String.valueOf(Ypadle1)+"x"+String.valueOf(1000-Xball)+"y"+String.valueOf(Yball));
        } else {
          Ypadle2=float(whatClientSaid.substring(2, whatClientSaid.length()));
          myServer.write("n1"+String.valueOf(Ypadle1)+"x"+String.valueOf(Xball)+"y"+String.valueOf(Yball));
        }
      }
    }
    whatClientSaid = null;
  }
  
  if (start == true) {
    //Det her er padle 1
    if ((Xball-Rball)<=(Xpadle1+Lpadle) && Yball>=Ypadle1 && Yball<=(Ypadle1+Hpadle) && (Xball+Rball)>=Xpadle1) {
      speedx*=-1.02;
      speedy*=1.02;
    }

    //Det her er padle 2
    if ((Xball+Rball)>=Xpadle2 && Yball>=Ypadle2 && Yball<=(Ypadle2+Hpadle) && (Xball-Rball)<=(Xpadle2+Lpadle)) {
      speedx*=-1.02;
      speedy*=1.02;
    }
    
    if (delayCount == 120) {
      delay = true;
      circle(Xball, Yball, Rball*2);
      Xball=Xball+speedx; //Fart på cirklen
      Yball=Yball+speedy;
      if (Xball >width-Rball) { //skifter retning lodret og nustiller position på cirklen
        reset();
        speedx=speedx*-1;
        count1++;
      }
      if (Xball < 0+Rball) {
        reset();
        speedx*=-1;
        count2++;
      }
      if ((Yball+Rball) >= 800 || (Yball-Rball) <= 60) {
        speedy*=-1;
      }
    }

    if (delay == false) {
      delayCount++;
    }
    
  } else {
    if (random(100) > 50) {
      speedx*=-1;
    } else {
      speedx*=1;
    }
    if (random(100) > 50) {
      speedy*=-1;
    } else {
      speedx*=1;
    }
  }
}

void serverEvent(Server someServer, Client someClient) {
  Ypadle1 = 400-75;
  myServer.write("Number"+String.valueOf(number));
  println("Number"+String.valueOf(number));
  number++;
}
