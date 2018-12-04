import controlP5.*;
ControlP5 controlP5;
Translator myTranslator;
ScrollableList scrollable;
Button b;
Button pb;
CheckBox primerButtons;
Drink [] drinks;
String[] drinklines;
int numberofdrinks;
boolean readytoselect =false;
Drink selected;
Textarea TA;
Textarea QuestionArea;

//Arduino parts
import processing.serial.*;
import cc.arduino.*;
import processing.serial.*;
Arduino myA;
Serial myPort;

void setup(){
  size(470,360);
  background(0,0,0);
  
  //Arduino Pin setup
  myA = new Arduino(this,Arduino.list()[1]);
  myA.pinMode(2,Arduino.OUTPUT);
  myA.pinMode(3,Arduino.OUTPUT);
  myA.pinMode(4,Arduino.OUTPUT);
  
  controlP5 = new ControlP5(this);
  myTranslator = new Translator();
  //Note MAKE SURE there are no empty lines in the txt file or you will get an array
  //out of bound exception and weird behavior
  drinklines = loadStrings("AvailableDrinks.txt");
  //minus one because the first line is a caution statement
  drinks = new Drink[drinklines.length-1];
  initializedrinks();
  numberofdrinks = drinklines.length-1;
 
   // creates an option to reprime if a beverage is changed
   primerButtons = controlP5.addCheckBox("Primers")
                            .setPosition(25,275)
                            .addItem("Prime #1", 1)
                            .addItem("Prime #2", 2)
                            .addItem("Prime #3", 3);
                            
  //creates the start button
  b = controlP5.addButton("Make Drink",1,300,230,100,40);
  //creates the prime pumps button
  pb = controlP5.addButton("Prime Pumps")
                .setSize(100,40)
                .setPosition(300,280);
  //area for pump directions
  TA = controlP5.addTextarea("Pump Area")
                .setPosition(250,10)
                .setSize(200,200)
                .setColorBackground(32)
                .setText("Select a Drink to View its Setup Instructions");
 //line for question about pump changes
 QuestionArea = controlP5.addTextarea("Question")
                         .setPosition(25,255)
                         .setSize(200,19)
                         .setColorBackground(0)
                         .setText("If an Ingredient Changed Re-Prime Pump:");
  
  //scrollable list of available drinks
  scrollable = controlP5.addScrollableList("Drinks")
             .setPosition(30,10)
             .setSize(200,400)
             .setHeight(200)
             .setBarHeight(20)
             .setItemHeight(20)
             ;
   //fill up the scrollable list with all drinks
  for(int i =0; i<drinks.length;i++){
    scrollable.addItem(drinks[i].name,drinks[i]);
  }
  selected = drinks[0];
}
void draw(){
  scrollable.setOpen(true);
}
void keyPressed(){
  if(key=='m'){
    showfullmenu();
  }
}
void showfullmenu(){
  println("|><><><><><><|Drink List|><><><><><><|\n\n");
  println("--------------------------------------");
  showalldrinks();
}
void initializedrinks(){
    String name="";
   int firstindex=0;
   int endindex=0;
   int numberofingredients=0;
   //NOTE: we start at 1 beacause the first line of the file is a safety warning
    for (int i =1; i<drinklines.length; i++){
      //accessing a single line
      for(int j=0; j<drinklines[i].length();j++){
        //accessing single character in a single line
          if(drinklines[i].charAt(j) == '~'){
            //~ is used to indicate the start and end of the name
            j++;
            firstindex = j;
            while(drinklines[i].charAt(j) != '~'){
              j++;
            }
            endindex= j;
            name = drinklines[i].substring(firstindex, endindex);
            firstindex=0;
            endindex=0;
          }
          if(drinklines[i].charAt(j) == '!'){
            //! indicates the start of the number of ingredients
            j++;
           numberofingredients = (int(drinklines[i].charAt(j))-48);
          }
       }
      drinks[i-1] = new Drink(name, numberofingredients);
    }
}
void showalldrinks(){
  for(int i =0; i< numberofdrinks;i++){
    println("|" + (i+1) + "| " + drinks[i].name);
    println("--------------------------------------");
    drinks[i].show();
  }
}
void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.
  if (theEvent.isController()) {
    if(theEvent.getController()==scrollable){
      //translate Drink @ index
      TA.setText("");
      selected = drinks[(int)theEvent.getController().getValue()];
      String pumplines = "Drink Instructions:\n\n";
      for(int i =0; i<selected.ingredients.length;i++){
        pumplines = pumplines + selected.ingredients[i].name + " -> " + selected.ingredients[i].pump + "\n";
      }
      //erase previous drink message and rewrite new one
      background(0,0,0);
      TA.setText(pumplines);
    }
    if(theEvent.getController() == b){
      // make drink selected (Defaults to the RumandCoke or whatever is first in drinks
      myTranslator.makeDrink(selected);
    }
    if(theEvent.getController() ==pb){
      //prime pumps for which an ingredient change was made
      myTranslator.primePumps(primerButtons.getArrayValue());
      println("Pumps Primed");
    }
  }
}
