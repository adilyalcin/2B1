 import processing.serial.*;
 
 Serial player1; 
 Serial player2;


int window_Height = 800;
int window_Width = 700;
float powered = 0; 
float pTime;
float currTime = 0;
int lastElapsedTime, lastElapsedTime2;
boolean locked = false;

boolean beInvincible = false;
boolean reset = true;
boolean increaseSpeed = false;
boolean powerUpActive = false;
int[] playArea = {50,750,160,650};
long start;
long elapsedTime2; 
// Do something ...

// Get elapsed time in milliseconds

float remLevelTime;
float speedLim = 0.5;

PImage imgBack;

// Player Data
Bunny bunny;
PImage imgBunny, imgBunny2;

// Rocks
ArrayList<Rock> rocks;
PImage imgRock1,imgRock2,imgRock3;
// Carrots
ArrayList<Carrot> carrots;
ArrayList<PowerUp> powerups; 
PImage imgCarrot;
// Wolves
ArrayList<Wolf> wolves;
PImage imgWolf;
// Home of our rabbit
//Home home;
PImage imgHome;

/*
Wolf[] ships;
int num_balls = 5; 
Carrot[] carrots = new Carrot[num_balls];
//Prize[] prizes = new Prize[5];
int score = 0;
int num_prizes; 

ArrayList<Prize> prizes = new ArrayList();
int x;
float[] scalars = {1,1,1,1,1,1,1,1,1,1};
Ship sh;
*/
PFont font;

void restart(){

}

float getRandX(){ return random(playArea[0],playArea[1]); }
float getRandY(){ return random(playArea[2],playArea[3]); }









void keyPressed(){
if (key == BACKSPACE){ //resets level 

  	resetLevel(1); 
reset = true;
return;
  
  
}

} // End of keyPressed()

void serialEvent (Serial myPort) {
  boolean playerNo = (myPort==player1);
  String inString = myPort.readStringUntil('\n');
 
 float in = float(inString);
 
 if (!increaseSpeed){
 if (inString != null) {
   if(playerNo==false && in==1){
     bunny.SpeedY(-0.01); 
   }
   if(playerNo==false && in==2){
     bunny.SpeedY(0.01); 
   }
   if(playerNo==true && in==1){
     bunny.SpeedX(-0.01); 
   }
   if(playerNo==true && in==2){
     bunny.SpeedX(0.01); 
   }
   
 
   println("playerNo:"+playerNo+" code:"+inString);
 }
 
}else{ //in case bunny is poweredup 
  
   if (inString != null) {
   if(playerNo==false && in==1){
     bunny.SpeedY(-0.025); 
   }
   if(playerNo==false && in==2){
     bunny.SpeedY(0.025); 
   }
   if(playerNo==true && in==1){
     bunny.SpeedX(-0.025); 
   }
   if(playerNo==true && in==2){
     bunny.SpeedX(0.025); 
   }
  
   } 
  
  
}

/*in order to activate locks*/

if (inString != null){
  
 if (in == 5){
 locked = true; // now you can choose a powerup  
   
   
 }
 
 
}


if (locked){
if (inString != null){
if (!powerUpActive){
if (playerNo==true && in==3 ){ //testing powers
 for (PowerUp p: powerups){
    if (p.active == true && p.getPower() == 0){ //freeze
      powered = 10000;
      powerUpActive = true;
  p.permission = true; 
     return;  
    } 
}
}

if (playerNo==false && in==4 ){
 for (PowerUp p: powerups){
    if (p.active == true && p.getPower() == 1){ //slow
      powered = 10000;
      powerUpActive = true;
  p.permission = true; 
     return;  
    } 
}
}


if (playerNo==true && in== 3){
 for (PowerUp p: powerups){
    if (p.active == true && p.getPower() == 2){ //invisible
      powered = 10000;
      powerUpActive = true;
  p.permission = true; 
     return;  
    } 
}
}


if (playerNo==true && in==4){
 for (PowerUp p: powerups){
    if (p.active == true && p.getPower() == 3){ //increase speed
      powered = 10000;
      powerUpActive = true;
  p.permission = true; 
     return;  
    } 
}
}
}

}

}

}



