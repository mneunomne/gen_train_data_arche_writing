
PFont font;

int fontSize = 20;
int boxW = int(fontSize * 1.5); 

String foldername = "sessions/003";

int num_images = 1000;
int img_index = 0;
int char_index = 0; 

boolean save = false;
boolean testing = true; 
int grid_margin = 2;
PrintWriter output;

int minFontSize = 14; 

void setup() {
  size(600, 600);
  colorMode(HSB,  255, 255, 255);
  background(255);
  font = createFont("Arial",fontSize,true);
  textFont(font);
  frameRate(1);
  textAlign(CENTER, TOP);
}

void draw() {
  if (img_index < num_images) {
    render();
    img_index++;
  } else {
    exit();
  }
}

void render() {
  fontSize = minFontSize + int(random(25));
  boxW = int(fontSize * 1.3); 
  textSize(fontSize);
  PImage bg = getBackgroundImage();
  
  
  tint(random(10), random(255), 255-random(10));
  image(bg, 0, 0, width, height);
  
  String filename = foldername + "/image-" + String.format("%04d", img_index);
  
  if (save) output = createWriter(filename + ".txt"); 
  
  for (int y = boxW+grid_margin; y < height - boxW; y += boxW+grid_margin) {
    for (int x = boxW+grid_margin; x < width - boxW * 2; x += boxW+grid_margin) {
      // char_index = int(random(chars.length));
      
      color c = color(random(10),random(100),random(30), 120 + random(100));
      fill(c);
      stroke(c);
      
      text(Character.toString(chars[char_index]), x, y, boxW, boxW);
      
      noFill();
      stroke(255, 0, 0, 100);
      
      int rect_x = x + int(float(boxW - fontSize) / 2);
      int rect_y = y + int(float(boxW - fontSize) / 1.5);

      if (!save) {
        stroke(char_index, 255, 255);
        rect(x, y, boxW, boxW);
        // rect(rect_x, rect_y, fontSize, fontSize);
      }
      
      pushAnnotations(char_index, rect_x, rect_y, fontSize, fontSize);
      
      char_index = (char_index + 1) % chars.length;
    }
  }
  
  noise_layer(0.15);
  
  filter(BLUR, random(1)-0.4);
  
  
  if (save) {
    saveFrame(filename + ".png");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

void pushAnnotations(int index, int _x, int _y, int _w, int _h) {
  float x = float(_x) / width;
  float y = float(_y) / width;
  float w = float(_w) / width;
  float h = float(_h) / width;
  
  // darknet utilizes centralized x y coordinates
  float darknet_x = x + w / 2;
  float darknet_y = y + h / 2;
  
  String line = index + " " + darknet_x + " " + darknet_y + " " + w + " " + h;
  if (save) output.println(line);
  println(line);
}


void noise_layer(float ammount) {
  float opacity = random(ammount * 255);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < width; y++) {
      stroke(random(255), opacity);
      point(x,y);
    } 
  }
}