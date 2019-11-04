int valor_potenciometro = 0;
int valor_potenciometro2= 0;
void setup(){
  Serial.begin(9600);
}

void loop(){
  valor_potenciometro = analogRead(A0);
  valor_potenciometro2= analogRead(A1);
  Serial.print(valor_potenciometro);
  Serial.print(',');
  Serial.println(valor_potenciometro2);
  delay(100);

 }
