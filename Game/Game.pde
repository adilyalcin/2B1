import processing.serial.*;

Serial player1; 
Serial player2;

int window_Height = 800;
int window_Width = 700;
float remPowerTime = 0; 
float pTime;
float currTime = 0;
int lastElapsedTime, lastElapsedTime2;
boolean locked = false;

boolean controlType = false;

PowerUp currPower;
boolean beInvincible = false;
boolean reset = true;
boolean powerUpActive = false;
int[] playArea = {50,750,160,650};
long elapsedTime2; 
// Do something ...

boolean player1Select = false;
boolean player2Select = false;

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

PFont font;

float getRandX(){ return random(playArea[0],playArea[1]); }
float getRandY(){ return random(playArea[2],playArea[3]); }

int getSelectedPowerUp(){
	if(player1Select==false&&player2Select==false) return 0;
	if(player1Select==false&&player2Select==true) return 1;
	if(player1Select==true&&player2Select==false) return 2;
	if(player1Select==true&&player2Select==true) return 3;
	return 0;
}

void keyPressed(){
	if(key == BACKSPACE){ //resets level 
		resetLevel(1); 
		reset = true;
		return;
	}
	
	switch(key) {
		case CODED:
			if(!locked){
				switch(keyCode){
					case UP: bunny.SpeedY(-0.01); break;
					case DOWN: bunny.SpeedY(0.01); break;
					case LEFT: bunny.SpeedX(-0.01); break;
					case RIGHT: bunny.SpeedX(0.01); break;
				}
			}
			break;
		case 't':
			locked = true; break;
		case 'y':
			locked = false; break;
	}
	
	if(!locked){
		if(key=='f') {
			player1Select = !player1Select;
		} 
		if(key=='h') {
			player2Select = !player2Select;
		}
	} else {
		if(key=='l'){
			int powerNo = getSelectedPowerUp();
			if(powerups.get(powerNo).ready){
				currPower = powerups.get(powerNo);
				currPower.activate();
			}
			locked = false;
		}
	}
} // End of keyPressed()

void serialEvent (Serial myPort) {
	boolean playerNo = (myPort==player1);
	String inString = myPort.readStringUntil('\n');

	float in = float(inString);
	
	if (inString == null) return;

	switch(int(in)){
		case 1:
			if(playerNo==false){ // player 1, event 1
				if(!controlType) bunny.SpeedY(-0.01); 
//				else             bunny.rotate(-0.01);
			} else {             // player 2, event 1
				if(!controlType) bunny.SpeedX(0.01); 
//				else             bunny.accel(0.01);   
			}
			break;
		case 2:
			if(playerNo==false){ // player 1, event 2
				if(!controlType) bunny.SpeedY(0.01); 
//				else             bunny.rotate(0.01);
			} else {             // player 2, event 2
				if(!controlType) bunny.SpeedX(-0.01); 
//				else             bunny.accel(-0.01);
			}
			break;
		case 3: // release (not used)
			if(!locked) {
				if(playerNo==false) player1Select = !player1Select;
				else                player2Select = !player2Select;
			} else {
				int powerNo = getSelectedPowerUp();
				println("activate powerup"+powerNo);
				if(powerups.get(powerNo).ready){
					currPower = powerups.get(powerNo);
					currPower.activate();
				}
				locked = false;
			}
			break;
		case 4: // press
			break;
		case 5:
			locked = true; // now you can choose a powerup  
			break;
		case 6:
			locked = false;
			break;
	}

	if (locked && !powerUpActive){
		if (playerNo==true && in==3 ){ //testing powers
			for (PowerUp p: powerups){
				if (p.ready == true && p.getPower() == 0){ //freeze
				} 
			}
		}
		if (playerNo==false && in==4 ){
			for (PowerUp p: powerups){
				if (p.ready == true && p.getPower() == 1){ //slow
					remPowerTime = 10000;
					powerUpActive = true;
					currPower = p;
					return;  
				} 
			}
		}

		if (playerNo==true && in== 3){
			for (PowerUp p: powerups){
				if (p.ready == true && p.getPower() == 2){ //invisible
					remPowerTime = 10000;
					powerUpActive = true;
					currPower = p;
					return;  
				} 
			}
		}

		if (playerNo==true && in==4){
			for (PowerUp p: powerups){
				if (p.ready == true && p.getPower() == 3){ //increase speed
					remPowerTime = 10000;
					powerUpActive = true;
					currPower = p;
					return;  
				} 
			}
		}
	}
}