void resetLevel(int levelNo){
	// randomly spawn static rocks in the game

powered = 0;
	rocks.clear();
	for(int i=0 ; i<50; i++){
		rocks.add(new Rock(getRandX(), getRandY(),int(random(3))%3));
	}
	// randomly spawn carrots
	carrots.clear();
	for(int i=0 ; i<10; i++){
		carrots.add(new Carrot(getRandX(), getRandY()));
	}
	// randomly spawn wolves
	wolves.clear();
	for(int i=0 ; i<10; i++){
		wolves.add(new Wolf(getRandX(), getRandY()));
	}
	
powerups.clear();
for(int i=0 ; i<4; i++){
		powerups.add(new PowerUp(getRandX(), getRandY(), i));
	}
	// set player starting position
	float playerX = getRandX();
	float playerY = getRandY();
	bunny.setPosition(playerX, playerY);
//	home.setPosition(playerX, playerY);
	
	// TODO: Make sure carrots/ wolves / rocks do not intersect!
pTime = 1000;

	lastElapsedTime = millis();
lastElapsedTime2 = millis();
	remLevelTime = 120000; // 120 sec
}

void setup(){
   // List all the available serial ports
 println(Serial.list());

  player1 = new Serial(this, Serial.list()[4], 9600);
  player2 = new Serial(this, Serial.list()[6], 9600);

 // don't generate a serialEvent() unless you get a newline character:
 player1.bufferUntil('\n');
  player2.bufferUntil('\n'); 
  
  
  
	// setup display
start = millis();

	size(window_Height,window_Width);
	smooth();
	imageMode(CENTER);

	// setup resources
	font = loadFont("AppleSDGothicNeo-ExtraBold-32.vlw");
	imgBack = loadImage("background.png");
	imgRock1 = loadImage("rock.png");
	imgRock2 = loadImage("rock2.png");
	imgRock3 = loadImage("rock4.png");
	imgCarrot = loadImage("carrot.png");
	imgBunny = loadImage("bunny3.png");
	imgBunny2 = loadImage("bunny2.png");
	imgWolf = loadImage("wolf.png");
	imgHome = loadImage("bunny3.png");

	// setup game elements
        powerups= new ArrayList();
	rocks = new ArrayList();
	carrots = new ArrayList();
	bunny = new Bunny();
	wolves = new ArrayList();

	resetLevel(1);
/*
int currTime = 0;
font = loadFont("AppleSDGothicNeo-ExtraBold-32.vlw");
while (currTime < currTime + 301){
  if (currTime == 100){
    text("1", 50,50);
  }else if (currTime == 200){
    text("2", 50,50);
  }else if (currTime == 300){
    text("3", 50,50);
  }
    
    
    
  
  
 currTime++; 

}
*/
}

void timestep(int msec){
	// move bunny
	bunny.iter(msec);
	
	for(Wolf w: wolves) { w.iter(msec); }
	
	// see if bunny eats any carrot
	for(Carrot c: carrots) {
		// use simple absolute distance
		if(sq(c.xpos-bunny.xpos)+sq(c.ypos-bunny.ypos)<1000){
			c.eaten = true;
		}
	}
for(PowerUp p: powerups) {
		// use simple absolute distance
		if(sq(p.xpos-bunny.xpos)+sq(p.ypos-bunny.ypos)<1000){
		//	p.eaten = true;
                        p.moveP(p.getPower());
                        p.setTrue();
		}
	}

	// see if bunny gets eaten
	for(Wolf w: wolves) {
		// use simple absolute distance
if (!beInvincible){	
	if(sq(w.xpos-bunny.xpos)+sq(w.ypos-bunny.ypos)<1300){
			resetLevel(1); 
reset = true;
return;
		}
	}
	
}

}
PowerUp curr;

