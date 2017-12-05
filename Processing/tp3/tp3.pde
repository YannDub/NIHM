class City { 
  int postalcode; 
  String name; 
  float x; 
  float y; 
  float population; 
  float density; 

  // put a drawing function in here and call from main drawing loop }
  void draw(){
    int densityMap = (int) map(density, minDensity, maxDensity, 30, 255);
    color c1 = color(0, densityMap);
    //set((int) x, (int) y, black);
    noStroke();
    fill(c1);
    float populationMap = map(population, minPopulation, maxPopulation, 1, 100);
    ellipse(x, y, populationMap , populationMap);
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
City cities[];

void setup() {
  size(800,800);
  readData();
}

void draw(){
  background(255);
  fill(0);
  text("Afficher les populations supérieur à " + minPopulationToDisplay, 0, 10);
  for (int i = 0 ; i < totalCount ; i++)
    if(cities[i].population > minPopulationToDisplay) cities[i].draw();
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