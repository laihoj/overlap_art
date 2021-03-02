ArrayList<Shape> shapes = new ArrayList<Shape>();// =  { 

boolean debug = false;

enum Direction {
  LEFT,
  RIGHT,
  UP,
  DOWN,
  RANDOM,
  MIDDLE
}


void setup() {
  //fullScreen();
  size(700, 700);

  String url2 = "https://ak.picdn.net/shutterstock/videos/1023357436/thumb/1.jpg";

  String url = "https://cdn.shopify.com/s/files/1/1048/4232/products/Ennerdale-70-Diamond-Black-White_1024x1024.png?v=1528113928";

/*
  shapes.add(new Ball(0, 0, 80)
    .align(Direction.MIDDLE)
    .align(Direction.RIGHT)
    .direct(Direction.LEFT)
    .shake().shake().shake()
    );
    */
  //shapes.add(new Ball(200, 400, 80));
  //shapes.add(new Ball(700, 400, 80));
  
  /*
  shapes.add(new Ball(700, 400, 80)
    .align(Direction.MIDDLE)
    .align(Direction.LEFT) //start left
    .direct(Direction.RIGHT)
    ); //go right
    */
    shapes.add(new ShapePattern(new Ball(0, 0, 30), 10, 10).direct(Direction.RIGHT).shake());
    shapes.add(new ShapePattern(new Ball(0, 0, 13), 11, 9).direct(Direction.UP).shake());
  //shapes.add(new Image(100, 400, 300, loadImage(url, "png")));
  //shapes.add(new Image(300, 300, 300, loadImage(url2, "png")));
  
//  shapes.add(new CheckerPattern(47, 10, 10)
//    .direct(Direction.LEFT));
//  shapes.add(new CheckerPattern(51, 10, 10)
//    .direct(Direction.RIGHT)
//    .shake(3));
//  shapes.add(new DotPattern(5, 50, 50)
//    .direct(Direction.UP)
    //.shake(0)
//    );
//  shapes.add(new DotPattern(5, 50, 50)
//    .direct(Direction.LEFT)
//    .shake(5)
//    );
  
}


  int cols = width;
  int rows = height;
  int[][] myArray = new int[cols][rows];
  color c;
  int i;
  int ii;
  
  
void draw() {
  background(0xFF333333);
  tint(205,  50);  // Apply transparency without changing color
  //image(webImg, 50, 0);

  //image(webImg2, 50, 0);

  for (Shape b : shapes) {
    b.update();
    b.display();
    b.checkBoundaryCollision();
  }
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      myArray[i][j] = 0;
    }
  }

  if(!debug) {
    loadPixels();
  
    for (i = 0; i < height; i++) {
      for (ii = 0; ii < width; ii++) {
  
        c = get(ii, i);
        int pixelIndex = ii + i * width;
        if(c > 0xFF515151) //if enough shapes overlap, then pixel color will be brighter
          pixels[pixelIndex] = color(255);
        else
          pixels[pixelIndex] = color(0);
      }
    }
    updatePixels();
  }
  
  //saveFrame();

}



interface Display {
  void display();
}


abstract class Shape implements Display {
  PVector position;
  PVector velocity;
  float init_speed = 0.5;
  float radius;
  Shape(float x, float y, float r) {
    setPosition(new PVector((x + r)%width, (y + r)%height));
    setDirection(PVector.random2D());
//    velocity = PVector.random2D();
  //  velocity.mult(init_speed);
    radius = r;
  }
  
  Shape direct(Direction d) {
    switch(d) {
      case LEFT:
        setDirection(new PVector(-1,0));
        break;
      case RIGHT:
        setDirection(new PVector(1,0));
        break;
      case UP:
        setDirection(new PVector(0,-1)); //notice y grows down
        break;
      case DOWN:
        setDirection(new PVector(0,1));
        break;
      case RANDOM:
        setDirection(PVector.random2D());
        break;
      case MIDDLE: //not implemented
        break;
    }
    return this;
  }
  
  void setDirection(PVector p) {
    this.velocity = p;
    this.velocity.mult(this.init_speed);
  }
  
