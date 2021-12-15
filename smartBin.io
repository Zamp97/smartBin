// C++ code


#include <Adafruit_NeoPixel.h>

int ledPin= 3;
int ledNo= 12;

Adafruit_NeoPixel strip= Adafruit_NeoPixel(ledNo,ledPin,NEO_RGB+NEO_KHZ800);


int buzzerPin= 2;
int echoPin= 6; //distanse out
int trigPin= 5;	// distanse in
int minDistance = 100;
int maxDistance = 300;

void setup() 
{
  //Distance sensor pins
  pinMode(buzzerPin, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  //Gas sensor pin
  pinMode(A0, INPUT);
  
  //Temperature sensors pins
  pinMode (A4, INPUT); //Inside sensor
  pinMode (A5, INPUT); //Outside sensor
  
  Serial. begin(9600);  
  strip.begin();
  for(int i = 0; i < ledNo; i++)
  {
   strip.setPixelColor(i,strip.Color(0,0,0));
  }
  strip.show();
}

void glow_leds(int ledsToGlow){
  if(ledsToGlow == 12)
  {
    digitalWrite(buzzerPin, HIGH);
  }
  else
  {
    digitalWrite(buzzerPin, LOW);
  }
  for(int i = 0; i < ledsToGlow; i++)
  {
    if(i < 4)
    {
      strip.setPixelColor(i,strip.Color(50,0,0));//green,red,blue
    }
    else if(i >= 4 && i < 8)
    {
      strip.setPixelColor(i,strip.Color(50,50,0));//green,red,blue
    }
    else if(i >= 8 && i < 12)
    {
      strip.setPixelColor(i,strip.Color(0,50,0));//green,red,blue
    }
  }
  for(int i = ledsToGlow; i < ledNo; i++)
  {
    strip.setPixelColor(i,strip.Color(0,0,0));
  }
    
  strip.show();
  
}

int calcDistance()
{
  long distance,duration;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration/29/2;
  if(distance >= maxDistance)
  {
    distance = maxDistance;
  }
  if(distance <= minDistance)
  {
    distance = minDistance;
  }
  return distance;
}


void loop() 
{
  int distance = calcDistance();
  int GasSensorVal = analogRead(A0);
  int ledsToGlow;
  int ledsToGlow_dist;
  int ledsToGlow_temp = 0;
  
  //Temp sensor
  int celsius_in = 0;
  celsius_in = map(((analogRead(A4) - 20) * 3.04), 0, 1023, -40, 125);
  int celsius_out = 0;
  celsius_out = map(((analogRead(A5) - 20) * 3.04), 0, 1023, -40, 125);
  int celsius_diff = celsius_in - celsius_out;

  
  
  ledsToGlow_dist = map(distance, minDistance, maxDistance, ledNo, 1);
  
  //Temperature shit
  if (celsius_diff > 0){
    ledsToGlow_temp = map(celsius_diff, 0, 165, 1, ledNo);
  }
  
  if (GasSensorVal>150)
  {	
    ledsToGlow=12;
  }  
  else
  {
    if (ledsToGlow_dist > ledsToGlow_temp){
      ledsToGlow = ledsToGlow_dist;
    } else {
      ledsToGlow = ledsToGlow_temp;
    }
  }
  
  glow_leds(ledsToGlow);
  
      
  Serial.print(distance);
  Serial.print(" ");
  Serial.print(ledsToGlow);
  Serial.print(" ");
  Serial.print(GasSensorVal);
  Serial.print(" ");
  Serial.print(celsius_diff);
  Serial.print("\n");

  
  delay(50);

}