void resetLevel(int levelNo){
	// randomly spawn static rocks in the game
	remPowerTime = 0;
	
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
	for(int i=0 ; i<3	; i++){
		wolves.add(new Wolf(getRandX(), getRandY()));
	}
	// randomly spawn powerups
	for(int i=0 ; i<4; i++){
		powerups.get(i).spawn(getRandX(), getRandY());
	}
	// set player starting position
	float playerX = getRandX();
	float playerY = getRandY();
	bunny.resetPos(playerX, playerY);
	
	// TODO: Make sure carrots/ wolves / rocks do not intersect!
	pTime = 1000;

	lastElapsedTime = millis();
	lastElapsedTime2 = millis();
	remLevelTime = 120000; // 120 sec
	currTime = 0;
}

void setup(){
	// List all the available serial ports
	println("Available Serial ports:"+Serial.list());

	player1 = new Serial(this, Serial.list()[0], 9600);
	player2 = new Serial(this, Serial.list()[1], 9600);

	// don't generate a serialEvent() unless you get a newline character:
	player1.bufferUntil('\n');
	player2.bufferUntil('\n'); 

	// setup display
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
	rocks = new ArrayList();
	carrots = new ArrayList();
	bunny = new Bunny();
	wolves = new ArrayList();
	powerups= new ArrayList();
	for(int i=0 ; i<4 ; i++){ powerups.add(new PowerUp(i)); }	

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
	
	// see if bunny gets a powerup
	for(PowerUp p: powerups) {
		// use simple absolute distance
		if(sq(p.xpos-bunny.xpos)+sq(p.ypos-bunny.ypos)<1300){
			p.setReady();
		}
	}

	// see if bunny gets eaten
	if(!beInvincible){
		for(Wolf w: wolves){
			// use simple absolute distance
			if(sq(w.xpos-bunny.xpos)+sq(w.ypos-bunny.ypos)<1300){
				resetLevel(1); 
				reset = true;
				return;
			}
		}
	}

	remLevelTime -= msec;
	remPowerTime -= msec;
	if(remLevelTime<0){
		// game over... TODO
		remLevelTime = 0;
	}

	// deactivate active powerup
	if(powerUpActive && remPowerTime < 1){
		if (currPower.getPower() == 2){
			beInvincible = false; 
		}
		if (currPower.getPower() == 3){
			bunny.speedNorm();
		}
		if(currPower.getPower() == 0){
			for(Wolf w: wolves) w.normalSpeed();
		}
		powerUpActive = false;
		currPower.resetPos();
		locked = false;
		currPower.ready = false;
		remPowerTime = 0;
	}	
}

void draw(){
	int elapsedTime = millis();
	int timeDif = elapsedTime-lastElapsedTime;
	lastElapsedTime = elapsedTime;
	if(!reset) {
		timestep(timeDif);
	}
	background(imgBack);

	// ********************************************************
	// draw header

		// Print remaning carrot count
	textFont(font);
	int remCarrot = 0;
	for(Carrot c: carrots) { if(c.eaten==false) remCarrot++; }
	text(""+remCarrot, 10, 50);
		// draw remaining time rectangle
	pushMatrix();
	strokeWeight(2);
	stroke(0);
	translate(312, 12);
	if(remLevelTime>20000) fill(20,100,200); else fill(200,100,20);
	rect(0,0,214*remLevelTime/120000,14);
	popMatrix();
	
	if(locked){
		textSize(25);
		fill(255,255,255);
		text("LOCKED!", 30, 121	);
	}
	
	// Winning case...
	if (remCarrot==0){
		int posx = width/2 - 150;
		int posy = width/2;
		fill(0);
		text("Congratulations! You Won!", posx, posy);
		resetLevel(1);
		reset = true;
	}
	
	// highlight selected power
	pushMatrix();
	strokeWeight(4);
	stroke(255,0,0);
	switch(getSelectedPowerUp()){
		case 0: translate(550, 9); break;
		case 1: translate(610, 9); break;
		case 2: translate(676, 9); break;
		case 3: translate(735, 9); break;
	}
	fill(255,255,255,0);
	rect(0,0,45,48);
	popMatrix();

	if(powerUpActive && remPowerTime > 0){
		// notify of actively running power up
		fill(255);
		if (currPower.getPower() == 0){
			text("Power Up: Freeze Wolves", 170, 115); 
		} else if (currPower.getPower() == 1){
			text("Power Up: Slow Down Wolves", 170, 115); 
		} else if (currPower.getPower() == 2){
			text("Power Up: You Are Invincible", 170, 115); 
		} else if (currPower.getPower() == 3){
			text("Power Up: Increase Speed", 170, 115); 
		}
		// notify remaining powerup time
		pushMatrix();
		strokeWeight(2);
		stroke(0);
		translate(312, 44);
		fill(255,255,0);
		if(remPowerTime < 2000) fill(200,100,20);
		rect(0,0,214*remPowerTime/10000,14);
		popMatrix();
	}

	for(Rock r: rocks) r.draw();
	for(Carrot c: carrots) { if(c.eaten==false) c.draw(); }
	for(PowerUp p: powerups) { if(p.eaten==false) p.draw(); }
	for(Wolf w: wolves) w.draw();
	bunny.draw();

	if(reset){
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
		}
		currTime = currTime + 2; 
	}
} // End of draw()


