//Dele er taget fra ChatGpt

import processing.net.*;

Client myClient;
String dataIn = "";

void setup() {
  size(1000, 800);
  myClient = new Client(this, "10.178.144.156", 5204);
  frameRate(100); 
}

float Xball = 500;                      //X-værdi af bold
float Yball = 430;                      //Y-værdi af bold
float Rball = 15;                       //Radius af bold
float Lpadle = 15;                      //Længden af 'Padles'
float Hpadle = 150;                     //Højden af 'Padles'
float Xpadle1 = 30;                     //X-værdi af Padle til venstre
float Ypadle1 = 800/2-Hpadle/2;         //Y-værdi af Padle til venstre
float Xpadle2 = 1000-Lpadle-30;         //X-værdi af Padle til højre
float Ypadle2 = 800/2-Hpadle/2;         //Y-værdi af Padle til højre
int count1 = 0;                         //Point-tæller af Padle til venstre
int count2 = 0;                         //Point-tæller af Padle til højre
boolean start = false;                  //Boolean der fortæller om spillet er startet
float x=50.0f;
float speedx= 1.5f;                       //Fart vandret
float speedy= 0.7f;                     //Fart Lodret
boolean delay = false;                  //Boolean der fortæller om der har været et delay
int delayCount = 0;                     //Tæller

void draw() {
  background(0);
  noStroke();
  while (myClient.available() > 0) {
    dataIn = myClient.readString();
    println("Recieved: " + dataIn + "  Available: " + myClient.available());
    sendDataToServer("Recieved"); //ChatGpt
  }
  

  if (start == false) {
    String name = "Pong";
    String directions = "Tryk på ENTER for at starte";

    textSize(200);
    float nameSize = textWidth(name);
    text(name, 1000/2-nameSize/2, 800/2);

    textSize(60);
    float directionsSize = textWidth(directions);
    text(directions, 1000/2-directionsSize/2, 800/2+800/4);

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

  if (start == true) {
    //Bevægelige rektangler
    fill(255);
    Ypadle1 = float(dataIn);
    rect(Xpadle1, Ypadle1, Lpadle, Hpadle);
    rect(Xpadle2, Ypadle2, Lpadle, Hpadle);
    rect(500-5, 60, 10, 800-60); //midterlinje

    //tjekker om der er tastetryk
    if (keyPressed) {
      if (keyCode == UP && Ypadle2 >= 80) {
        Ypadle2-=3.75;
      }
      if (keyCode == DOWN && Ypadle2 <= 800-Hpadle) {
        Ypadle2+=3.75;
      }
    }

    //Point System
    //Det her er padle 1
    if ((Xball-Rball)<=(Xpadle1+Lpadle) && Yball>=Ypadle1 && Yball<=(Ypadle1+Hpadle) && (Xball+Rball)>=Xpadle1) {
      speedx*=-1.02;
      speedy*=1.02;
    }
    textSize(60);
    String count1str = nf(count1);
    text(count1str, 10, 60);

    //Det her er padle 2
    if ((Xball+Rball)>=Xpadle2 && Yball>=Ypadle2 && Yball<=(Ypadle2+Hpadle) && (Xball-Rball)<=(Xpadle2+Lpadle)) {
      speedx*=-1.02;
      speedy*=1.02;
    }
    String count2str = nf(count2);
    float count2V = textWidth(count2str);
    text(count2str, 1000-(count2V+10), 60);

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
  }
}

void keyPressed() {
  if (key == ENTER && start == false) {
    start = true;
  }
}

void reset() {
  speedx= 1.5f;
  speedy= 0.7f;
  Xball = 500;
  Yball = 430;
  delayCount = 0;
  delay = false;
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

//ChatGpt
void sendDataToServer(String data) { 
  myClient.write(data);
}