// Display related data
int window_Height = 800;
int window_Width = 700;
float powered = 0; 
float pTime;
int lastElapsedTime;
boolean beInvincible = false;
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
PImage imgBunny;

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
/*	sh = new Ship(200,300, 1);
	for (int i = 0; i < num_balls; i++) {
		carrots[i].drawCarrot();
	}*/
}

float getRandX(){ return random(playArea[0],playArea[1]); }
float getRandY(){ return random(playArea[2],playArea[3]); }

void resetLevel(int levelNo){
	// randomly spawn static rocks in the game
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
	remLevelTime = 60000; // 60 sec
}

void setup(){
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
	imgWolf = loadImage("wolf.png");
	imgHome = loadImage("bunny3.png");

	// setup game elements
        powerups= new ArrayList();
	rocks = new ArrayList();
	carrots = new ArrayList();
	bunny = new Bunny();
	wolves = new ArrayList();
/*	
	for(int i=0;i<num_balls;i++){
		carrots[i] = new Carrot(startX[i], startY[i],1); 
	}

	sh = new Ship(200,300, 1);
	for (int i = 0; i < num_balls; i++) {
		carrots[i].drawCarrot();
	}

	for(int i=0;i<num_prizes;i++){
		Prize a = new Prize(startX[i], startY[i],1); 
		prizes.add(a);
	}
*/
	resetLevel(1);
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
			resetLevel(1); return;
		}
	}
	
}
/*	for (Iterator<Prize> iter = prizes.iterator(); iter.hasNext(); ) {
		Prize p = iter.next();
		if (abs(p.xpos - sh.getX())  < 70 && abs (p.ypos - sh.getY()) <30) {
			iter.remove();
			score++;
		}
	}*/
}

void draw(){
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
		// draw remaining time rectangle
		pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 12);
		if(remLevelTime>20000) fill(20,100,200); else fill(200,100,20);
		rect(0,0,214*remLevelTime/60000,14);
		popMatrix();
//Power:

              pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 44);
		if(powered > 0) {fill(255,255,0); }

if (powered > 0 && powered < 300){
  
  fill(200,100,20);

}
if (powered > 0){		
rect(0,0,214*powered/1000,14);
}
powered = powered - 1; 		
popMatrix();


	// *********************************************************
	// draw game objects
	
	for(Rock r: rocks) r.draw();
	for(Wolf w: wolves) w.draw();
	for(Carrot c: carrots) { if(c.eaten==false) c.draw(); }
for(PowerUp p: powerups) { if(p.eaten==false) p.draw(); }
	bunny.draw();
	/*
	// Draw carrots
	for (Prize b: prizes) b.draw();


	for (int i = 0; i < num_balls; i++) {
		carrots[i].update();
	}

	for (int i = 0; i < num_balls; i++) {
		carrots[i].drawCarrot();
		//if (abs(p.xpos - sh.getX())  < 70 && abs (p.ypos - sh.getY()) <30) {

		if (abs(carrots[i].xpos - sh.locationX)  < 50 && abs (carrots[i].ypos - sh.locationY) <50) {
		//println("BOOM"); 
		//sh = null;
		//lives--;
		sh.shrink();

		if (sh.getScalar()  < .7){
		player_Lives--;
		restart(); 

		} 


		//setup();
		}else{
		sh.drawShip();

		}


	}
*/

} // End of draw()

void keyPressed(){ // This function is called everytime a key is pressed.
	if(key == CODED) {
		switch(keyCode){
			case UP: bunny.SpeedY(-0.01); break;
			case DOWN: bunny.SpeedY(0.01); break;
			case LEFT: bunny.SpeedX(-0.01); break;
			case RIGHT: bunny.SpeedX(0.01); break;
                   //     case SHIFT: bunny.increaseSpeed(); break;    //power up - speed
                    //    case ALT: for (Wolf wolf: wolves) wolf.freeze(); break;

}

}

if (key == TAB){ //testing powers
  for (PowerUp p: powerups){
    if (p.active == true){
      powered = 1000;
      elapsedTime2 = millis()-start;
    // println(start);
   //  print(millis());  
   
      println (elapsedTime2);
      
      p.activate(p.getPower());
  //    if (elapsedTime2 > 30000){
     p.xpos = getRandX();
     p. ypos = getRandY();
   //   }
     return;  
    }
   
  
  
  
}
  
 
}

} // End of keyPressed()


