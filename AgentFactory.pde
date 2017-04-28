class AgentFactory {
  private int minMeta;
  private int maxMeta;
  private int minVis;
  private int maxVis;
  private int minSug;
  private int maxSug;
  private MovementRule move;
  
  public AgentFactory(int minM, int maxM, int minV, int maxV, int minS, int maxS, MovementRule m) {
    this.minMeta = minM;
    this.maxMeta = maxM + 1;
    this.minVis = minV;
    this.maxVis = maxV + 1;
    this.minSug = minS;
    this.maxSug = maxS + 1;
    this.move = m;
  }
  
  public Agent makeAgent() {
    return new Agent((int)random(this.minMeta,this.maxMeta),(int)random(this.minVis,this.maxVis),(int)random(this.minSug,this.maxSug),this.move);
  }
}