/*
	LOGIC
	The stage is divided into 3 portions. RodA is in the 1st portion (from the left), RodB in 2nd portion and RodC in
	3rd portion. when a mouse click is encountered on the screen first we will check the portion of the stage on which 
	the mouse is clicked. if it is on the 1st portion then a disk is pushed to or poped from rodA, if it is in 2nd
	portion then a disk is pushed to or poped from rodB else the disk is pushed to or poped from RodC.
*/

package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class Main extends MovieClip {
		//constants
		var totalDisk:int = 6;  //total number of disks. Increase it to change the difficulty of the game           
		var Width:int = 50;     //width of the disk at the top
		
		//variables
		var currDisk:int = -1;  //the current disk that is being dragged. -1 since no disk is dragged when game starts
		var widthDiff:Number;   //width difference b/w two disks
		var steps:int;          //the number steps
		var lastRod:String;		//the rod from which the disk was poped
		
		//Arrays
		var rodA:Array = new Array();    //An array to represent all the disks of rodA 
		var rodB:Array = new Array();	 //An array to represent all the disks of rodB 
		var rodC:Array = new Array();    //An array to represent all the disks of rodC 
		var rodW:Array = new Array();	 //An array that represent's the correct order of the disks
		var disks:Array = new Array();   //An array that stores all the disks regardless of the rod it is in.
		
		public function Main(){
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseClicked); //If mouse is clicked then onMouseClicked function will be called
			createDisks();
		}
		
		//this function creates all disks
		function createDisks():void {
			msgLbl.visible = false; 
			widthDiff = (mcRodA.width - Width) / totalDisk; //calculate widthDiff
			for(var i:int = totalDisk - 1; i >= 0 ; --i){   //create all disks
				rodA.push(i);                               //push it to rodA
				var tmpDisk:mcDisk = new mcDisk();
				addChild(tmpDisk);                          //add it onto stage and set its name, position and width
				tmpDisk.name = i.toString();
				tmpDisk.x = mcRodA.x;
				tmpDisk.y = mcRodA.y  - (rodA.length*tmpDisk.height);
				tmpDisk.width = Width + (i*widthDiff);
				disks.push(tmpDisk);						//push it to disks array
			}
			rodW = rodA.slice();                            
		}
		
		//this function is cleed when a mouse click is occured
		function onMouseClicked(event:MouseEvent):void{
			var tmpRod:String;
			//If not dragging any disk pop a disk from the nearest Rod start draging
			if(currDisk == -1){
			    if(0<mouseX && mouseX<=175){  //If rodA is not empty pop from rodA
					tmpRod = "A";
					if(rodA.length != 0){
						currDisk = rodA.pop();
					}
				}else if(175<=mouseX && mouseX<=360){  //If rodA is not empty pop from rodB
					tmpRod = "B";
					if(rodB.length != 0){
						currDisk = rodB.pop();
					}
				}else if(360<mouseX && mouseX<=550){	//If rodA is not empty pop from rodC
					tmpRod = "C";
					if(rodC.length != 0){
						 currDisk = rodC.pop();
					}
				}
				lastRod = tmpRod; 				//lastRod is the Rod fro which the disk was taken
				DragDisk(currDisk,tmpRod,true); //Drag the disk after taking it from the rod
			}else if(currDisk != -1){
				var pushed:Boolean;
				var topDisk:int;
				//If any disk is being dragged then push it to the nearest Rod stop draging
				if(0<mouseX && mouseX<=175){  //Push the currnet disk into rodA if it is smaller than topDisk of rodA
					tmpRod = "A";
					if(rodA.length != 0) {
						topDisk = rodA[rodA.length - 1];
						if(topDisk > currDisk){
							rodA.push(currDisk);
							pushed = true;
						}
					}else{
						rodA.push(currDisk);
						pushed = true;
					}
				}else if(175<mouseX && mouseX<=360){ //Push the currnet disk into rodB if it is smaller than topDisk of rodB
					tmpRod = "B";
					if(rodB.length != 0) {
						topDisk = rodB[rodB.length - 1];
						if(topDisk > currDisk){
							rodB.push(currDisk);
							pushed = true;
						}
					}else{
						rodB.push(currDisk);
						pushed = true;
					}
				}else if(360<mouseX && mouseX<=550){ //Push the currnet disk into rodC if it is smaller than topDisk of rodC
					tmpRod = "C";
					if(rodC.length != 0) {
						topDisk = rodC[rodC.length - 1];
						if(topDisk > currDisk){
							rodC.push(currDisk);
							pushed = true;
						}
					}else{
						rodC.push(currDisk);
						pushed = true;
					}
				}
				//If a rod is pushed then stop dragging
				if(pushed){
					DragDisk(currDisk,tmpRod,false);
				    currDisk = -1;			//since the current disk is pushed to tmpRod set it to -1
					
				    if(tmpRod != lastRod){  //If the rod from which disk was poped is not same as the rod to which
					    ++steps;			//the disk was pushed then a move has been made so increase steps
				    }
				    stepsLbl.text = steps.toString(); //display the steps
				}
				
				//check id it is solved
				if(checkSolved(rodW)){
					msgLbl.visible = true;
					stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseClicked);
				}
			}
		}
		
		//this function will start and stop dragging a disk depending upon the value of Drag
		function DragDisk(Disk:int,Rod:String,Drag:Boolean) {
			for(var i:int = 0; i<disks.length; ++i) {  //Get the disk object by looping through all the disks
				var tmpDisk = disks[i];
				if(tmpDisk.name == Disk.toString()){
					if(Drag == true){				   //If Drag is true then start dragging
						tmpDisk.startDrag(true);
				    }else{							   //else stop draging and add the disk to a Rod
						var RodLength:int;			   //calculate RodLength so that we can add the disk to correct position
						if(Rod == "A"){        
							RodLength = rodA.length;
						}else if(Rod == "B"){
							RodLength = rodB.length;
						}else if(Rod == "C"){
							RodLength = rodC.length;
						}
						tmpDisk.x = this["mcRod" + Rod].x;
				    	tmpDisk.y = this["mcRod" + Rod].y  - (RodLength*tmpDisk.height);
						tmpDisk.stopDrag();
				    }
				}
			}
		}
		
		//This function checks if puzzle is solved
		function checkSolved(rodW:Array){
			if(rodW.length != rodC.length){ 				//if length of rod C & W are not equal then game is not solved
				return false;
			}else{
				for(var i:int = rodW.length - 1; i>=0;--i){ //if length of rodW and rodC is equal then check if each disk of rod W & C is equal
					if(rodW[i] != rodC[i])                  //if there is an inequality then game is not solved
					return false;
				}
				return true;
			}
		}
	}
}