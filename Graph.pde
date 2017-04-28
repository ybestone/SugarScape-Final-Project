class Graph {
  int x, y, howWide, howTall;
  String xlab, ylab;
  
  public Graph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    this.x = x;
    this.y = y;
    this.howWide = howWide;
    this.howTall = howTall;
    this.xlab = xlab;
    this.ylab = ylab;
  }
  
  public void update(SugarGrid g){
    strokeWeight(5);
    stroke(255);
    fill(255);
    rect(x,y,howWide,howTall);
    stroke(0);
    textSize(min(howWide,howTall) / 12);
    line(x, y + howTall, x + howWide, y + howTall);
    line(x, y + howTall, x, y);
    fill(0);
    text(xlab, x + (howWide/3), y + howTall + min(howWide,howTall) / 12);
    pushMatrix();
    translate(x,y);
    rotate(-PI/2.0);
    text(ylab, -howTall, -10);
    popMatrix();
  }
}

abstract class LineGraph extends Graph {
  int calls;
  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
    this.calls = 0;
  }
  public abstract int nextPoint(SugarGrid g);
  public void update(SugarGrid g) {
    if (calls == 0) {
      super.update(g);
    }
    stroke(0);
    point(x + calls, y + howTall - nextPoint(g));
    calls++;
    if (calls > howWide) {
      calls = 0;
      }
    }
  }

public class PopGraph extends LineGraph {
  int InitialPop;
  public PopGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, SugarGrid g) {
    super(x,y,howWide,howTall,xlab,ylab);
    InitialPop = g.getAgents().size();
  }
  
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> pop = g.getAgents();
    return (int)(pop.size()/2.0);
  }
  
  public void update(SugarGrid g) {
    super.update(g);
  }
}

public class AgeGraph extends LineGraph {
  public AgeGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
  }
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> pop = g.getAgents();
    int totalAge = 0;
    for (Agent a : pop) {
      totalAge += a.getAge();
    }
    double agePerCap = 4 * (totalAge)/(1.0 * pop.size());
    return (int)agePerCap;
  }
  
  public void update(SugarGrid g) {
    super.update(g);
  }
}

public class SugarGraph extends LineGraph {
  public SugarGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
  }
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> pop = g.getAgents();
    int totalsugar = 0;
    for (Agent a : pop) {
      totalsugar += a.getSugarLevel();
    }
    double sugarPerCap = (totalsugar)/(1.0 * pop.size());
    return (int)sugarPerCap;
  }
}

public class CultureGraph extends LineGraph {
  public CultureGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x,y,howWide,howTall,xlab,ylab);
  }
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> pop = g.getAgents();
    int trueCulture = 0;
    for (Agent a : pop) {
      if (a.getTribe()) {
        trueCulture++;
      }
    }
    double culturePercent = howTall * (trueCulture / (1.0 * pop.size()));
    return (int)culturePercent;
  }
}

public abstract class CDFGraph extends Graph {
  int callsPerValue;
  int numUpdates;
  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x,y,howWide,howTall,xlab,ylab);
    this.callsPerValue = callsPerValue;
    this.numUpdates = 0;
  }
  public abstract void reset(SugarGrid g);
  public abstract int nextPoint(SugarGrid g);
  public abstract int getTotalCalls(SugarGrid g);
  public void update(SugarGrid g) {
    this.numUpdates = 0;
    super.update(g);
    line(x,y + howTall,x + howWide,y);
    reset(g);
    float numPerCell = (float)howWide / (float)getTotalCalls(g);
    float Gini = 0;
    while (numUpdates < getTotalCalls(g)) {
      stroke(0);
      fill(255);
      int nP = nextPoint(g);
      rect(x + numUpdates*numPerCell, y  + howTall, numPerCell, -nP);
      Gini += nP;
      numUpdates++;
    }
    fill(0);
    text("Gini Coefficient: " + (Gini / ((howWide * howTall)/2)),1050,300);
  }
}

public class WealthCDFGraph extends CDFGraph {
  ArrayList<Agent> WealthIndex;
  int sugarstock = 0;
  int sugarSoFar = 0;
  QuickSorter msort = new QuickSorter();
  public WealthCDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x,y,howWide,howTall,xlab,ylab,callsPerValue);
  }
  public void reset(SugarGrid g) {
    WealthIndex = g.getAgents();
    msort.sort(WealthIndex);
    sugarSoFar = 0;
    sugarstock = 0;
    for (Agent a : WealthIndex) {
      sugarstock += a.getSugarLevel();
    }
  }
  public int nextPoint(SugarGrid g) {
    int sugar = 0;
    if (WealthIndex.size() - (callsPerValue * numUpdates) >= callsPerValue) {
      for (int i = callsPerValue * numUpdates; i < callsPerValue * (1 + numUpdates); i++) {
        sugar += WealthIndex.get(i).getSugarLevel();
      }
      sugar /= callsPerValue;
      sugarSoFar += sugar;
      return (int)(((float)sugarSoFar / (float)sugarstock) * howTall * callsPerValue);
    }
    else {
      for (int i = callsPerValue * numUpdates; i < WealthIndex.size(); i++) {
        sugar += WealthIndex.get(i).getSugarLevel();
      }
      sugar /= WealthIndex.size() - (callsPerValue * numUpdates);
      sugarSoFar += sugar;
      float ratio = (float)sugarSoFar / (float)sugarstock;
      return (int)(ratio*(WealthIndex.size()%callsPerValue));
    } 
  }
  
  public int getTotalCalls(SugarGrid g) {
    return WealthIndex.size() / callsPerValue;
  }
}