  Shape align(Direction d) {
    switch(d) {
      case MIDDLE:
        setPosition(this.position.x, height / 2); //works only if xyzMode(CENTER)
        break;
      case LEFT:
        setPosition(0, this.position.y); //set x to 0, dont touch y
        break;
      case RIGHT:
        setPosition(width, this.position.y); //set x to max, dont touch y
        break;

      case UP: //not implemented
      case DOWN://
      case RANDOM:
        break;
    }
    return this;
  }
  
  //introduce small irregularities in position and velocity
  Shape shake() {
    float random_x = random(-5, 5);
    float random_y = random(-5, 5);
    float random_rotation = random(radians(-5), radians(5));
    setPosition(this.position.x + random_x, this.position.y + random_y);
    this.velocity.rotate(random_rotation);
    return this;
  }
  
  Shape shake(int i) {
    shake();
    if(i == 0) return this;
    return shake(i-1);
  }
  
  void setPosition(float x, float y) {
    this.position.x = x;
    this.position.y = y;
  }
  
  void setPosition(PVector p) {
    this.position = p;
  }
  
  void update() {
    position.add(velocity);
  }
  
  void checkBoundaryCollision() {

    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }
}


class Ball extends Shape  {

  float radius, m;

  Ball(float x, float y, float r_) {
    super(x,y, r_);

    radius = r_;
    m = radius*.1;
  }

  void display() {
    noStroke();
    fill(205,  50);
    ellipseMode(CENTER);  // Set rectMode to RADIUS
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}


class Square extends Shape {

  float radius;

  Square(float x, float y, float radius) {
    super(x,y, radius);

  this.radius = radius;
  
  }

  void display() {
    noStroke();
    fill(205,  50);
    rectMode(CENTER);  // Set rectMode to RADIUS
    rect(position.x, position.y, radius, radius, 7);  // Draw white rect using RADIUS mode
  }
}

class Image extends Shape {
  PImage img;
  Image(float x, float y, float r, PImage image) {
    super(x, y, r);
    img = image;
    img.resize((int)r,(int)r);
  }
  void display() {
    tint(205,  50);  // Apply transparency without changing color
    //translate(position.x - radius/2, position.y - radius/2);
    pushMatrix();
    //translate(-width/2, -height/2);
    image(img, position.x, position.y);
    popMatrix();
  }
}

abstract class Pattern extends Shape {
  int cols, rows;
  Pattern(float r, int cs, int rs) {
    super(0,0,r);
    this.cols = cs;
    this.rows = rs;
  }
   //override
  //wraps around
  void checkBoundaryCollision() {
    position.x %= width/this.cols;
    position.y %= height/this.rows;
    if(position.x < 0) position.x = width/this.cols;
    if(position.y < 0) position.y = height/this.rows;
  }
}

class ShapePattern extends Pattern {
  Shape s; //shape is repeated in pattern
  ShapePattern(Shape s, int cs, int rs) {
    super(s.radius, cs, rs);
    this.s = s;
  }
  void display() {
    pushMatrix();
    translate(position.x, position.y);
   //index starting at -2 with overlapping shapes makes nicer wrap
    for (int i = -2; i < this.rows + 2; i++) {
      for (int ii = -2; ii < this.cols + 2; ii++) {
        pushMatrix();
        translate(ii*width/this.cols, i*height/this.rows);
        
        s.display();
        popMatrix();
      }
    }
    popMatrix();
  }
}

class CheckerPattern extends Pattern {
  
  CheckerPattern(float r, int cs, int rs) {
    super(r, cs, rs);
  }
  void display() {
    noStroke();
    fill(205,  50);
    translate(position.x, position.y);
   //index starting at -2 with overlapping shapes makes nicer wrap
    for (int i = -2; i < this.rows + 2; i++) {
      for (int ii = -2; ii < this.cols + 2; ii++) {
        rectMode(CORNER);
        rect(ii*width/this.cols, i*height/this.rows, this.radius, this.radius, 2);
      }
    }
  }
}

class DotPattern extends Pattern {
  
  DotPattern(float r, int cs, int rs) {
    super(r, cs, rs);
  }
  void display() {
    noStroke();
    fill(205,  50);
    translate(position.x, position.y);
   //index starting at -2 with overlapping shapes makes nicer wrap
    for (int i = -2; i < this.rows + 2; i++) {
      for (int ii = -2; ii < this.cols + 2; ii++) {
        ellipseMode(CORNER);
        ellipse(ii*width/this.cols, i*height/this.rows, this.radius, this.radius);
      }
    }
  }
}
