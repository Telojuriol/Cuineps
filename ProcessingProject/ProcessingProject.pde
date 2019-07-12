import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;


Capture video;
OpenCV opencv;

int wi = 640;
int he = 480;
int numFinal = 15;
int difSel = 0;
float dif = 2.2;
float difMax = 2.2;

PImage src,aux,borde,menu,continuar;

int torn = -2;
int imatge = 0;
boolean BB = false;

int temps = 0;
int temps2;
int acabat = 0;

ArrayList<Contour> contours;

Rectangle[] BBClick;
Rectangle[] BBoto;
Rectangle[] BBMans;
Rectangle BBmig;
Serial myPort;

int numSec = 0;
int cont = 0;
int nivell = 1;

boolean tornFet = false;

int[] aColors;
int preNum,postNum;
int[] secuencia;


void setup() {
  
  
  aColors = new int[10];
  secuencia = new int[numFinal];
  size(wi + 80, he);
  video = new Capture(this, wi, he);
  opencv = new OpenCV(this, wi, he);
  contours = new ArrayList<Contour>();
  video.start();
  String portName = "COM4";
  myPort = new Serial(this,portName,115200);
  continuar = loadImage("continue.png");
  borde = loadImage("marge.png");
  menu = loadImage("menu.jpg");
  for(int i = 0; i < secuencia.length;i++){
   secuencia[i] = int(random(4));
   
  }
 
  //*******************************************
  BBMans= new Rectangle[60];
  
  BBoto= new Rectangle[4];
  BBoto[0] = new Rectangle(50, 224, 50, 75);
  BBoto[1] = new Rectangle(177, 50, 75, 50);
  BBoto[2] = new Rectangle(390, 50, 75, 50);
  BBoto[3] = new Rectangle(540, 224, 50, 75);
  
  BBmig = new Rectangle(wi/2-50,he/2-50,100,100);
  
  BBClick= new Rectangle[7];
  BBClick[0] = new Rectangle(wi,0,wi+80,50);
  BBClick[1] = new Rectangle(wi,50,wi+80,100);
  BBClick[2] = new Rectangle(wi,100,wi+80,100+(he-100)/2);
  BBClick[3] = new Rectangle(wi,100+(he-100)/2 -30,wi+80,he);
  BBClick[4] = new Rectangle(wi,he-30,80,30);
  BBClick[5] = new Rectangle(170+40,160,300,60);
  BBClick[6] = new Rectangle(170+40,270,300,60);
  //*******************************************
  preNum = -1;
  pintaMenu();
  /*for(int i = 0;i < 4;i++)
  rect(BBClick[i].x,BBClick[i].y,BBClick[i].width,BBClick[i].height);*/
}

void dibuixaBotons(){
  
  pushMatrix();
  strokeWeight(3);

  for(int i = 0; i < BBoto.length;i++){
    
    switch(i){
      
      case 0:
        fill(0, 0, 255, 150);
        stroke(0, 0, 255);
        break;

      case 1:
        fill(255, 0, 0, 150);
        stroke(255, 0, 0);
        break;

      case 2:
        fill(255, 255, 0, 150);
        stroke(255, 255,0);
        break;

      case 3:
        fill(0, 255, 0, 150);
        stroke(0, 255, 0);
        break;

    }

    ellipse(BBoto[i].x+BBoto[i].width/2, BBoto[i].y+BBoto[i].height/2, BBoto[i].width, BBoto[i].height);      
  }

  popMatrix();
}

void botoIluminat(int i){
  
  pushMatrix();
  scale(-1,1);
  translate(-wi,0);
  strokeWeight(3);
  myPort.write(i + 2);
    switch(i){
      
      case 0:
        fill(0, 0, 255, 200);
        stroke(0, 0, 255);
        break;

      case 1:
        fill(255, 0, 0, 200);
        stroke(255, 0, 0);
        break;

      case 2:
        fill(255, 255, 0, 200);
        stroke(255, 255,0);
        break;

      case 3:
        fill(0, 255, 0, 200);
        stroke(0, 255, 0);
        break;

    }

    ellipse(BBoto[i].x+BBoto[i].width/2, BBoto[i].y+BBoto[i].height/2, BBoto[i].width + 10, BBoto[i].height+10);
    
    popMatrix();  
}

  




void captureEvent(Capture c) {

  c.read();
}

void keyPressed(){
  if(key == 'b' || key == 'B'){
    BB = !BB;
  }else{
    if(imatge == 0)
      imatge = 1; 
    else
      imatge = 0;
  }
}



