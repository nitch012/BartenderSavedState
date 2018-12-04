class Ingredient{
  String name;
  //mlrequiredindrink
  int ml;
  int pump;
  Ingredient(String myname,int pumpnumber, int mlrequired){
    name = myname;
    ml = mlrequired;
    pump=pumpnumber;
  }
  Ingredient(Ingredient copier){
    name = copier.name;
    ml = copier.ml;
    pump = copier.pump;
  }
  void show(){
    //lists ingredients and their volumes
    println(ml+ " ml of " +name);
  }
  void showpump(){
    //alerts the user to the correct pump for this ingredient
    println(name + " -> Pump " + pump);
  }
}
