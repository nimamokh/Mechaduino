/*
 Send command to mechaduino to start an step responde test and plot the recieved data
 */

import processing.serial.*;
Serial myPort; //creates a software serial port on which you will listen to Arduino


int step = 100;
int microstepping = 16;

String val;
float start_time = 0;

float last_target = 0.0;
float last_position = 0.0;

boolean flag = true;
boolean first_event = true;
boolean second_event = false;
boolean finished = false;
int x = 0;
int lastheight_1 = 0;
int lastheight_2 = 0;
int lastheight_3 = 0;

float current_position=0;

float [] target_buffer = new float[2000];
float [] y_buffer = new float[2000];
float [] time_buffer = new float[2000];

float step_angle = 360.0*(step/(200.0*microstepping));

void setup()
{
  size(1600, 900);
  String portName = Serial.list()[2]; 
  //CAUTION: your Arduino port number is probably different! Mine happened to be 1. Use a "handshake" sketch to figure out and test which port number your Arduino is talking on. A "handshake" establishes that Arduino and Processing are listening/talking on the same port.
  //Here's a link to a basic handshake tutorial: https://processing.org/tutorials/overview/
  for (int i=0; i<2000; i=i+1) {
    target_buffer[i]= 0;
    y_buffer[i] = 0;
  }

  myPort = new Serial(this, portName, 250000); //set up your port to listen to the serial port

  background(255, 255, 255);
  myPort.write('j'); // send s over serial to start step response
  myPort.write(str(step)); //send the step value

  println("send");
}

void serialEvent(Serial myPort) {


  time_buffer[x] =(int)( millis()-start_time);

  String inString = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. We will parse the data by each newline separator. 

  if (inString!= null) { //We have a reading! Record it.
    inString = trim(inString);
    println(inString);

    float sensorVals[] = float(split(inString, ','));

    if (first_event) {
      first_event =false;
      current_position = sensorVals[1];
    }

    time_buffer[x] = sensorVals[0];

    float target = (sensorVals[1]-current_position)/(100*step_angle);
    float temp_1 =  map(target, -0.5, 1.5, -(0.5*height), (0.5*height));
    target_buffer[x] = temp_1;

    float y =( sensorVals[2]-current_position)/(100*step_angle);
    float temp_2 =  map(y, -0.5, 1.5, -(0.5*height), (0.5*height));
    y_buffer[x] = temp_2;

    x++;
  }
}



void draw() {
  if (first_event==false) {
    background(255, 255, 255);
    float scale = ((float)width)/time_buffer[x-1];
    for (int i=0; i<x; i=i+1) {   
      if (i==0) {
        stroke(0, 255, 0);     //stroke color
        strokeWeight(1);        //stroke wider
        line(0, (0.5*height) - target_buffer[i], scale*time_buffer[i], (0.5*height) - target_buffer[i]);
        lastheight_1 = (int)(0.5*height) - (int)target_buffer[i];

        stroke(255, 0, 0);     //stroke color
        strokeWeight(1);        //stroke wider
        line(0, (0.5*height)  - y_buffer[i], scale*time_buffer[i], (0.5*height)  - y_buffer[i]); 
        lastheight_2 = (int)(0.5*height) -  (int)y_buffer[i];
        
      } else {
        stroke(0, 255, 0);     //stroke color
        strokeWeight(1);        //stroke wider
        line(scale*time_buffer[i-1], lastheight_1, scale*time_buffer[i], (0.5*height) - target_buffer[i]);
        lastheight_1 = (int)(0.5*height) - (int)target_buffer[i];

        stroke(255, 0, 0);     //stroke color
        strokeWeight(1);        //stroke wider
        line(scale*time_buffer[i-1], lastheight_2, scale*time_buffer[i], (0.5*height)  - y_buffer[i]); 
        lastheight_2 = (int)(0.5*height) -  (int)y_buffer[i];
      }
    }
  }
}