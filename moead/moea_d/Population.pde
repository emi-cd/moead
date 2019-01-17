import java.util.ArrayList;


public class Population {
  // the number of the subproblems
  final int N = 30;
  // the number of the weight vectors in the neighborhood of each weight vector
  final int T = 10;
  // number of objectives
  final int m = 2;

  // ************
  
  
  // a uniform spread of N weight vectors
  double[][] lambda;
  ArrayList<Individual> population = new ArrayList<Individual>();
  // F-value of x^i
  double[][] FV;
  // the best value found so far for each objectives
  double[] z = new double[m];
  // store non-dominated solutions found during the search
  ArrayList<Individual> EP;
  // the T closest weight vectors to lambda^i
  ArrayList<int[]> B = new ArrayList<int[]>();
  // weight vector  
    
  
  // STEP 1
  void init() {
    // STEP 1.1
    EP = new ArrayList<Individual>();
    
    // STEP 1.2
    init_lambda();    
    for(int i=0; i<N; i++) {
      double[] distance = new double[N];
      for(int j=0; j<N; j++) {
        distance[j] = i != j ? cal_euclidean_distance(lambda[i], lambda[j]) : Double.POSITIVE_INFINITY;
      }
      B.add(get_best_index(distance));
    }
        
    // STEP 1.3 
    FV = new double[N][m];
    for(int i=0; i < N; i++) {
      double[] val = new double[N];
      for(int j=0; j<N; j++) {
        val[j] = Math.random();
      }
      Individual ind = new Individual(val);
      FV[i] = ind.get_all_fitness();
      population.add(ind);
    }
    
    // STEP 1.4
    for(int i=0; i<m; i++) {
      z[i] = cal_best_fitness(i, FV);
    }
  }
  
  
  
  // STEP 2
  void update() {
    for(int i=0; i<N; i++) {
      
      // STEP 2.1
      int k = B.get(i)[(int)(Math.random() * T)];
      int l = B.get(i)[(int)(Math.random() * T)];
      
      Individual new_ind = cross_over(population.get(k), population.get(l));
      new_ind = mutate(new_ind);
      
      // STEP 2.2
      if(EP.size() > 0)
        new_ind = cross_over(new_ind, EP.get((int)(Math.random() * EP.size())));
      new_ind.improvement();
      
      // STEP 2.3
      update_z(new_ind);
      
      // STEP 2.4
      for(int j : B.get(i)) {
        double g_te_old = cal_te(population.get(j), lambda[j]);
        double g_te_new = cal_te(new_ind, lambda[j]);
        
        if(g_te_new < g_te_old) {
          population.set(j, new_ind);
        }
      }
      
      // STEP 2.5
      for(int j=0; j<EP.size(); j++) {
        if(isDominate(new_ind, EP.get(j))) {
          EP.remove(j);
        }
      }
      boolean is_dominate = false;
      for(int j=0; j<EP.size(); j++) {
        if(isDominate(EP.get(j), new_ind))
          is_dominate = true;
      }
      if(!is_dominate)
        EP.add(new_ind);
    }
  }

  private int[] get_best_index(double[] distance) {
    int[] ret = new int[T];
    
    for(int i=0; i<T; i++) {
      double min = Double.POSITIVE_INFINITY;
      int min_index = -1;
      
      for (int j = 0; j < distance.length; j++) {
          double value = distance[j];
          if (value < min) {
              min = value;
              min_index = j;
          }
      }
      
      ret[i] = min_index;
      distance[min_index] = Double.POSITIVE_INFINITY;
    }
    return ret;
  }
  
  private double cal_best_fitness(final int index, final double[][] FV) {
    double min = Double.POSITIVE_INFINITY;
    for (int i = 0; i<FV.length; i++) {
      if(FV[i][index] < min)
        min = FV[i][index];
    }
      
    return min;
  }
  
  private double cal_euclidean_distance(double[] x, double[] y) {
    double sum = 0;
    for(int i=0; i<x.length; i++) {
      sum += (x[i] - y[i]) * (x[i] - y[i]);
    }
    return Math.sqrt(sum);
  }
  
  
  private Individual cross_over(Individual k, Individual l) {
    double[] ret = new double[N];
    
    for(int i=0; i<N; i++) {
          if(Math.random() < 0.5)
            ret[i] = k.get_ith_arg(i);
          else
            ret[i] = l.get_ith_arg(i);
    }
    
    return new Individual(ret);
  }
  
  private Individual mutate(Individual ind) {
    double[] ret = new double[N];
    
    for(int i=0; i<N; i++) {
      if(Math.random() < 0.3)
        ret[i] = Math.random();
      else
        ret[i] = ind.get_ith_arg(i);
    }
    return new Individual(ret);
  }
  
  
  private void init_lambda() {
    lambda = new double[N][m];
    for(int i=0; i<N; i++) {
      double[] tmp = new double[m];
      tmp[0] = 1.0d / (N -1) * i;
      tmp[1] = 1.0d - tmp[0];
      lambda[i] = tmp;
    }
  }
  
  private void update_z(Individual ind) {
    for(int i=0; i<m; i++) {
      if(z[i] < ind.get_ith_fitness(i))
        z[i] = ind.get_ith_fitness(i);
    }
  }
  private boolean isDominate(Individual ind, Individual dominated) {
    for(int i=0; i<m; i++) {
      if(ind.get_ith_fitness(i) > dominated.get_ith_fitness(i)) {
        return false;
      }    
    }
    return true;
  }
  
  private double cal_te(Individual ind, double[] lambda) {
    double max = Double.NEGATIVE_INFINITY;
    for(int i=0; i<m; i++) {
      double tmp = lambda[i] * Math.abs(ind.get_ith_fitness(i) - z[i]);
      if(max < tmp)
        max = tmp;
    }
    return max;
  }
  
  private void output_fitness(){
    for(Individual ind : population) 
        System.out.println(ind.get_ith_fitness(0) + ", " + ind.get_ith_fitness(1));
  }
  
  private void output_EP_fitness(){
    for(Individual ind : EP) 
        System.out.println(ind.get_ith_fitness(0) + ", " + ind.get_ith_fitness(1));
//    System.out.println(EP.size());
  }
  public ArrayList<Individual> get_population(){
    return population;
  }
  public ArrayList<Individual> get_EP(){
    return EP;
  }
  
}