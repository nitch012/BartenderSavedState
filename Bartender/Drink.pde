class Drink{
  //ensure when creating a drink that the ingredient file has the same name and capitalization
  String name; 
  String createfilepath;
  String[] ingredientlines;
  Ingredient [] ingredients;
  Drink(String myname, int numberofingredients){
     name = myname;
    ingredients = new Ingredient[numberofingredients];
    createfilepath = "DrinkInstructions/" + name + ".txt";
    ingredientlines = loadStrings(createfilepath);
    ingredientinit();
    sortingredientsbyml();
   }
  void sortingredientsbyml(){
    for(int i =0; i <ingredients.length; i++){
      Ingredient best = new Ingredient(ingredients[i]);
      int bestindex =i;
      for(int j =0; j<ingredients.length; j++){
        if(best.ml<ingredients[j].ml){
          best = new Ingredient(ingredients[j]);
          bestindex = j;
          ingswap(i,bestindex);
        }
      }
    }
  }
  private void ingswap(int indexone, int indextwo){
    Ingredient temp = new Ingredient(ingredients[indexone]);
    ingredients[indexone] = new Ingredient(ingredients[indextwo]);
    ingredients[indextwo] = new Ingredient(temp);
  }
  void show(){
    println("Number of Ingredients: " + ingredients.length);
    showallingredients();
    println("");
    showallpumps();
    println("--------------------------------------");
  }
  void showallingredients(){
    for(int i =0; i<ingredients.length; i++){
      ingredients[i].show();
    }
  }
  void showallpumps(){
    for(int i =0; i<ingredients.length; i++){
      ingredients[i].showpump();
    }
  }
  void ingredientinit(){
    int firstindex =0;
    int endindex=0;
    int ingredientindex =0;
    String name="";
    int ml=0;
    int pump=0;
    int componentsencoded =0;
    
      for(int i =0; i< ingredientlines.length; i++){
        //single line
        for(int j = 0; j<ingredientlines[i].length(); j++){
         //single character
         
        //encodes name         
         if(ingredientlines[i].charAt(j) == '$'){
             componentsencoded++;
             j++;
             firstindex=j;
             while(ingredientlines[i].charAt(j) != '$'){
               j++;
             }
             endindex=j;
            name = ingredientlines[i].substring(firstindex, endindex);
            firstindex=0;
            endindex=0;
          }
       //pump number
        if(ingredientlines[i].charAt(j) == '#'){
            componentsencoded++;
             j++;
             firstindex=j;
             while(ingredientlines[i].charAt(j) != '#'){
               j++;
             }
            endindex=j;
            pump = parseInt(ingredientlines[i].substring(firstindex, endindex));
            firstindex=0;
            endindex=0;
          }
          
        if(ingredientlines[i].charAt(j) == '%'){
             componentsencoded++;
             j++;
             firstindex=j;
             while(ingredientlines[i].charAt(j) != '%'){
               j++;
             }
            endindex=j;
            ml = parseInt(ingredientlines[i].substring(firstindex, endindex));
            firstindex=0;
            endindex=0;
          }
        }
       if(componentsencoded==3){
         //1 full ingredient successfully encoded
         componentsencoded=0;
         ingredients[ingredientindex] = new Ingredient(name,pump,ml);
         ingredientindex++;
         name= "";
         pump=0;
         ml=0;
       }
      }
    
  }
}
