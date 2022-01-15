int bg_length = 10;
String prefix = "data/clay_bg/clay_bg-";
String sufix = ".png";

PImage getBackgroundImage() {
  PImage bg;
  int rand = int(random(bg_length));
  String number = String.format("%03d", rand);
  String filepath = prefix + number + sufix;
  bg = loadImage(filepath);
  return bg;
}