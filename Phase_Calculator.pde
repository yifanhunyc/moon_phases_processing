class PhaseCalculator {
  PFont font;
  
  int month;
  int day;
  int year;

  //String date = "";
  String status = "";
  String _light = "";
  String phase = "";

  int posX;
  int posY;
  
  float light_pos;
  float light;
  float light_;

  PhaseCalculator() {
    font = createFont("Helvetica", 64);
    textFont(font);
    textSize(22);
    textAlign(CENTER);
  }

  //-----Calculator-----//
  void calculate(int day, int month, int year ) {
    // Determine the moon phase of a date given
    // Python code by HAB
    // processing code by Armando Marques da Silva Sobrinho
    int days_into_phase = 0;
    int index = 0;
    int a, b, c, d = 0;
    int[] ages = {
      18, 0, 11, 22, 3, 14, 25, 6, 17, 28, 9, 20, 1, 12, 23, 4, 15, 26, 7
    };
    int[] offsets = {
      -1, 1, 0, 1, 2, 3, 4, 5, 7, 7, 9, 9
    };
    String[] description = {
      "New Moon", 
      "Waxing Crescent", 
      "First Quarter", 
      "Waxing Gibbous", 
      "Full Moon", 
      "Waning Gibbous", 
      "Last Quarter", 
      "Waning Crescent"
    };

    if (day == 31) {
      day = 1;
    }

    days_into_phase = ((ages[(year + 1) % 19] + ((day + offsets[month-1]) % 30) + int(year < 1900)) % 30);
    index = int((days_into_phase + 2) * 16/59.0);
    if (index > 7) {
      index = 7;
    }
    status = description[index];

    // light should be 100% 15 days into phase
    light = int(2 * days_into_phase * 100/29);
    light_ = light;
    light_pos = radians(map(light_, 0, 200, 0, 360));
    
    if (light_ > 100) {
      light_ = abs(light_ - 200);
    }
    _light = light_ + "%";

    phase = status + "\n" + "Light in: " + _light;
  }
  
  void text_display(int month, int day, int year, int posX, int posY){
    text(nameOfMonth[month] + " " + day + ", " + year + "\n" + phase, posX, posY);
  }
}
