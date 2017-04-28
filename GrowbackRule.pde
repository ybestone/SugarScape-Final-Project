interface GrowthRule {
  public void growBack(Square s);
}

class GrowbackRule implements GrowthRule {
  private int GrowbackRate;
  public GrowbackRule(int rate) {
    this.GrowbackRate = rate;
  }
  public void growBack(Square s) {
    int newlvl = s.getSugar() + this.GrowbackRate;
    int cap = s.getMaxSugar();
    s.setSugar(min(newlvl, cap));
  }
}

class SeasonalGrowbackRule implements GrowthRule {
  private int alpha;
  private int beta;
  private int gamma;
  private int equator;
  private int counter;
  private int numSquares;
  private boolean northSummer;
  
  public SeasonalGrowbackRule(int a, int b, int g, int e, int nS) {
    this.alpha = a;
    this.beta = b;
    this.gamma = g;
    this.equator = e;
    this.numSquares = nS;
    this.counter = 0;
    this.northSummer = true;
  }
  
  public void growBack(Square s) {

    if (s.getY() <= this.equator) {
      if (this.northSummer == true) {
        int newlvl = s.getSugar() + this.alpha;
        int cap = s.getMaxSugar();
        s.setSugar(min(cap,newlvl));
      }
      else {
        int newlvl = s.getSugar() + this.beta;
        int cap = s.getMaxSugar();
        s.setSugar(min(cap,newlvl));
      }
    }
    else {
      if (this.northSummer == false) {
        int newlvl = s.getSugar() + this.alpha;
        int cap = s.getMaxSugar();
        s.setSugar(min(cap,newlvl));
      }
      else {
       int newlvl = s.getSugar() + this.beta;
       int cap = s.getMaxSugar();
       s.setSugar(min(cap,newlvl));
      }
    }
    counter++;
    if (counter == this.gamma * this.numSquares) {
      if (this.northSummer == true) {
        this.northSummer = false;
      }
      else {
        this.northSummer = true;
      }
      counter = 0;
    }
  }
  
  public boolean isNorthSummer() {
    return this.northSummer;
  }
}