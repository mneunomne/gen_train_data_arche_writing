PFont font;

int fontSize;
int boxW; 

String foldername = "sessions/004";

int num_images = 1000;
int img_index = 0;
int char_index = 0; 

boolean save = false;
boolean testing = true; 
int grid_margin = 4;
PrintWriter output;

int minFontSize = 15;

float angle_variation = 20; 

void setup() {
  size(600, 600);
  colorMode(HSB,  255, 255, 255);
  // set general font 
  font = createFont("Arial",32,true);
  textFont(font);
  textAlign(CENTER, TOP);
  frameRate(30);
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
  background(255);
  // create txt file
  String filename = foldername + "/image-" + String.format("%04d", img_index); 
  if (save) output = createWriter(filename + ".txt");
  
  // draw background image
  PImage bg = getBackgroundImage();
  tint(random(10), random(255), 255-random(10));
  image(bg, 0, 0, width, height);
  
  // random fontsize for each iteration
  fontSize = minFontSize + int(random(25));
  boxW = int(fontSize * 1.3); 
  textSize(fontSize);
  // char grid
  for (int y = boxW+grid_margin; y < height - boxW; y += boxW+grid_margin) {
    for (int x = boxW+grid_margin; x < width - boxW * 2; x += boxW+grid_margin) {
      
      // get random char within the close range of the current char index,
      // so there is at least a little bit of variation in the sequencing 
      int cur_char = min(256, max(0, char_index+int(random(10))-5)); 

      // text color with some variations
      color c = color(random(10),random(100),random(30), 120 + random(100));
      fill(c);
      stroke(c);

      // draw text
      pushMatrix();
        translate(x + boxW/2, y + boxW/2);
        rotate(radians(random(angle_variation)-angle_variation/2));
        text(Character.toString(chars[cur_char]), -boxW/2, -boxW/2, boxW, boxW);
        translate(-(x + boxW/2), -(y + boxW/2));
      popMatrix();
      
      
      // inner bounding box ?
      int rect_x = x + int(float(boxW - fontSize) / 2);
      int rect_y = y + int(float(boxW - fontSize) / 1.5);

      // debug, if its not saving, display bounding boxes 
      if (!save) {
        noFill();
        stroke(cur_char, 255, 255);
        rect(x, y, boxW, boxW);
      }

      // make anotations on .txt file
      pushAnnotations(cur_char, rect_x, rect_y, fontSize, fontSize);
      // jump to next character
      char_index = (char_index + 1) % chars.length;
    }
  }
  
  // post-processing effects
  noise_layer(0.17);
  filter(BLUR, random(1)-0.4);
  
  // save
  if (save) {
    saveFrame(filename + ".png");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

void pushAnnotations(int index, int _x, int _y, int _w, int _h) {
  // percentage values, from 0 to 1, so doesn't depend on image size
  float x = float(_x) / width;
  float y = float(_y) / width;
  float w = float(_w) / width;
  float h = float(_h) / width;
  
  // darknet utilizes centralized x y coordinates
  float darknet_x = x + w / 2;
  float darknet_y = y + h / 2;
  
  // append line to .txt file
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
