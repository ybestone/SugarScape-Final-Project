import java.util.ArrayList;
class Agent {
  private int metabolism;
  private int vision;
  private int sugar;
  private int age;
  private char sex;
  private MovementRule move;
  private boolean[] culture;

  public Agent(int meta, int vis, int initialSugar, MovementRule m) {
    this.metabolism = meta;
    this.vision = vis;
    this.sugar = initialSugar;
    this.move = m;
    this.age = 0;
    int random = (int)random(0,2);
    if (random < 1) {
      this.sex = 'X';
    }
    else {
      this.sex = 'Y';
    }
    culture = new boolean[11];
    for (int i = 0; i < 11; i++) {
      random = (int)random(0,2);
      if (random < 1) {
        culture[i] = true;
      }
      else {
        culture[i] = false;
      }
    }
  }

  public Agent(int metabolism, int vision, int initialSugar, MovementRule m, char sex) {
    this.metabolism = metabolism;
    this.vision = vision;
    this.sugar = initialSugar;
    this.move = m;
    this.age = 0;
    if (!(sex == 'X' || sex == 'Y')) {
      throw new AssertionError();
    }
    this.sex = sex;
    culture = new boolean[11];
    int random;
    for (int i = 0; i < 11; i++) {
      random = (int)random(0,2);
      if (random < 1) {
        culture[i] = true;
      }
      else {
        culture[i] = false;
      }
    }
  }
  public int getMetabolism() {
    return this.metabolism;
  }

  public int getVision() {
    return this.vision;
  }

  public int getSugarLevel() {
    return this.sugar;
  }

  public int getAge() {
    return this.age;
  }

  public void setAge(int howOld) {
    if (howOld < 0) {
      assert(0 == 1);
    }
    this.age = howOld;
  }

  public MovementRule getMovementRule() {
    return this.move;
  }

  public void move(Square source, Square destination) {
    if ((destination.getAgent() != null) && (!destination.equals(source))) {
      assert(1 == 0);
    }
    source.setAgent(null);
    destination.setAgent(this);
  }

  public void step() {
    this.sugar -= this.metabolism;
    if (this.sugar < 0) {
      this.sugar = 0;
    }
    this.age++;
  }

  public boolean isAlive() {
    if (this.sugar > 0) {
      return true;
    }
    else {
      return false;
    }
  }

  public void eat(Square s) {
    this.sugar += s.getSugar();
    s.setSugar(0);
  }
  
  public char getSex() {
    return this.sex;
  }
  
  public void gift(Agent other, int amount) {
    if (this.sugar < amount) {
      throw new AssertionError();
    }
    this.sugar -= amount;
    other.sugar += amount;
  }
  
  public void influence(Agent other) {
    int random = (int)random(0,11);
    other.culture[random] = this.culture[random];
  }
  
  public void nurture(Agent parent1, Agent parent2) {
    for (int i = 0; i < 11; i++) {
      int random = (int)random(0,2);
      if (random < 1) {
        this.culture[i] = parent1.culture[i];
      }
      else {
        this.culture[i] = parent2.culture[i];
      }
    }
  }
  
  public boolean getTribe() {
    int counter = 0;
    for (int i = 0; i < 11; i++) {
      if (this.culture[i]) {
        counter++;
      }
    }
    if (5 < counter) {
      return true;
    }
    return false;
  }

  public void display(int x, int y, int scale, boolean culture, FertilityRule FertRule) {
    if (culture) {
      if (this.getTribe()) {
        fill(255,0,0);
      }
      else {
        fill(0,0,255);
      }
    }
    else {
      if (FertRule.isFertile(this)) {
        fill(255,0,0);
      }
      else {
        fill(0,0,255);
      }
    }
    stroke(0);
    ellipse(x,y,(3*scale)/4,(3*scale)/4);
    fill(0);
  }
}