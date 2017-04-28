import java.util.ArrayList;
abstract class Sorter {
  public abstract void sort(ArrayList<Agent> al);
  public boolean lessThan(Agent a, Agent b) {
    if (a.getSugarLevel() < b.getSugarLevel()) {
      return true;
    }
    else{
      return false;
    }
  }
}

class BubbleSorter extends Sorter {
  public void sort(ArrayList<Agent> al) {
    int end = al.size() - 1;
    int consec = 0;
    Agent temp;
    while (0 < end) {
      for (int i = 0; i < end; i++) {
        if (lessThan(al.get(i + 1),al.get(i)) == true){
          temp = al.get(i + 1);
          al.set(i + 1, al.get(i));
          al.set(i, temp);
          consec = 0;
        }
        else {
          consec++;
        }
      }
      end -= consec;
    }
  }
}

class InsertionSorter extends Sorter {
  public void sort(ArrayList<Agent> al) {
    int index = 0;
    while(index < al.size()) {
      Agent poorest = al.get(index);
      for (int i = index; i < al.size(); i++) {
        if (lessThan(al.get(i),poorest)) {
          poorest = al.get(i);
        }
      }
      al.set(al.indexOf(poorest),al.get(index));
      al.set(index,poorest);
      index++;
    }
  }
}

class MergeSorter extends Sorter {
  ArrayList<Agent> temp;
  public void sort(ArrayList<Agent> al) {
    if (al.size() == 0) {
      return;
    }
    temp = new ArrayList<Agent>(al);
    mergesort(al, 0, al.size() - 1);
  }

  public void mergesort(ArrayList<Agent> al, int start, int end) {
    if (end - start <= 0) {
      return;
    }
    int middle = (start + end) / 2;
    mergesort(al, start, middle);
    mergesort(al, middle + 1, end);
    merge(al,start,end);
  }

  public void merge(ArrayList<Agent> al, int start, int end) {
    int middle = (start + end) / 2;
    for (int i = start; i <= end; i++) {
      temp.set(i,al.get(i));
    }
    int index = start;
    int first = start;
    int second = middle + 1;
    while(index <= end) {
     if (first > middle && second <= end) {
       al.set(index,temp.get(second));
       second++;
     }
     else if (second > end && first <= middle) {
       al.set(index,temp.get(first));
       first++;
     }
     else if (lessThan(temp.get(first),temp.get(second))) {
        al.set(index,temp.get(first));
        first++;
      }
      else {
        al.set(index,temp.get(second));
        second++;
      }
      index++;
    }
  }
}

class QuickSorter extends Sorter {
  Agent pivot;
  public void sort(ArrayList<Agent> al) {
    quicksort(al, 0, al.size()-1);
  }
  public void quicksort(ArrayList<Agent> al, int start, int end) {
    if (start >= end) {
      return;
    }
    int index = partition(al,start,end);
    quicksort(al,start,index);
    quicksort(al,index + 1, end);
  }
  public int partition(ArrayList<Agent> al,int start,int end) {
    pivot = al.get(start + ((end - start)/2));
    int i = start;
    int j = end;
    while(true) {
      while (lessThan(al.get(i),pivot)) {
        i++;
      }
      while (lessThan(pivot,al.get(j))) {
        j--;
      }
      if (i >= j) {
        return j;
      }
      Agent temp = al.get(i);
      al.set(i,al.get(j));
      al.set(j,temp);
      i++;
      j--;
    }
  }
}