boolean detectBlue(int i){
 
  if(blue(src.pixels[i])/red(src.pixels[i]) > difMax &&blue(src.pixels[i])>green(src.pixels[i]))
    return true;
  if(blue(src.pixels[i])/red(src.pixels[i])>dif && red(src.pixels[i]) < 230 &&blue(src.pixels[i])>green(src.pixels[i]))
    return true;
  else
    return false;
}


void mousePressed() {
  int clicked = 0;
  for(int b = 0; b < 7; b++){
       if(mouseX > BBClick[b].x && mouseX < BBClick[b].x + BBClick[b].width && mouseY > BBClick[b].y && mouseY < BBClick[b].y + BBClick[b].height){
           clicked = b;
        }
   }
  if(clicked == 0 && torn == -1)
    difSel = 1;
  if(clicked == 1 && torn == -1)
    difSel = 2;
  if(clicked == 2 && difSel == 1 && torn == -1)
    dif+=0.1;
  if(clicked == 3 && difSel == 1 && torn == -1)
    dif-=0.1;
  if(clicked == 2 && difSel == 2 && torn == -1)
    difMax+=0.1;
  if(clicked == 3 && difSel == 2 && torn == -1)
    difMax-=0.1;
  if(clicked == 4 && torn == -1){
    torn = 1;
    imatge = 1;
    temps2 = temps;
  }
  if(clicked == 5 && torn == -2){
    torn = 1;
    temps2 = temps; 
    imatge = 1;
  }
    
  if(clicked == 6 && torn == -2){
    imatge = 0;
    torn = -1;
    pushMatrix();
      fill(255,255,255);
      stroke(100,100,100);
      for(int i = 0;i < 5;i++)
        rect(BBClick[i].x,BBClick[i].y,BBClick[i].width,BBClick[i].height);
        fill(0,0,0);
      text("dif",wi + 30,30);
      text("difMax",wi + 20,80);
      text("+",wi + 35,180);
      text("-",wi + 38,360);
      text("Jugar",wi + 26,he-10);
    popMatrix();
 
  }
}

void prova(){
  loadPixels();
  // println(blue(src.pixels[30])/red(src.pixels[30]));
  color b = color(0,0,0);
  color w = color(255,255,255);
  int p = 0;
  for(int i = 0; i < src.pixels.length;i++){

    if(detectBlue(i)){
    // println("Red: "+red(pixels[i])+" Green: "+green(pixels[i])+" Blue: "+blue(pixels[i]));
      src.pixels[i] = w;
      p++;
    }else{
      src.pixels[i] = b; 
    } 
  }

  updatePixels();
}


void BBprova(){
  opencv.loadImage(src);
  opencv.useColor(HSB);
  opencv.setGray(opencv.getB().clone());
  contours = opencv.findContours(true,true);

  for (int i=0; i<contours.size(); i++) {

    Contour contour = contours.get(i);
    Rectangle r = contour.getBoundingBox();

    if (r.width < 20 || r.height < 20)
      continue;

    stroke(255, 0, 0);
    fill(255, 0, 0, 150);
    strokeWeight(2);
    BBMans[i] = r;
    if(BB)
      rect(r.x, r.y, r.width, r.height);
  }
  src = opencv.getOutput();
}


int detectaColisions(){
 
  int i = -1;
  if(BBMans[0] != null && BBMans[1] != null){
    for(int a = 0; a < 2; a++){
      for(int b = 0; b < 4; b++){
       if((BBMans[a].x < BBoto[b].x+ BBoto[b].width) && (BBMans[a].x + BBMans[a].width > BBoto[b].x) &&(BBMans[a].y < BBoto[b].y+ BBoto[b].height) && (BBMans[a].y + BBMans[a].height > BBoto[b].y))
        i = b+1;    
      }  
     }
  }else{
    i = -1; 
  }

return i;

}

void pintaCam(){
  
  opencv.loadImage(video);
  opencv.useColor(RGB);
  src = opencv.getSnapshot();
  aux = opencv.getSnapshot();
  prova();
 
  pushMatrix();
 
    scale(-1,1);
    translate(-wi,0);
    if(imatge == 0)
      image(src, 0, 0 );
    if(imatge == 1)
      image(aux,0, 0 );
    BBprova(); 
    if(torn != -1)
      dibuixaBotons();
    else{
      scale(-1,1);
      translate(-wi,0);
      fill(255,255,255);
      text("dif: " + dif + "\ndifMax: "+difMax,wi-100,50);  
    }
  popMatrix();
  

}

void enviaInfo(){
  if(preNum == -1 && postNum != -1){
    if(secuencia[cont] == postNum - 1) {
      cont++;
      println("boooona");
    }else{
      temps2 = temps;
      acabat = 1;
      println("fallooo");
    }
  }
  
  if(cont == numSec){
    cont = 0;
    temps2 = temps;
    nivell++;
    tornFet = true;
    if(nivell == numFinal + 1){
     acabat = 1; 
    }
  }
}


