class Translator{
 Translator(){

 }
 void primePumps(float[] pumps){
   //takes in 1.0 or 0.0 in array form from the checkboxes and translates
   //that into pumps which need to be primed before running
   int[] pumpsToPrime = new int[0];
    for(int i =0; i < pumps.length; i++){
     if(pumps[i] == 1.0){
       pumpsToPrime = append(pumpsToPrime, i+1);
     }
    }
  println(pumpsToPrime);
  //turns them all on, waits 12 seconds then turns them all off
  for(int i =0; i < pumpsToPrime.length; i++){
    myA.digitalWrite((pumpsToPrime[i]+1),Arduino.HIGH);
    println((pumpsToPrime[i]+1) + " Is ON");
  }
  delay(12000);
  for(int i =0; i < pumpsToPrime.length; i++){
    myA.digitalWrite((pumpsToPrime[i]+1),Arduino.LOW);
  }
 }
 void makeDrink(Drink theDrink){
   //note the pump number corresponds to the pin = pump# + 1
   //index number often refers to a number two less than the necessary pin
   // NOTE: index+1=pump and pump+1=pin
   
   println("Making a " + theDrink.name);
   for(int i=0; i <theDrink.ingredients.length; i++){
     myA.digitalWrite((i+2),Arduino.HIGH);
   }
   for(int i =0; i < theDrink.ingredients.length; i++){
     //each delay subtracts the previous ones
     delay(calculateDelayMS(theDrink,i));
     myA.digitalWrite((i+2),Arduino.LOW);
   }
 }
 int calculateDelayMS(Drink theDrink, int ingredientIndex){
   println(ingredientIndex);
   int delay = theDrink.ingredients[ingredientIndex].ml *1000;
   for(int i = ingredientIndex-1; i>=0;i--){
     println("THIS IS I" +i);
     delay = delay - theDrink.ingredients[i].ml*1000;
   }
   return delay;
 }
}
