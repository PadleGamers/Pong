//Dele er taget fra ChatGpt

import processing.net.*;

Client myClient;
String dataIn = "";

void setup() {
  size(1000, 800);
  myClient = new Client(this, "192.168.10.18", 5204);
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
float speedx= 2f;                       //Fart vandret
float speedy= 1f;                       //Fart Lodret
boolean delay = false;                  //Boolean der fortæller om der har været et delay
int delayCount = 0;                     //Tæller
int number = 0;

void draw() {
  background(0);
  noStroke();
  while (myClient.available() > 0) {
    dataIn = myClient.readString();
    String numdataIn = "";
    if (dataIn.length()>=6) {
      numdataIn = dataIn.substring(0, 6);
    }
    if (numdataIn.equals("Number") && number == 0) {
      number = int(dataIn.substring(6, 7));
      sendDataToServer("n"+String.valueOf(number)+String.valueOf(Ypadle2));
    } else if (dataIn.equals("begin")) {
      start = true;
    }
    println("Recieved: " + dataIn + "  Available: " + myClient.available()+"  Number: "+number+ " Ypadle: "+Ypadle1+"  X-værdi: "+Xball+"  Y-værdi: "+Yball);
    String check = dataIn.substring(0,2);
    int spacex = 0;
    int spacey = 0;
    int spacep = 0;
    if (check.equals("n"+String.valueOf(number))){
      println("Recieved");
      for (int i=0; true; i++){
        if (dataIn.charAt(i)=='x') {
          spacex = i;
          break;
        }
      }
      for (int i=0; true; i++){
        if (dataIn.charAt(i) == 'y') {
          spacey = i;
          break;
        }
      }
      for (int i=0; true; i++){
        if (dataIn.charAt(i) =='e') {
          spacep = i;
          break;
        }
      }
      Ypadle1=float(dataIn.substring(2,spacex));
      Xball=float(dataIn.substring(spacex+1,spacey));
      Yball=float(dataIn.substring(spacey+1,spacep));
      sendDataToServer("n"+String.valueOf(number)+String.valueOf(Ypadle2)); //ChatGpt
      }
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
    circle(Xball, Yball, Rball*2);
    
    //Bevægelige rektangler
    fill(255);
    rect(Xpadle1, Ypadle1, Lpadle, Hpadle);
    rect(Xpadle2, Ypadle2, Lpadle, Hpadle);
    rect(500-5, 60, 10, 800-60); //midterlinje

    //tjekker om der er tastetryk
    if (keyPressed) {
      if ((keyCode == UP || key == 'w') && Ypadle2 >= 80) {
        Ypadle2-=3.75;
      }
      if ((keyCode == DOWN || key == 's') && Ypadle2 <= 800-Hpadle) {
        Ypadle2+=3.75;
      }
    }

    
    textSize(60);
    String count1str = nf(count1);
    text(count1str, 10, 60);

    
    String count2str = nf(count2);
    float count2V = textWidth(count2str);
    text(count2str, 1000-(count2V+10), 60);

    
  }
}

void keyPressed() {
  if (key == ENTER && start == false) {
    start = true;
    sendDataToServer("start");
  }
}

void reset() {
  speedx= 2f;
  speedy= 1f;
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
