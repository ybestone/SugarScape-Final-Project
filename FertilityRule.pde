import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
class FertilityRule {
  private Map<Character,Integer[]> start;
  private Map<Character,Integer[]> stop;
  private Map<Agent,int[]> info;
  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character,Integer[]> climactericOnset) {
    this.start = childbearingOnset;
    this.stop = climactericOnset;
    this.info = new HashMap<Agent,int[]>();
  }
  public boolean isFertile(Agent a) {
    if (a == null) {
      return false;
    }
    if (!a.isAlive()) {
      info.remove(a);
      return false;
    }
    if (!info.containsKey(a)) {
      Integer[] childbear = start.get(a.getSex());
      Integer[] climac = stop.get(a.getSex());
      int c = (int)random(childbear[0],childbear[1] + 1);
      int o = (int)random(climac[0],climac[1] + 1);
      int s = a.getSugarLevel();
      int[] cos = {c,o,s};
      info.put(a,cos);
    }
    int[] current = info.get(a);
    if (current[2] <= a.getSugarLevel() && (int)current[0] <= a.getAge() && a.getAge() < (int)current[1]) {
      return true;
    }
    return false;
  }
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {
    if (isFertile(a) && isFertile(b) && a.getSex() != b.getSex() && neighbourhoodContains(b, local) && vacancy(local)) {
      return true;
    }
    return false;
  }
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal) {
    if (!(canBreed(a,b,aLocal) || canBreed(b,a,bLocal))) {
      return null;
    }
    int meta;
    if(coinflip() < 1) {
      meta = a.getMetabolism();
    }
    else {
      meta = b.getMetabolism();
    }
    int vis;
    if (coinflip() < 1) {
      vis = a.getVision();
    }
    else {
      vis = b.getVision();
    }
    char sex;
    if (coinflip() < 1) {
      sex = 'X';
    }
    else {
      sex = 'Y';
    }
    Agent child = new Agent(meta,vis,0,a.getMovementRule(),sex);
    a.gift(child,info.get(a)[2]/2);
    b.gift(child,info.get(b)[2]/2);
    child.nurture(a,b);
    LinkedList<Square> birth = vacate(aLocal,bLocal);
    Collections.shuffle(birth);
    birth.get(0).setAgent(child);
    return child;
  }
  //helper methods
  public boolean neighbourhoodContains(Agent s, LinkedList<Square> local) {
    for (Square sq : local) {
      if (sq.getAgent() != null) {
        if (sq.getAgent().equals(s)) {
          return true;
        }
      }
    }
    return false;
  }
  public boolean vacancy(LinkedList<Square> local) {
    for (Square sq : local) {
      if (sq.getAgent() == null) {
        return true;
      }
    }
    return false;
  }
  public LinkedList<Square> vacate(LinkedList<Square> a, LinkedList<Square> b) {
    LinkedList<Square> list = new LinkedList<Square>();
    for (Square sq : a) {
      if (sq.getAgent() == null) {
        list.add(sq);
      }
    }
    for (Square sq : b) {
      if (sq.getAgent() == null) {
        list.add(sq);
      }
    }
    return list;
  }
  public int coinflip() {
    return (int) random(0,2);
  }
}