class Rock{
	float xpos, ypos, scalar, rot;
	int rType;
	Rock(float x, float y, int t) {
		xpos = x;
		ypos = y;
		scalar = random(1,4)/8.0;
		rType = t;
		rot = random(0,TWO_PI);
	}
	void draw() { 
		pushMatrix();
		translate(xpos,ypos);
		scale(scalar);
		rotate(rot);
		tint(255,170);
		image(imgRock1,0,0);
		popMatrix();
		noTint();
	}
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
	float speedMult;
	
	float rot;
	
	Bunny(){
		xSpeed = ySpeed = 0;
		speedMult = 1;
		rot = 0;
	}
	void draw() {
		pushMatrix();
		translate(xpos,ypos);
		scale(1.0/8);
		rotate(getRotation(xSpeed,ySpeed));
		if (beInvincible){ tint(255,126); }
		image(imgBunny,0,0);
		popMatrix();
		noTint();
	}
	void resetPos(float x, float y){
		xpos=x; ypos=y;
		xSpeed = ySpeed = 0;
	}
	void iter(int msec){
		float oldX = xpos;
		float oldY = ypos;
		xpos+=xSpeed*msec*speedMult;
		ypos+=ySpeed*msec*speedMult;
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
    
	void speedNorm(){
		speedMult = 1.0;
	}
	void speedFast(){
		speedMult = 2.0;
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
		image(imgWolf,0,0);
		popMatrix();	
	}
	void decreaseSpeed(){
		speed = 0.01;
	}
	void freeze(){
		speed = 0;
	}
	void normalSpeed(){
		speed = 0.04;
	}
	void iter(int msec){
		// randomly change direction
		if(random(5000)<=msec && speed>0.03){
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
	boolean ready;
	
	boolean eaten; // if eaten, becomes invisible and no longer eatable, I just didn't want to mess with object deletion :)
	PowerUp(int p) { 
		eaten = false;
		ready = false;
		power = p;
		if (power == 0) { //freeze all wolves
			c= color(100,0,0);
		} else if (power == 1){ //slow speed of wolves
			c = color(0,100,0);
		}else if (power ==2){ //be invisible
			c = color(0,0,100);
		}  else if (power ==3){ //increase speed
			c = color(100, 0 , 100); 
		}
	}
	void spawn(float x, float y){
		xpos = x; ypos = y;
	}
	void resetPos(){
		if(!ready) return;
		xpos = getRandX();
		ypos = getRandY(); 
	}
	int getPower(){
		return power;  
	}
	void setReady(){
		ready = true;
		// move to upper gui position
		if (power == 0) { //freeze all wolves
			xpos = 557;
			ypos = 19; 
		} else if (power == 1){ //slow speed of wolves
			xpos = 618;
			ypos = 19; 
		} else if (power ==2){ //be invisible
			xpos = 681;
			ypos = 19; 
		} else if (power ==3){ //increase speed
			xpos = 741;
			ypos = 19; 
		}
	}
	void draw()  { 
		strokeWeight(0);
		fill(c); 
		rect(xpos, ypos, 30,30);
		fill(255);
		switch(power){	
			case 0: text("A",xpos+5,ypos+24); break;
			case 1: text("B",xpos+5,ypos+24); break;
			case 2: text("C",xpos+5,ypos+24); break;
			case 3: text("D",xpos+5,ypos+24); break;
		}
	}
	void activate(){
		remPowerTime = 10000;
		powerUpActive = true;
		println("power activated. no:"+power);
		if (power == 0) { //freeze all wolves
			for (Wolf wolf: wolves) wolf.freeze(); 
		} else if (power == 1){ //slow speed of wolves
			for (Wolf wolf: wolves) wolf.decreaseSpeed(); 
		} else if (power ==2){ //be invisible
			beInvincible = true; 
		} else if (power ==3){ //increase speed
			bunny.speedFast(); 
		}
	}
}
