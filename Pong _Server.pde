//Dele er taget fra ChatGpt

import processing.net.*;

Server myServer;

void setup() {
  size(1000, 800);
  myServer = new Server(this, 5204, "10.178.144.156");
  frameRate(100);
}

float Hpadle = 150;                     //Højden af 'Padles'
int Ypadle1 = 400-75;         //Y-værdi af Padle til venstre
String dataIn = "";
String whatClientSaid = "";

void draw() {
  background(0);
  noStroke();
  Client thisClient = myServer.available();  //ChatGpt
  if (thisClient != null) {   //ChatGpt
    whatClientSaid = thisClient.readString();   //ChatGpt
  }

  if (keyPressed) {
    if (key == 'w' && Ypadle1 >= 80) {
      Ypadle1+=-3.75;
      println(Ypadle1);
    }
    if (key == 's' && Ypadle1 <= 800-Hpadle) {
      Ypadle1+=3.75;
      println(Ypadle1);
    }
  }

  //ChatGpt
  if (whatClientSaid != null) {
    myServer.write(String.valueOf(Ypadle1));
    whatClientSaid = null;
  }
}

void serverEvent(Server someServer, Client someClient) {
  Ypadle1 = 400-75;
  myServer.write(String.valueOf(Ypadle1));
}
