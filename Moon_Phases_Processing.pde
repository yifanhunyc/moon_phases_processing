import processing.serial.*;

Moon moon;
PhaseCalculator moon_phase;
Light light;

PImage spaceBG;

Serial myPort;
boolean leapYear = false;
int month = month();
int date = day();
int year = year();
int newYear, newMonth, newDate;
int oldYear, oldMonth, oldDate;
int offsetY, offsetM, offsetD;
int[] daysInMonth = {
  -1, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
};
String[] nameOfMonth = {
  " ", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
};

float angle;
float animate_light;

float _light;
int light_pos;
int _currentPos;
int currentPos;

void setup() {
  size(displayWidth, displayHeight, P3D);
  moon = new Moon();
  moon_phase = new PhaseCalculator();
  light = new Light();
  spaceBG = loadImage("Space.jpg");

  String portName = "/dev/tty.usbmodem1421";
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');

  noCursor();
}

void draw() {
  //-----2D Background & Text-----//
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  image(spaceBG, 0, 0, displayWidth, displayHeight);
  moon_phase.calculate(date, month, year);
  moon_phase.text_display(month, date, year, width/2, 7 * height / 9);
  //text(nameOfMonth[month] + ", " + date + ", " + year + "\n", width/2, hie);
  hint(ENABLE_DEPTH_TEST);

  //-----3D Moon & Light-----//
  pushMatrix();
  rotateY(-PI/2);
  if (animate_light < moon_phase.light_pos) {
    animate_light = lerp(animate_light, moon_phase.light_pos, 0.025);
  } else {
    animate_light = lerp(animate_light, moon_phase.light_pos,  0.025);
  }
  light.display(animate_light);
  popMatrix();
  moon.renderGlobe();

  if (moon_phase.light == 0.0) {
    _light = 0;
  } else if (moon_phase.light == 6.0) {
    _light = 1;
  } else if (moon_phase.light == 13.0) {
    _light = 2;
  } else {
    _light = (moon_phase.light * 1.05) / 7;
  }
  light_pos = int(_light);
  println(light_pos, currentPos);
}

//----- Serial Communication -----//
void serialEvent(Serial myPort) {
  String input = myPort.readString();
  input = trim(input);
  String[] numbers = split (input, ",");
  int[] values = int(numbers);
  if (values.length > 2) {
    newYear = values[0];
    newMonth = values[1];
    newDate = values[2];
    _currentPos = values[3];

    currentPos = _currentPos;

    offsetY = newYear - oldYear;
    oldYear = newYear;
    offsetM = newMonth - oldMonth;
    oldMonth = newMonth;
    offsetD = newDate - oldDate;
    oldDate = newDate;
  }

  //Leap Year:
  if (leapYear) {
    daysInMonth[2] = 29;
  } else {
    daysInMonth[2] = 28;
  }

  //Year:
  year = year + offsetY;
  if (year % 4 == 0) {
    if(year % 100 == 0 && (year / 100) % 4 != 0){
     leapYear = false; 
    }else{
    leapYear = true;
    }
  } else {
    leapYear = false;
  }
  if (leapYear ==false && month == 2 && date == 29) {
    date = 28;
  }

  //Month:
  month = month + offsetM;
  if (month > 12) {
    month = 1;
    year++;
  }
  if (month < 1) {
    month = 12;
    year --;
  }
  if (date > daysInMonth[month]) {
    date = daysInMonth[month];
  }

  //Date:
  date = date + offsetD;
  if (date > daysInMonth[month]) {
    date = 1; 
    month ++;
  }
  if (month > 12) {
    month = 1;
    year ++;
  }
  if (date < 1) {
    month --;
    if (month < 1) {
      month = 12;
      year --;
    }
    date = daysInMonth[month];
  }

  String x = month + "," + date + "," + year + "," + light_pos;
  myPort.write(x);
}
