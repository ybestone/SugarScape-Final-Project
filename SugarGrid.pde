import java.util.LinkedList;
import java.util.Collections;
import java.util.ArrayList;
import java.util.HashMap;
class SugarGrid {
  private int Width;
  private int Height;
  private int sideLength;
  private GrowthRule GBrule;
  private FertilityRule FertRule;
  private ReplacementRule RepRule;
  private HashMap<Agent,Square> dict;
  private Square[][] grid;
  public SugarGrid(int w, int h, int sL, GrowthRule g, FertilityRule f, ReplacementRule r) {
    this.Width = w;
    this.Height = h;
    grid = new Square[w][h];
    this.sideLength = sL;
    this.GBrule = g;
    this.FertRule = f;
    this.RepRule = r;
    this.dict = new HashMap<Agent,Square>();
    for (int i = 0; i < this.Width; i++) {
      for (int j = 0; j < this.Height; j++) {
        this.grid[i][j] = new Square(0,0,i,j);
      }
    }
    
  }
  
  public int getWidth() {
    return this.Width;
  }
  
  public int getHeight() {
    return this.Height;
  }
  
  public int getSquareSize() {
    return this.sideLength;
  }
  
  public int getSugarAt(int i, int j) {
    return this.grid[i][j].getSugar();
  }
  
  public int getMaxSugarAt(int i, int j) {
    return this.grid[i][j].getMaxSugar();
  }
  
  public Square getSquareAt(int i, int j) {
    return this.grid[i][j];
  }
  
  public Agent getAgentAt(int i, int j) {
    if (this.grid[i][j].getAgent() != null) {
    return this.grid[i][j].getAgent();
    }
    else {
      return null;
    }
  }
  
  public void placeAgent(Agent a, int i, int j) {
    if (this.grid[i][j].getAgent() != null && a != null) {
      assert(1 == 0);
    }
    this.grid[i][j].setAgent(a);
  }
  
  public void addAgentAtRandom(Agent a) {
    int randX = int(random(0,this.Width));
    int randY = int(random(0,this.Height));
    while (this.grid[randX][randY].getAgent() != null || this.grid[randX][randY].getSugar() == 0) {
      randX = int(random(0,this.Width));
      randY = int(random(0,this.Height));
    }
    placeAgent(a,randX,randY);
  }
  public void setGrowthRule(GrowthRule g) {
    this.GBrule = g;
  }
  
  
  public double euclidianDistance(Square s1, Square s2) {
    float deltaX = min(abs(s1.getX() - s2.getX()), Width - abs(s1.getX() - s2.getX()));
    float deltaY = min(abs(s1.getY() - s2.getY()), Height - abs(s1.getY() - s2.getY()));
    return Math.sqrt(pow(deltaX,2) + pow(deltaY,2));
  }
  public void addSugarBlob(int x, int y, int radius, int max) {
    Square center = grid[x][y];
      for (int j = 0; j < Width; j++) {
        for (int k = 0; k < Height; k++) {
          for (int i = 0; i <= (max(Width,Height)); i += radius) {
            if((i - radius < euclidianDistance(grid[j][k],center)) && (euclidianDistance(grid[j][k],center) <= i)) {
              int oldmax = grid[j][k].getMaxSugar();
              grid[j][k].setMaxSugar(max(max-(i/radius),oldmax));
              if (oldmax != grid[j][k].getMaxSugar()) {
                grid[j][k].setSugar(grid[j][k].getMaxSugar());
              }
            }
          }
        }
      }
    }
  
  public ArrayList<Agent> getAgents() {
    ArrayList<Agent> agents = new ArrayList<Agent>();
    for (int i = 0; i < Width; i++) {
      for (int j = 0 ; j < Height; j++) {
        if (grid[i][j].getAgent() != null) {
          agents.add(grid[i][j].getAgent());
        }
      }
    }
    return agents;
  }
  public void hash() {
    for (int i = 0; i < Width; i++) {
      for (int j = 0 ; j < Height; j++) {
        if (grid[i][j].getAgent() != null) {
          dict.put(grid[i][j].getAgent(),grid[i][j]);
        }
      }
    }
  }
  public LinkedList<Square> generateVision(int x, int y, int radius) {
    LinkedList<Square> list = new LinkedList<Square>();
    list.add(grid[x][y]);
    for (int i = 1; i < radius + 1; i++) {
      if (x + i < getWidth()) {
        list.add(grid[x + i][y]);
      }
      else if (getWidth() <= x + i) {
        list.add(grid[x + i - getWidth()][y]);
      }
    }
    for (int i = 1; i < radius + 1; i++) {
      if (0 <= x - i) {
        list.add(grid[x - i][y]);
      }
      else if (x - i < 0) {
        list.add(grid[x - i + getWidth()][y]);
      }
    }
    
    for (int i = 1; i < radius + 1; i++) {
      if (y + i < getHeight()) {
        list.add(grid[x][y + i]);
      }
      else if (getHeight() <= y + i) {
        list.add(grid[x][y + i - getHeight()]);
      }
    }
    
    for (int i = 1; i < radius + 1; i++) {
      if (0 <= y - i) {
        list.add(grid[x][y - i]);
      }
      else if (y - i < 0) {
        list.add(grid[x][y - i + getHeight()]);
      }
    }
    return list;
  }
  
  public void killAgent(Agent a) {
    while(a.getSugarLevel() > 0) {
      a.step();
    }
    FertRule.isFertile(a);
    RepRule.replaceThisOne(a);
  }
  public void update() {
    ArrayList<Agent> population = getAgents();
    hash();
    LinkedList<Square> squares = new LinkedList<Square>();
    for (int i = 0; i < Width; i++) {
      for (int j = 0 ; j < Height; j++) {
        squares.add(grid[i][j]);
      }
    }
    Collections.shuffle(squares);
      for (Square sq: squares) {
        this.GBrule.growBack(sq);
      }
    Collections.shuffle(population);
    for (Agent a : population) {
      LinkedList<Square> fov;
      Square current  = dict.get(a);
      fov = generateVision(current.getX(),current.getY(),a.getVision());
      Square target = a.getMovementRule().move(fov,this,current);
      if (target.getAgent() == null) {
        a.move(current,target);
        current = target;
        dict.put(a,current);
      }
      LinkedList<Square> neighbours = generateVision(current.getX(),current.getY(),1);
      Collections.shuffle(neighbours);
      for (Square sq : neighbours) {
        if (sq.getAgent() != null) {
          if (!sq.getAgent().equals(a)) {
            a.influence(sq.getAgent());
          }
        }
      }
      a.step();
      if (RepRule.replaceThisOne(a)) {
          current.setAgent(null);
      }
      else {
        a.eat(current);
        LinkedList<Square> aLocal = generateVision(current.getX(), current.getY(),1);
        for (Square sq: aLocal) {
          if (sq.getAgent() != null) {
            LinkedList<Square> bLocal = generateVision(sq.getX(),sq.getY(),1);
            FertRule.breed(a,sq.getAgent(),aLocal,bLocal);
        }
      }
    }
  }
 }
  public void display(boolean culture) {
    for (int i = 0; i < Width; i++) {
      for (int j = 0 ; j < Height; j++) {
        grid[i][j].display(this.sideLength, culture, this.FertRule);
      }
    }
  }
}