void in_reset(){
  
  if (reset){
    beInvincible = true;
  }else{
    beInvincible = false;
  }
  
}
void draw(){
  if (reset){
  
int elapsedTime = millis();
	int timeDif = elapsedTime-lastElapsedTime;
	timestep(timeDif);
	lastElapsedTime = elapsedTime;
	background(imgBack);
	
	

	
	// ********************************************************
	// draw header
	
		// Print remaning carrot count
	textFont(font);
	int remCarrot = 0;
	for(Carrot c: carrots) { if(c.eaten==false) remCarrot++; }
//for(PowerUp p: powerups) { if(p.eaten==true) ; p.moveP(p.getPower()); }
	text(""+remCarrot, 10, 50);
		// draw remaining time rectangle
		pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 12);
		if(remLevelTime>20000) fill(20,100,200); else fill(200,100,20);
		rect(0,0,214*remLevelTime/120000,14);
		popMatrix();

//	in_reset();

/*
for(Rock r: rocks) r.draw();
//for(Wolf w: wolves) w.draw();
	for(Carrot c: carrots) { if(c.eaten==false) c.draw(); }
for(PowerUp p: powerups) { if(p.eaten==false) p.draw(); }
bunny.draw();
*/
//tint(255,126);	
      //background(0);
    textSize(600);
    fill(255);
int posx = width/2 - 150;
int posy =width/2 + 150;
//textMode(CENTER);
  if (currTime > 0 && currTime < 30){ //print 3
    text("3", posx,posy);
  }else if (currTime >  100 && currTime < 130){ //print 2
    text("2", posx, posy);
  }else if (currTime > 200 && currTime < 230){ //print 1
    text("1", posx, posy);
 reset = false;
 currTime = 0;
  }
    
    
    

  
 currTime = currTime + 2; 

  

  // reset = false;
}else{
  noTint();
  
	int elapsedTime = millis();
	int timeDif = elapsedTime-lastElapsedTime;
	timestep(timeDif);


	lastElapsedTime = elapsedTime;
	background(imgBack);
	
	remLevelTime -= timeDif;
	if(remLevelTime<0){
		// game over... TODO
		remLevelTime = 0;
	}

	
	// ********************************************************
	// draw header
	
		// Print remaning carrot count
	textFont(font);
	int remCarrot = 0;
	for(Carrot c: carrots) { if(c.eaten==false) remCarrot++; }
//for(PowerUp p: powerups) { if(p.eaten==true) ; p.moveP(p.getPower()); }
	text(""+remCarrot, 10, 50);
if (remCarrot== 0){
  
  int posx = width/2 - 150;
int posy =width/2;
fill(0);
    text("Congratulations! You Won!", posx, posy);
    
    resetLevel(1);
    reset = true;
    
    
}



		// draw remaining time rectangle
		pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 12);
		if(remLevelTime>20000) fill(20,100,200); else fill(200,100,20);
		rect(0,0,214*remLevelTime/120000,14);
		popMatrix();
//Power:

              pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 44);
		if(powered > 0) {fill(255,255,0); }





if (powered > 0){
 
 	
  
 for (PowerUp p: powerups){
    if (p.active == true && p.permission == true){
  curr = p;
    }
    
     font = loadFont("AppleSDGothicNeo-ExtraBold-32.vlw");
textFont(font);

if (locked){
  text("Locked", -100, 60); 
  text("", -100,60);
  text("Locked", -100, 60);   
  text("", -100,60);
}

if (curr != null){
fill(0);
  if (curr.getPower() == 0){
 
text("Power Up: Freeze Wolves", -100, 60); 
}else if (curr.getPower() == 1){
text("Power Up: Slow Down Wolves", -100, 60); 
 }  else if (curr.getPower() == 2){
text("Power Up: You Are Invincible", -100, 60); 
 }else if (curr.getPower() == 3){
text("Power Up: Increase Speed", -100, 60); 
 }
 }
 }
      curr.activate(curr.getPower());
 println(curr.getPower());
   
   {fill(255,255,0); }
if (powered > 0 && powered < 300){
  
  fill(200,100,20);

}
  

   
  rect(0,0,214*powered/10000,14);
}

