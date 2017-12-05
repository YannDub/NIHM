float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
int minPopulation, maxPopulation;
int minSurface, maxSurface;
int minAltitude, maxAltitude;

int X = 1;
int Y = 2;

float x[];
float y[];

void setup() {
  size(800,800);
  readData();
}

void draw(){
  background(255);
  color black = color(0);
  for (int i = 0 ; i < totalCount ; i++)
    set((int) mapX(x[i]), (int) mapY(y[i]), black);
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
  
  x = new float[totalCount];
  y = new float[totalCount];

  for (int i = 2 ; i < totalCount ; ++i) {
    String[] columns = split(lines[i], TAB);
    x[i-2] = float (columns[1]);
    y[i-2] = float (columns[2]);
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