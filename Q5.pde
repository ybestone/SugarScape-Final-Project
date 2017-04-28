import java.util.HashMap;
SugarGrid myGrid;
PopGraph myGraph;
SugarGraph myGraph1;
AgeGraph myGraph2;
CultureGraph myGraph3;
void setup(){
  size(1800,1600);
  MovementRule move = new CombatMovementRule(3);
  AgentFactory fac = new AgentFactory(1,4,1,6,50,100,move); 
  GrowthRule grow = new GrowbackRule(1);
  HashMap<Character,Integer[]> c = new HashMap<Character,Integer[]>();
  HashMap<Character,Integer[]> o = new HashMap<Character,Integer[]>();
  Integer[] arr1 = {0,0};
  Integer[] arr2 = {100,100};
  Integer[] arr3 = {100,100};
  c.put('X',arr1);
  c.put('Y',arr1);
  o.put('X',arr2);
  o.put('Y',arr3);
  ReplacementRule rep = new ReplacementRule(60,100,fac);
  myGrid = new SugarGrid(50,50,24,grow,new FertilityRule(c,o),rep);
  myGrid.addSugarBlob(16,33,4,5);
  myGrid.addSugarBlob(33,17,4,5);
  for (int i = 0; i < 50; i++) {
    myGrid.addAgentAtRandom(fac.makeAgent());
  }
  myGraph = new PopGraph(50,1225,1150,325,"Time", "Population",myGrid);
  myGraph1 = new SugarGraph(1250,25,500,350,"Time","Average Sugar");
  myGraph2 = new AgeGraph(1250,425,500,350,"Time","Age");
  myGraph3 = new CultureGraph(1250,825,500,350,"Time","True Culture %");
  frameRate(15);
}
boolean culture = true;
void keyPressed() {
  if (key == ENTER) {
    if (culture) {
      culture = false;
    }
    else {
      culture = true;
    }
  }
}
void draw(){
    myGrid.update();
    myGrid.display(culture);
    myGraph.update(myGrid);
    myGraph1.update(myGrid);
    myGraph2.update(myGrid);
    myGraph3.update(myGrid);
    fill(255);
    rectMode(CORNER);
    rect(1250,1225,500,325);
    fill(255,0,0);
    stroke(0);
    line(0,1200,1200,1200);
    line(1200,0,1200,1200);
    ellipse(1300,1400,30,30);
    fill(0,0,255);
    ellipse(1300,1500,30,30);
    fill(0);
    text("Press Enter to switch view.", 1275,1275);
    if (culture) {
      text("Now viewing: Culture",1275,1325);
      text("True Culture",1350,1410);
      text("False Culture",1350,1510);
    }
    else {
      text("Now viewing: Fertility",1275,1325);
      text("Fertile",1350,1410);
      text("Infertile",1350,1510);
    }
}