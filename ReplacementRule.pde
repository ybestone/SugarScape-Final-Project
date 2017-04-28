import java.util.LinkedList;
import java.util.List;
import java.util.HashMap;
class ReplacementRule {
  private int minAge;
  private int maxAge;
  private AgentFactory fac;
  private HashMap<Agent, Integer> span;

  public ReplacementRule(int minA, int maxA, AgentFactory f) {
    this.minAge = minA;
    this.maxAge = maxA;
    this.fac = f;
    this.span = new HashMap<Agent, Integer>();
  }

  public boolean replaceThisOne(Agent a) {
    if (a == null) {
      return false;
    }
    if (!a.isAlive()) {
      return true;
    }
    if (!span.containsKey(a)) {
      int death = (int)random(this.minAge, this.maxAge + 1);
      this.span.put(a,death);
    }
    if ((int)span.get(a) < a.getAge()) {
      a.setAge(this.maxAge + 1);
      return true;
    }
    else {
      return false;
    }
  }

  public Agent replace(Agent a, List<Agent> others) {
    return this.fac.makeAgent();
  }
}