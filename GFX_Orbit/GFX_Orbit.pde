/*********************************************************************
This is an example sketch for our Monochrome SHARP Memory Displays

  Pick one up today in the adafruit shop!
  ------> http://www.adafruit.com/products/1393

These displays use SPI to communicate, 3 pins are required to  
interface

Adafruit invests time and resources providing this open source code, 
please support Adafruit and open-source hardware by purchasing 
products from Adafruit!

Written by Limor Fried/Ladyada  for Adafruit Industries.  
BSD license, check license.txt for more information
All text above, and the splash screen must be included in any redistribution

Ported to chipKIT by Joel Murphy. Spring, 2015

    Sharp Memory Display From EmbeddedArtists (sorry LadyAda...)
    http://www.mouser.com/ProductDetail/Embedded-Artists/EA-LCD-007/?qs=%2fha2pyFaduiVZdW7yspVAF2x15uTaSR%252by3ES49YFBdtKf4Fo6ojIjw%3d%3d

    >>>>>  NOTE: This code does not implement software toggle of VCOM!!!
    >>>>>  LCD Module HACK: Solder Rework! 
    >>>>>  Remove 0ohm resistor R9, and jump the R2 pads to pull EXTMODE pin HIGH
    >>>>>  Jump the R7 pads to connect EXTCOMIN pin to connecter
    >>>>>  Provide a clock (<1Hz) to EXTCOMIN pin
    >>>>>  For the clock, I am using a 7414 (single Inverter)74AHC1G14GV:
    >>>>>  http://www.mouser.com/ProductDetail/NXP-Semiconductors/74AHC1G14GV125/?qs=P62ublwmbi%2FTMzPIGwYKEw%3D%3D
    >>>>>  f = 1/0.55*R*C

    Uses DSPI for SPI bus control
    
    This code was written for my SharpMem + EEPROM lashup.
    Excuse YOU if it doesn't work for your purposes
*********************************************************************/

#include <DSPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SharpMem.h>

#define LCD_SS  8       // Slave Select pin for LCD (be wary of pin 10 on Joel's board)
#define DISP    9       // Display pin LOW = off, HIGH = on

#define WP     6	// write protect pin 
#define EE_SS  7 // EEPROM Slave Select pin

Adafruit_SharpMem display(LCD_SS, DISP);

#define BLACK 0  // black pixels are 0s in the byte array
#define WHITE 1  // white pixels are 1s in the byte array




float dotX[360];  // used to hold the orbiting dot coordinates
float dotY[360];
int dotPosition = 0;  // used to move through the dot arrays

int orbitRadius = 35;


void setup(void) 
{
  Serial.begin(115200);
  Serial.println("Orbit");
 
   
 
  display.begin();  // start & clear the display
  
  // eeprom stuff
  pinMode(EE_SS,OUTPUT); digitalWrite(EE_SS,HIGH);
  pinMode(WP,OUTPUT); digitalWrite(WP,LOW);	// protect status reg
  pinMode(10,OUTPUT);digitalWrite(10,HIGH);     //
  delay(500);
  
  getDotCoordinates(orbitRadius);
  
//  display.refresh();
  

  


}

void loop(void) 
{
  display.clearDisplay();
  
  display.drawCircle(display.width()/2, display.height()/2, orbitRadius, BLACK);
  
  display.drawCircle(dotX[dotPosition],dotY[dotPosition], 5, BLACK);
  display.fillCircle(dotX[dotPosition],dotY[dotPosition], 4, WHITE);
  dotPosition++;
  if(dotPosition == 360){ dotPosition = 0; }
  
  display.refresh();
  delay(100);
  
}


void getDotCoordinates(int radius){
  int numPoints=360;
  float angle=TWO_PI/(float)numPoints;
  for(int i=0;i<numPoints;i++)
  {
    dotX[i] = radius*sin(angle*i)+48;
    dotY[i] = radius*cos(angle*i)+48;
  }
}




void testdrawcircle(void) {
  for (uint8_t i=0; i<display.height(); i+=2) {
    display.drawCircle(display.width()/2-5, display.height()/2-5, i, BLACK);
    display.refresh();
  }
}