/*
class Ship {
  int speed = 10;
  int locationX;
  int locationY;
  float scalar;
  Ship(int x, int y, float scl) 
  {
    locationX = x;
    locationY = y;
    scalar = scl;
  }
  
  void updateSpeed(){
    
    speed = speed + 60;
  }
  
  float getScalar(){
    
    
   return scalar; 
    
  }
  
  void shrink(){
   scalar = scalar - .002; 
    
    
  }
  void drawShip() 
  {
    pushMatrix();
    strokeWeight(2);
    stroke(0);
    scale(scalar,scalar);
    translate(locationX,locationY);
    fill(192,192,192);
    ellipse(-50,-50,25,25);
    fill(0,255,0);
    ellipse(-50,-40,75,20);  
    fill(0,0,0);
    ellipse(-50,-33,35,10);
    strokeWeight(2);
    stroke(255,0,0);
    popMatrix();
  }
  
  
  int getX(){
    
    return locationX;
  }
  
  int getY(){
    
    return locationY;
    
  }
  void moveUP()
  {
    locationY = locationY-speed;
  }
  void moveDOWN()
  {
    locationY = locationY + speed;
  }    
  void moveLEFT()
  {
    locationX = locationX- speed;
  }    
  void moveRIGHT()
  {
    locationX = locationX + speed;
  }    
} // End class Ship



class Carrot {
  float xpos, ypos;
  int rad = 50;  
  float scalar;

float xspeed = 1.8;  // Speed of the shape
float yspeed = 1.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom



  Carrot(float x, float y, float scl) 
  {
    xpos = x;
    ypos = y;
    scalar = scl;
  }
  
  
  void drawCarrot() 
  {
    pushMatrix();
    strokeWeight(2);
    stroke(0);
    scale(scalar,scalar);
    translate(xpos, ypos);
    fill(0);
    ellipse(0,0,rad,rad);
    popMatrix();
  }
 
 
 
 void update(){
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );
  
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos > width-rad || xpos < rad) {
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }  

   
 }
} 
 

class Prize{
  float xpos, ypos, scalar;


  Prize(float x, float y, float scl) 
  {
    xpos = x;
    ypos = y;
    scalar = scl;
  }
  
  
  void draw() 
  {
    pushMatrix();
    strokeWeight(2);
    stroke(0);
    scale(scalar,scalar);
    translate(xpos, ypos);
    fill(20,100,200);
rect(0,0,20,20);
    
    //ellipse(0,0,rad,rad);
    popMatrix();
  }
 
 

} 

*/
// there are 3 types of rocks:
// 1) Solid square
// 2) Jumpable rock with powerup
// 3) Jumpable rock with powerup

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
           xSpeed += .02;
            ySpeed += .02; 
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
		speed = 0.05;
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
 speed = .03; 
  
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
			rot = random(0,TWO_PI); speed = 0.05;
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
			rot = random(0,TWO_PI); speed = 0.10;
		}
		if( ypos<playArea[2]||ypos	>playArea[3]){
			ypos = oldY; ySpeed=0;
			// escape faster
			rot = random(0,TWO_PI); speed = 0.10;
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
boolean active;
	
	boolean eaten; // if eaten, becomes invisible and no longer eatable, I just didn't want to mess with object deletion :)
	PowerUp(float x, float y, int p) { 
		xpos = x; ypos = y;
		eaten = false;
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
  
beInvincible = true; 

  } else if (power ==3){ //increase speed
  bunny.increaseSpeed(); 
  
    
  }
  
  
}

}



 
  
  
  
