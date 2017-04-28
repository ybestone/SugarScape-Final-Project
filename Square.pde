class Square {
  private int x;
  private int y;
  private int MaxSugar;
  private int Sugar;
  private int pollution;
  private boolean containsAgent;
  private Agent occupant;
  
  public Square(int sugarlvl, int maxsugarlvl, int xPos, int yPos) {
    this.x = xPos;
    this.y = yPos;
    this.MaxSugar = maxsugarlvl;
    this.Sugar = sugarlvl;
    this. pollution = 0;
    this.containsAgent = false;
    this.occupant = null;
    if (this.MaxSugar < 0) {
      this.MaxSugar = 0;
    }
    if (this.Sugar < 0) {
      this.Sugar = 0;
    }
    if (this.Sugar > this.MaxSugar) {
      this.Sugar = this.MaxSugar;
    }
  }
  
  public int getSugar() {
    return this.Sugar;
  }
  
  public int getMaxSugar() {
    return this.MaxSugar;
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public int getPollution() {
    return this.pollution;
  }
  
  public void setSugar(int howMuch) {
    if (howMuch < 0) {
      this.Sugar = 0;
    }
    else if (howMuch > this.MaxSugar) {
      this.Sugar = MaxSugar;
    }
    else {
      this.Sugar = howMuch;
    }
  }
  
  public void setMaxSugar(int howMuch) {
    if (howMuch < 0) {
      this.MaxSugar = 0;
    }
    else {
      this.MaxSugar = howMuch;
    }
    if (this.MaxSugar < this.Sugar) {
      this.Sugar = MaxSugar;
    }
  }
  
  public void setPollution (int level) {
    this.pollution = level;
  }
  
  public Agent getAgent() {
    if (this.containsAgent == false) {
      return null;
    }
    else {
      return this.occupant;
    }
  }
  
  public void setAgent(Agent a) {
    if ((this.containsAgent == true) && (a != null) && (!this.occupant.equals(a))) {
      assert(1 == 0);
    }
    else if (a == null) {
      containsAgent = false;
      this.occupant = null;
    }
    else {
      containsAgent = true;
      this.occupant = a;
    }
    
  }
  
  public void display(int size, boolean culture, FertilityRule FertRule) {
    strokeWeight(4);
    stroke(255);
    fill(255 - (this.pollution/4.0),255-(this.pollution/4.0),255-(this.Sugar/10.0)*255);
    rectMode(CORNER);
    rect(size*this.x, size*this.y, size, size);
    if (this.occupant != null) {
      this.occupant.display((size*this.x) + (size/2),(size*this.y) + (size/2),size, culture, FertRule);
    }
  }
}