int elapsedTime2 = millis();
	int timeDif2 = elapsedTime2-lastElapsedTime2;
	timestep(timeDif2);


	lastElapsedTime2 = elapsedTime2;
	powered -= timeDif2;

if (powered < 1 && curr != null){
 if (curr.getPower() == 2){
  beInvincible = false; 
 }
 if (curr.getPower() == 3){
  increaseSpeed = false; 
 }
 
 powerUpActive = false;
  curr.reset();
    locked = false;
  curr.active = false;
  curr.permission = false;
//   PowerUps.remove(curr);
}	
popMatrix();


	// *********************************************************
	// draw game objects
	/*
	for(Rock r: rocks) r.draw();

	for(Carrot c: carrots) { if(c.eaten==false) c.draw(); }
for(PowerUp p: powerups) { if(p.eaten==false) p.draw(); }
	bunny.draw();


*/

}
 for(Rock r: rocks) r.draw();

	for(Carrot c: carrots) { if(c.eaten==false) c.draw(); }
for(PowerUp p: powerups) { if(p.eaten==false) p.draw(); }
bunny.draw();

	for(Wolf w: wolves) {
  w.draw();
  println(w.speed);
}
 if (reset){
 tint(255,126);
 }else{
   noTint();
   
 }
 

 
 


} // End of draw()


class Rock{
	float xpos, ypos, scalar;
	int rType;

	Rock(float x, float y, int t) {
		xpos = x;
		ypos = y;
		scalar = 1.0;
		rType = t;
	}

	void draw() { image(imgRock1,xpos, ypos,50,50); }
}

float getRotation(float xSpeed, float ySpeed){
	float a = atan(ySpeed/xSpeed);
	if(a<0) a+=TWO_PI;
	if(xSpeed<0) a += TWO_PI/2;
	if(a>TWO_PI) a-=TWO_PI;
	a+=TWO_PI/4;
	if(xSpeed==0){ if(ySpeed<0) a = 0; else a = TWO_PI/2; }
	return a;
}

class Bunny{
	float xpos, ypos;
	float xSpeed, ySpeed;
	
	float rot;
	
	Bunny(){
		xSpeed = ySpeed = 0;
		rot = 0;
	}
void invincibleBunny(){
  pushMatrix();
		translate(xpos,ypos);
		scale(1.0/8);
		rotate(getRotation(xSpeed,ySpeed));
		image(imgBunny2,0,0);


/*if (beInvincible){
  
  tint(255,126);	
}else{
  noTint();
}*/
		popMatrix();
  
}
	void draw(){
		pushMatrix();
		translate(xpos,ypos);
		scale(1.0/8);
		rotate(getRotation(xSpeed,ySpeed));
		image(imgBunny,0,0);
		popMatrix();
	}
	void setPosition(float x, float y){
		xpos=x; ypos=y;
	}
	void iter(int msec){
		float oldX = xpos;
		float oldY = ypos;
		xpos+=xSpeed*msec;
		ypos+=ySpeed*msec;
		if(xpos<playArea[0]||xpos>playArea[1]){
			xpos = oldX; xSpeed=0;
		}
		if( ypos<playArea[2]||ypos	>playArea[3]){
			ypos = oldY; ySpeed=0;
		}
		// reduce speed
		ySpeed *= pow(0.999,msec/3);
		xSpeed *= pow(0.999,msec/3);
	}
    
        void increaseSpeed(){
         // int elapsedTime = millis();
	  // elapsedTime-lastElapsedTime;
          //println("hi");
          increaseSpeed = true;
//           xSpeed += .02;
  //          ySpeed += .02; 
          //  println(xSpeed);
         //   println(ySpeed);
      
        }
    
	void SpeedX(float adj){ 
		xSpeed +=adj; 
		xSpeed = min(max(-speedLim,xSpeed),speedLim);
	}
	void SpeedY(float adj){ 
		ySpeed +=adj; 
		ySpeed = min(max(-speedLim,ySpeed),speedLim);
	}


}

