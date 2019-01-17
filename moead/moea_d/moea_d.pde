Population pop = new Population();
int gen = 0;
int zoom = 50;

void setup(){
  size(500, 500);
  background(255);
  noStroke();
  fill(0, 102, 153, 204);
  //frameRate(20);
  
  pop.init();
  
}

void draw_graph(final int generation_num){
  final int padding = zoom;
  final int axis_x = height - padding;
  final int axis_y = padding;
  
  stroke(0, 0, 0);
  strokeWeight(1);
  line(0, axis_x, width, axis_x);
  line(axis_y, 0, axis_y, height);
  
  textSize(12);
  text("Generation: " + generation_num, width - padding*2.5, padding/2); 
  
  strokeWeight(0.1);
  for(int i = 0; i < height; i+=zoom){
    line(0, i, width, i);
  }
  for(int i = 0; i < width; i+=zoom){
    line(i, 0, i, height);
  }
  
  strokeWeight(5);
  stroke( #000000 );
  for(Individual ind : pop.get_population()){
    point((float)(ind.get_ith_fitness(0)*zoom + axis_y), (float)(axis_x - ind.get_ith_fitness(1)*zoom));  
    System.out.println(ind.get_ith_fitness(0) + ", " + ind.get_ith_fitness(1));
  }
  
  stroke( #ffcc00 );
  for(Individual ind : pop.get_EP()){
    point((float)(ind.get_ith_fitness(0)*zoom + axis_y), (float)(axis_x - ind.get_ith_fitness(1)*zoom));  
    System.out.println(ind.get_ith_fitness(0) + ", " + ind.get_ith_fitness(1));
  }
  
}

void plot_fitness(){

}
  
  void draw() {
    pop.update();
    background(255);
    draw_graph(gen);
    gen++;
}

  