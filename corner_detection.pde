  
import processing.video.*;

Capture cam;
PGraphics grayScale;

int blocksize = 5;
int speed = 3;
int w;
int h;
float[][] Iy = new float[blocksize][blocksize];
float k = 0.04;

void setup() {
  size(1280,720);
  smooth(2);
  w = this.width;
  h = this.height;
  grayScale = createGraphics(1280,720);
  colorMode(HSB);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]); 
  cam.start(); 
}

void draw() {
  ArrayList<PVector> posibles = new ArrayList();
  grayScale.beginDraw();
  //grayScale.scale(0.8);
  grayScale.image(cam,0,0);
  
  grayScale.filter(GRAY); 
  grayScale.filter(BLUR,3);
  grayScale.loadPixels();
  
  for(int i=0;i<width-blocksize-speed;i+=blocksize){
    for(int j=0; j<height-blocksize-speed;j+=speed){
        if(HarrisCornerX(grayScale,i,j)){
          posibles.add(new PVector(i,j));
        }
    }
  }
    
  for(PVector posible:posibles){
    if(HarrisCornerY(grayScale,int(posible.x),int(posible.y))){
      grayScale.fill(255,0,0);grayScale.stroke(255,0,0);
      grayScale.ellipse(posible.x,posible.y,3,3);
    }
  }
    
  
  /* x difference and y difference (slower)
  
  for(int x=0; x<width-blocksize-speed; x+=speed){
   for(int y=0; y<height-blocksize-speed; y+=speed){  
     if(HarrisCorner(grayScale,x,y)) { 
       grayScale.fill(255,0,0);grayScale.stroke(255,0,0);
       grayScale.ellipse(x,y,3,3);
     }
   }
  } 
  */
  
  grayScale.endDraw();  
  image(grayScale, 0, 0);
  
}

void colores(PGraphics grayScale){
  color actual = grayScale.get(300,300);
  print("\n",red(actual), green(actual), blue(actual)); 
}

void captureEvent(Capture c){
  c.read();
}

void mouseClicked(){
  color selected = grayScale.get(mouseX, mouseY);
}


public Boolean HarrisCorner(PGraphics grayScale,int iniX,int iniY){
  int[][] Ix = new int[blocksize][blocksize];
  int[][] Iy = new int[blocksize][blocksize];
  float Ex = 0;
  float Ey = 0;
  float Ex2 = 0;
  float Ey2 = 0;
  float Exy = 0;
  float[][] M = new float[2][2];
  float detM;
  float traceM;
  float R;
   
  //int coord = y*cam.width + x;
    
  for(int i=0; i<blocksize;i++){
    for(int j=0; j<blocksize;j++){
      // x variation squater
      Ix[i][j] = (int) red(grayScale.get(iniX+speed+i, iniY+j));
      Ex = ( red(grayScale.get(iniX+i,iniY+j)) - red(grayScale.get(iniX+speed+i,iniY +j))  );       
      // y variation squater
      Iy[i][j] = (int) red(grayScale.get(iniX+i, iniY+speed+j));
      Ey = (red(grayScale.get(iniX+i,iniY+j)) - red(grayScale.get(iniX+i,iniY+speed+j)) );
      
      Exy += (Ex *Ey);
      Ex2 += pow(Ex,2);
      Ey2 += pow(Ey,2);
    } 
  }
  
  M[0][0] = Ex2;
  M[1][0] = Exy;
  M[0][1] = Exy;
  M[1][1] = Ey2;  

  
  detM = (M[0][0] * M[1][1]) - (M[1][0] * M[0][1]);
  traceM = M[0][0] + M[1][1];
  //minLambda = detM/traceM;
  
  R = detM - k* pow(traceM,2);
  
  if(R>1000000){
    return true;
  }else{
    return false;  
  }
}


public Boolean HarrisCornerX(PGraphics grayScale,int iniX,int iniY){
  float Ey = 0;
  float R = 0;
  for(int x=0; x<blocksize; x++){
    for(int y=0; y<blocksize; y++){
      Ey += ( red(grayScale.get(iniX+x, iniY+y)) - red(grayScale.get(iniX+x,iniY+speed+y)) );      
    }
  }  
  
  R = - k * pow(Ey,4);
  //print("\n",R);
  
  if(R<-100000){
    return true;  
  }else{
    return false;
  }

}

public Boolean HarrisCornerY(PGraphics grayScale,int iniX,int iniY){
  int[][] Ix = new int[blocksize][blocksize];
  int[][] Iy = new int[blocksize][blocksize];
  float Ex = 0;
  float Ey = 0;
  float Ex2 = 0;
  float Ey2 = 0;
  float Exy = 0;
  float[][] M = new float[2][2];
  float detM;
  float traceM;
  float R;
   

  //int coord = y*cam.width + x;
    
  for(int i=0; i<blocksize;i++){
    for(int j=0; j<blocksize;j++){
      // x variation squater
      Ix[i][j] = (int) red(grayScale.get(iniX+speed+i, iniY+j));
      Ex = ( red(grayScale.get(iniX+i,iniY+j)) - red(grayScale.get(iniX+speed+i,iniY +j))  );       
      // y variation squater
      Iy[i][j] = (int) red(grayScale.get(iniX+i, iniY+speed+j));
      Ey = (red(grayScale.get(iniX+i,iniY+j)) - red(grayScale.get(iniX+i,iniY+speed+j)) );
      
      Exy += (Ex *Ey);
      Ex2 += pow(Ex,2);
      Ey2 += pow(Ey,2);
    } 
  }
  
  M[0][0] = Ex2;
  M[1][0] = Exy;
  M[0][1] = Exy;
  M[1][1] = Ey2;  
  
  detM = (M[0][0] * M[1][1]) - (M[1][0] * M[0][1]);
  traceM = M[0][0] + M[1][1];
  //minLambda = detM/traceM;
  
  R = detM - k* pow(traceM,2);
  
  if(R>1000000){
    return true;
  }else{
    return false;  
  }
}


//Taylor Series -- variaciones
// f(x+u,y+v) = f(x,y) + fx(x,y)*u + fy(x,y)*v 

//Eigen Value
// m(dxd)   mv = xv   si es simetrica (Mtranspuesta = M)
// M = (v1,v2,vd)[x1]

//R = detM - k* pow(traceM,2);