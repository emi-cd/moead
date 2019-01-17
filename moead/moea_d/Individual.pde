
public class Individual {
  private double[] x;
  private double[] fitness = new double[2];
    
  // ****** MOP(ZDT1) ******
  double f1(double[] ind){
    return ind[0];
  }

  double g(double[] x) {
    double sum = 0;
    for(int i=1; i< x.length; i++) 
      sum += x[i];
    return 1 + 9*sum/(x.length - 1);
  }

  double f2(double[] ind) {
    double ans_g = g(ind);
    return ans_g*(1-Math.sqrt(f1(ind)/ans_g));
  }
  // ********************
    
  Individual(double[] ind){
    this.x = ind;
    fitness[0] = f1(ind);
    fitness[1] = f2(ind);    
    }
    
  double get_ith_fitness(int i) {
    return fitness[i];
  }
  
  double get_ith_arg(int i) {
    return x[i];
  }
    
  double[] get_all_fitness() {
    return fitness;
  }
  
    void improvement() {
        for(int j=1; j<x.length; j++) {
          x[j] = x[j] * 0.5;
        }
      }
      
    
}