
PFont font;

int fontSize = 20;
int boxW = int(fontSize * 1.5); 

String foldername = "sessions/003";

int num_images = 1000;
int img_index = 0;
int char_index = 0; 

boolean save = false;

PrintWriter output;

void setup() {
  size(416, 416);
  background(255);
  font = createFont("Arial",fontSize,true);
  textFont(font);
  textSize(fontSize);
  frameRate(30);
  textAlign(CENTER, CENTER);
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
  fontSize = 12 + int(random(25));
  boxW = int(fontSize * 1.5); 
  textSize(fontSize);
  PImage bg = getBackgroundImage();
  
  
  tint(230 - random(10), 255 - random(30), 255 - random(30));
  image(bg, 0, 0, width, height);
  
  String filename = foldername + "/image-" + String.format("%04d", img_index);
  
  if (save) output = createWriter(filename + ".txt"); 
  
  for (int y = boxW; y < height - boxW; y += boxW) {
    for (int x = boxW; x < width - boxW * 2; x += boxW) {
      // char_index = int(random(chars.length));
      
      color c = color(random(50),0,0, 100 + random(100));
      fill(c);
      stroke(c);
      
      text(Character.toString(chars[char_index]), x, y, boxW, boxW);
      
      noFill();
      stroke(255, 0, 0, 100);
      
      int rect_x = x + int(float(boxW - fontSize) / 2);
      int rect_y = y + int(float(boxW - fontSize) / 1.5);
      
      pushAnnotations(char_index, rect_x, rect_y, fontSize, fontSize);
      
      char_index = (char_index + 1) % chars.length;
    }
  }
  
  noise_layer();
  
  filter(BLUR, random(1)-0.2);
  
  
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


void noise_layer() {
  float opacity = random(30);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < width; y++) {
      stroke(random(255), opacity);
      point(x,y);
    } 
  }
}