void escriuText(String text){
  pushMatrix();
    textSize(12);
    fill(255, 255, 255);
    scale(9,9);
    text(text,32,30);
  
  popMatrix();
  
}

boolean iniciaRonda(){
  pushMatrix();   
      
    stroke(170, 170, 170);
    fill(255,255,255);
    ellipse(BBmig.x+BBmig.width/2, BBmig.y+BBmig.height/2, BBmig.width, BBmig.height); 
    image(continuar,0,0);

 popMatrix();
 if(BBMans[0] != null && BBMans[1] != null){
   for(int a = 0; a < 2; a++){
     if((BBMans[a].x < BBmig.x+ BBmig.width) && (BBMans[a].x + BBMans[a].width > BBmig.x) &&(BBMans[a].y <BBmig.y+ BBmig.height) && (BBMans[a].y + BBMans[a].height > BBmig.y))
       return true;
   }
 }
  return false;
  
}

void pintaSecuencia(){

      
   if((temps - temps2)/1000 == 0) escriuText("3");
      //3
   if((temps - temps2)/1000 == 1) escriuText("2");
      //2
   if((temps - temps2)/1000 == 2) escriuText("1");
      //1
   if((temps - temps2)/1000 == 3) {
     pushMatrix();
       fill(255, 255, 255);
       textSize(12);
       scale(9,9);
       //textAlign(CENTER,CENTER);
       text("YA!",27,30);
    popMatrix();
  }
      
   if((temps - temps2) / 1000 > 4 && (temps - temps2)/1000 < 6)
      botoIluminat(secuencia[cont]);
   if((temps - temps2) / 1000 == 6) {
       myPort.write(0);
       cont++;
       temps2 = temps - 5000;
       if(cont > numSec){
         torn = 0;
         numSec++;
         cont = 0;
         temps2 = temps;
       }
   }
}
void pintaMenu(){
 image(menu,0,0);
}



void pantallaFinal(){
    pushMatrix();
      background(0);
      textSize(30);
       if(nivell == numFinal + 1){
         fill(0,255,0);
         text("FELICITATS!",270,100);
       }else{
         fill(255,0,0);
         text("GAME OVER!",270,100);
       }
      
      fill(255,255,255);
      text("La teva puntuació ha sigut de:",150,200);
      text(nivell-1,360,300);
    popMatrix();
}

void pintaPuntuacio(){
  pushMatrix();
    stroke(100,100,100);
    fill(255,255,255);
    rect(wi,0,79,he-1);
  
  fill(0,0,0);
  textSize(20);
    text("Nivell:\n",wi+15,30);
    text(nivell,wi+33,55);
  popMatrix();  
}

void draw() {
  
  temps = millis();
  if(torn > -2)
    pintaCam();
    
  if(torn == 2 && (temps - temps2)/1000 > 1 && tornFet && acabat == 0){
    myPort.write(0);
    torn = 1;
    temps2 = temps;
    tornFet = false;
  }
  
  if(torn > -1 && acabat == 0)
    pintaPuntuacio();
  if(tornFet && torn == 2 && acabat == 0){
    
    pushMatrix();
        textSize(40);
        fill(0,205,0);
        text("BEN FET!",250,300);
      popMatrix();
  }  
  if(torn == 1 && acabat == 0)
    pintaSecuencia();
   
  if((temps - temps2)/100 > 5 && torn == 0 && iniciaRonda() && !tornFet && acabat == 0)
    torn = 2;
    
  if(torn == 2 && acabat == 0)
    postNum = detectaColisions();
  
  if( torn == 2 && cont < numSec && acabat == 0 && !tornFet)
    enviaInfo();  
 
  if(postNum != -1 && torn == 2 && acabat == 0)
    botoIluminat(postNum - 1);
  if(postNum == -1 && torn == 2)
    myPort.write(0);
 
    
    
  if(acabat == 1){
    println("patata");
    if(nivell == numFinal + 1){
      image(borde,0,0);
      pushMatrix();
        textSize(40);
        fill(0,255,0);
        text("Has guanyat!",175,300);
      popMatrix();
    }else{
      image(borde,0,0);
      pushMatrix();
        textSize(40);
        fill(255,0,0);
        text("Error! Has perdut",175,300);
      popMatrix();
    }
    if((temps - temps2)/1000 > 3)
      pantallaFinal();
    
  }
  preNum = postNum;
  if(torn > -1 && acabat == 0)
    image(borde,0,0);

}
