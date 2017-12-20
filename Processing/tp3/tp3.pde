class City { 
  int postalcode; 
  String name; 
  float x; 
  float y; 
  float population; 
  float density; 
  float radius;
  boolean selected = false;
  boolean clicked = false;

  // put a drawing function in here and call from main drawing loop }
  void draw(){
    int densityMap = (int) map(density, minDensity, maxDensity, 30, 255);
    color c1 = color(0, densityMap);
    //set((int) x, (int) y, black);
    noStroke();
    fill(c1);
    radius = map(population, minPopulation, maxPopulation, 1, 100);
    if(selected) {
      if(!clicked) fill(255,0,0);
       else fill(0,0,255);
      textAlign(LEFT, CENTER);
      text(name, x + radius / 2 + 2, y);
      textAlign(LEFT, BASELINE);
      if(!clicked) fill(255,0,0, 64);
      else fill(0,0,255,64);
      stroke(0);
      rect(x + radius / 2 + 1, y - 5, textWidth(name) + 3, 11 + 5);
      noStroke();
      if(!clicked) fill(255,0,0, densityMap);
      else fill(0,0,255,densityMap);
    }
    ellipse(x, y, radius , radius);
  }
  
  boolean contains(float px, float py) {
    return dist(x, y, px, py) < radius / 2;
  }
}

float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
int minPopulation, maxPopulation;
int minSurface, maxSurface;
int minAltitude, maxAltitude;
float minDensity = 99999, maxDensity = 0;
int minPopulationToDisplay = 10000;
int maxPopulationToDisplay = 160000;
City cities[];
City selectedCity = null;
boolean sliderSelected = false;
float radiusSlider = 50;
int widthProgress = 500;
int heightProgress = 30;
int x = 0;
int y = 0;
  
void setup() {
  size(800,800);
  readData();
  x = width / 2 - widthProgress / 2;
  y = height - heightProgress - 20;
}

void draw(){
  background(255);
  fill(0);
  text("Afficher les populations supérieur à " + minPopulationToDisplay, 0, 10);
  for (int i = 0 ; i < totalCount ; i++)
    if(cities[i].population > minPopulationToDisplay) cities[i].draw();
    
  stroke(0);
  fill(255);
  rect(x, y, widthProgress, heightProgress);
  fill(0);
  noStroke();
  
  if(minPopulationToDisplay > maxPopulationToDisplay) minPopulationToDisplay = maxPopulationToDisplay;
  if(minPopulationToDisplay <= 0) minPopulationToDisplay = 1;
  rect(x, y, (float) log(minPopulationToDisplay) / (float) log(maxPopulationToDisplay) * widthProgress, heightProgress);
  
  fill(128);
  ellipse(x + (float) log(minPopulationToDisplay) / (float) log(maxPopulationToDisplay) * widthProgress, y + heightProgress / 2, radiusSlider,radiusSlider);
  /*
  fill(0);
  for(int i = 0; i < totalCount; i++) {
    float log = cities[i].population == 0 ? 0 : log(cities[i].population);
    float xMap = map(log, 0, log(maxPopulation), 0, 800);
     
    point(xMap, 300);
    point(map(cities[i].population, minPopulation, maxPopulation, 0, 800), 100);
  }
  */
}

void keyPressed() {
 if(key == '+') {
   minPopulationToDisplay *= 2;
 } else if(key == '-') {
   minPopulationToDisplay /= 2;
 }
 redraw();
}

void mouseMoved() {
  City city = pick(mouseX, mouseY);
  
  if(selectedCity != null && (city == null || selectedCity != city)) {
    selectedCity.selected = false;
    selectedCity.clicked = false;
  }
  
  if(city != null && selectedCity != city) {
    selectedCity = city;
    selectedCity.selected = true;
    println("MouseX: " + mouseX + " MouseY: " + mouseY + " City: " + selectedCity.name);
    redraw();
  }
}

void mousePressed() {
  if(selectedCity != null && selectedCity.selected) {
    selectedCity.clicked = true;
  }
}

void mouseDragged() {
  if(dist(x + (float) log(minPopulationToDisplay) / (float) log(maxPopulationToDisplay) * widthProgress, y, mouseX, mouseY) < radiusSlider / 2) {
    sliderSelected = true;
  }
  
  if(sliderSelected) {
    float mousePosFromSlider = mouseX - x;
    if(mousePosFromSlider > 0) {
      
      //En partant de l'equation : mouseX = (log(min) / log(max) * w) on obtient l'equation suivante pour trouver min
      minPopulationToDisplay = (int) exp(mousePosFromSlider / widthProgress * log(maxPopulationToDisplay));
    }
  }
}

void mouseReleased() {
  if(selectedCity != null && selectedCity.selected) {
    selectedCity.clicked = false;
  }
  
  sliderSelected = false;
}

City pick(int px, int py) {
  for(int i = totalCount - 1; i >= 0; i--) {
    if(cities[i].contains(px, py) && cities[i].population > minPopulationToDisplay)
      return cities[i];
  }
  return null;
}

float mapX(float x) {
 return map(x, minX, maxX, 0, 800);
}

float mapY(float y) {
 return map(y, maxY, minY, 0, 800);
}

void readData() {
  String[] lines = loadStrings("./villes.tsv");
  parseInfo(lines[0]);
  
  cities = new City[totalCount];

  for (int i = 2 ; i < totalCount + 2; ++i) {
    String[] columns = split(lines[i], TAB);
    cities[i-2] = new City();
    cities[i-2].postalcode = int(columns[0]);
    cities[i-2].name = columns[4];
    cities[i-2].x = mapX(float (columns[1]));
    cities[i-2].y = mapY(float (columns[2]));
    cities[i-2].population = int(columns[5]);
    float surface = float(columns[6]);
    cities[i-2].density = surface > 0 ? ((float) cities[i-2].population) / surface : cities[i-2].population;
    if(cities[i-2].density > maxDensity) maxDensity = cities[i-2].density;
    if(cities[i-2].density < minDensity) minDensity = cities[i-2].density;
  }
}

void parseInfo(String line) {
  String infoString = line.substring(2); // remove the #
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
  minPopulation = int(infoPieces[5]);
  maxPopulation = int(infoPieces[6]);
  minSurface = int(infoPieces[7]);
  maxSurface = int(infoPieces[8]);
  minAltitude = int(infoPieces[9]);
  maxAltitude = int(infoPieces[10]);
}