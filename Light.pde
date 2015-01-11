class Light {
  float distance = 1000;
  float light_posX;
  float light_posZ;

  //void rotate

  void display(float light_pos) {
    pushMatrix();
    translate(width/2, height/2);
    light_posX = cos(light_pos)*distance;
    light_posZ = sin(light_pos)*distance;
    directionalLight(255, 255, 255, light_posX, 0, light_posZ);
    directionalLight(120, 120, 120, light_posX, 0, light_posZ);
    directionalLight(20, 20, 20, -light_posX, 0, -light_posZ);
    popMatrix();
  }
}