class Wolf{
	float xpos, ypos;
	float rot; // angle
	float speed;
	
	Wolf(float x, float y){
		xpos=x; ypos=y;
		speed = 0.04;
		rot = random(0,TWO_PI);
	}
	void draw(){
		pushMatrix();
		translate(xpos,ypos);
		scale(1.0/8);
//		rotate(rot+TWO_PI/2);
		image(imgWolf,0,0);
		popMatrix();
	
}

void decreaseSpeed(){
 speed = .02; 
  
}


void freeze(){
  
   //int s = second();
 //while (s < second() + 5){ 
  speed = 0;
 //}
//  delay(50000); 
  
}
	void iter(int msec){
		// randomly change direction
		if(random(5000)<=msec){
			rot = random(0,TWO_PI); speed = 0.03;
		}
		float oldX = xpos;
		float oldY = ypos;
		// generate speed from rotation
		float xSpeed = cos(rot)*speed;
		float ySpeed = sin(rot)*speed;
		xpos+=xSpeed*msec;
		ypos+=ySpeed*msec;
		if(xpos<playArea[0]||xpos>playArea[1]){
			xpos = oldX; xSpeed=0; 
			// escape faster
			rot = random(0,TWO_PI); speed = 0.05;
		}
		if( ypos<playArea[2]||ypos	>playArea[3]){
			ypos = oldY; ySpeed=0;
			// escape faster
			rot = random(0,TWO_PI); speed = 0.07;
		}
	}
}

class Carrot{
	float xpos, ypos, scalar;
	
	boolean eaten; // if eaten, becomes invisible and no longer eatable, I just didn't want to mess with object deletion :)
	Carrot(float x, float y) { 
		xpos = x; ypos = y;
		eaten = false;
	}
	void draw()  { image(imgCarrot,xpos,ypos,202/8,550/8); }
}


class PowerUp{
	float xpos, ypos, scalar;
int power;
color c; 
boolean active, permission;
	
	boolean eaten; // if eaten, becomes invisible and no longer eatable, I just didn't want to mess with object deletion :)
	PowerUp(float x, float y, int p) { 
		xpos = x; ypos = y;
		eaten = false;
permission = false;
active = false;
power = p;
 if (power == 0) { //freeze all wolves
   c= color(100,0,0);

  } else if (power == 1){ //slow speed of wolves
 c = color(0,100,0);
 

  }else if (power ==2){ //be invisible
  c = color(0,0,100);


  }  else if (power ==3){ //increase speed
 // bunny.increaseSpeed(); 
  
   c = color(100, 0 , 100); 
  }


	}

void moveP(int power){
 if (power == 0) { //freeze all wolves
  xpos = 550;
ypos = 12; 
  
  } else if (power == 1){ //slow speed of wolves
   xpos = 610;
ypos = 12; 
  }else if (power ==2){ //be invisible
  xpos = 670;
ypos = 12; 
  } 
  
   else if (power ==3){ //increase speed
  xpos = 730;
 ypos = 12; 
  
    
  }
/* if 

  */
  
}
void reset(){
 if (active == true){
   xpos = getRandX();
     ypos = getRandY(); 
  
 } 
  
}

int getPower(){
 return power;  
  
}

void setTrue(){
  
  active = true;
}
	void draw()  { 
  
fill(c); 
   
  rect(xpos, ypos, 47,47);
//image(imgCarrot,xpos,ypos,202/8,550/8); 
}
void activate(int power){
  
  if (power == 0) { //freeze all wolves

   for (Wolf wolf: wolves){
         wolf.freeze(); 
       }

  } else if (power == 1){ //slow speed of wolves
  
   for (Wolf wolf: wolves){
         wolf.decreaseSpeed(); 
       }

  }else if (power ==2){ //be invisible
 // bunny.invincibleBunny();
beInvincible = true; 

  } else if (power ==3){ //increase speed
  bunny.increaseSpeed(); 
  
    
  }
  
  
}

}



 
  
  
  
