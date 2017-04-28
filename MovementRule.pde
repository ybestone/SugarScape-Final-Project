import java.util.Collections;
import java.util.LinkedList;
interface MovementRule {
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  public SugarSeekingMovementRule() { 
  }
  
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
  Collections.shuffle(neighbourhood);
  Square closest = neighbourhood.get(0);
  for (Square sq : neighbourhood) {
    if (closest.getSugar() < sq.getSugar()) {
      closest = sq;
    }
  }
  for (Square sq : neighbourhood) {
    if ((sq.getSugar() == closest.getSugar()) && (g.euclidianDistance(middle,sq) < g.euclidianDistance(middle,closest))) {
      closest = sq;
    }
  }
  return closest;
  }
  
}

class CombatMovementRule extends SugarSeekingMovementRule {
  int thresh;
  public CombatMovementRule(int alpha) {
    this.thresh = alpha;
  }
  public Square move(LinkedList<Square> neighbourhood,SugarGrid g, Square middle) {
    Agent aj = middle.getAgent();
    neighbourhood = enemiesOf(aj,neighbourhood);
    neighbourhood = weakerThan(aj,neighbourhood);
    neighbourhood = badIdea(aj,neighbourhood,g);
    LinkedList<Square> weighted = new LinkedList<Square>();
    for(Square sq : neighbourhood) {
      if (sq.getAgent() == null) {
        weighted.add(sq);
      }
      else {
        if (sq.getAgent().equals(aj)) {
          weighted.add(sq);
        }
        else {
          int bonus = min(thresh,sq.getAgent().getSugarLevel());
          Square sq1 = new Square(sq.getSugar() + bonus,sq.getMaxSugar() + bonus,sq.getX(),sq.getY());
          weighted.add(sq1);
        }
      }
    }
    Square target = super.move(weighted,g,middle);
    for (Square sq : neighbourhood) {
      if (target.getX() == sq.getX() && target.getY() == sq.getY()) {
        target = sq;
        break;
      }
    }
    if (target.getAgent() == null) {
      return target;
    }
    else if (target.getAgent().equals(aj)) {
      return target;
    }
    else {
      Agent casualty = target.getAgent();
      casualty.gift(aj, min(casualty.getSugarLevel(), thresh));
      g.killAgent(casualty);
      return target;
    }
  }
  public LinkedList<Square> enemiesOf(Agent a, LinkedList<Square> neighbourhood) {
    LinkedList<Square> list = new LinkedList<Square>();
    for (Square sq : neighbourhood) {
      if (sq.getAgent() != null) {
        if (sq.getAgent().equals(a)){
          list.add(sq);
        }
        else if (sq.getAgent().getTribe() != a.getTribe()) {
          list.add(sq);
        }
      }
      else {
        list.add(sq);
      }
    }
    return list;
  }
  public LinkedList<Square> weakerThan(Agent a, LinkedList<Square> neighbourhood) {
    LinkedList<Square> list = new LinkedList<Square>();
    for (Square sq : neighbourhood) {
      if (sq.getAgent() != null) {
        if (sq.getAgent().equals(a)){
          list.add(sq);
        }
        else if (sq.getAgent().getSugarLevel() < a.getSugarLevel()) {
          list.add(sq);
        }
      }
      else {
        list.add(sq);
      }
    }
    return list;
  }
  public LinkedList<Square> badIdea(Agent a, LinkedList<Square> neighbourhood,SugarGrid g) {
    LinkedList<Square> list = new LinkedList<Square>();
    for (Square sq: neighbourhood) {
      if (sq.getAgent() == null) {
        list.add(sq);
      }
      else {
        if (sq.getAgent().equals(a)) {
          list.add(sq);
        }
        else {
          LinkedList<Square> list1 = g.generateVision(sq.getX(),sq.getY(),a.getVision());
          if (isSafe(a,list1)) {
            list.add(sq);
          }
        }
      }
    }
    return list;
  }
  public boolean isSafe(Agent a, LinkedList<Square> neighbourhood) {
    for (Square sq : neighbourhood) {
      if (sq.getAgent() != null) {
        if (sq.getAgent().getSugarLevel() > a.getSugarLevel() && sq.getAgent().getTribe() != a.getTribe()) {
          return false;
        }
      }
    }
    return true;
  }
}

class PollutionMovementRule implements MovementRule {
  public PollutionMovementRule() {
  }
  
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    Collections.shuffle(neighbourhood);
    Square closest = neighbourhood.get(0);
    for (Square sq : neighbourhood) {
      if (sq.getPollution() == 0) {
        closest = sq;
      }
    }
    if (closest.getPollution() == 0) {
      for (Square sq : neighbourhood) {
        if ((sq.getPollution() == 0) && (closest.getSugar() < sq.getSugar())) {
          closest = sq;
        }
      }
      for (Square sq : neighbourhood) {
        if ((sq.getPollution() == 0) && (closest.getSugar() == sq.getSugar()) && (g.euclidianDistance(middle,sq) < g.euclidianDistance(middle,closest))) {
          closest = sq;
        }
      }
    }
    else {
      for (Square sq : neighbourhood) {
        if (((float)closest.getSugar() / (float)closest.getPollution()) < ((float)sq.getSugar() / (float)sq.getPollution())) {
          closest = sq;
        }
      }
      for (Square sq : neighbourhood) {
        if ((((float)closest.getSugar() / (float)closest.getPollution()) == ((float)sq.getSugar() / (float)sq.getPollution())) && (g.euclidianDistance(middle,sq) < g.euclidianDistance(middle,closest))) {
          closest = sq;
        }
      }
    }
    return closest;
  }
}