// Mandelbrot fractal viewer with zoom
// Dan Anderson
// blog.recursiveprocess.com
// All this code was written by Dan Anderson, but feel free to use in any way that you'd like.
// https://www.openprocessing.org/sketch/296658
// fork by Rupert Russell
// Artwork on redbubble at: https://www.redbubble.com/shop/ap/33953943
// Code on Github at: https://github.com/rupertrussell/MonochromeMandelbrot


//fx and fy keep track of the fx + fy*i vector between functions. It was easier to 
//write the code with these as global variables instead of returning a two num array
float fx = 0;
float fy = 0;

//count keeps track of how many iterations a number goes through in the sequence
int count = 0;

//resolution is the maximum size of count. A higher resolution will render the fractal
//with more detail. Try a resolution of 2,3, and then 18 to see how this works
int resolution = 64;

//These variables keep track of the width and height of the virtual windows
float minwindowx = -2;
float maxwindowx = 2;
float minwindowy = -2;
float maxwindowy = 2;

float centerx = 0;
float centery = 0;

//Change this variable to change the type of mandelbrot fractal. Try 2 to calculuate
//z(n+1)=z(n)^2+c. Try 3 to calculate z(n+1)=z(n)^3+c. Try a decimal number :-).
float power = 2;

void setup() 
{ 
  // size(914, 914); //  size(9144, 9144);
  size(914, 914);
  background(0);
  noLoop();
  drawfractal();
}

void draw() 
{
  background(0);
  drawfractal();
}

void drawfractal()
{
  loadPixels();
  color c;
  float windowwidth = maxwindowx - minwindowx;
  float windowheight = maxwindowy - minwindowy;
  for (int i = 0; i < pixels.length; i++)
  {
    //this code maps the one dimensional pixel array to a cx and cy in the complex plane
    float startcx = windowwidth * (float(i % width) / width) - (windowwidth/2) + centerx; 
    float startcy = windowheight * (float(floor(float(i)/width))/height) - (windowheight/2) + centery;

    //the mandelvalue is either greater than 2 and then the count matters to find out
    //how far the complex number went before it got out of the range
    //if the mandelvalue is < 2, then the pixel is black
    float mandelvalue = mandel(startcx, startcy);

    mandelvalue = int((mandelvalue * 10) % 10);
    if (mandelvalue % 2 == 0) {
      c = color(0);
    } else {
      c = color(mandelvalue * 250);
     //  println(mandelvalue);
    }


    pixels[i] = c;
  }
  updatePixels();
  save("mandelbrot_" + resolution + ".png");
  // exit(); Use for large artworks for Redbubble
}

float mandel(float startcx, float startcy)
{
  float xm = 0;
  float ym = 0;
  count = 0;
  fx = 0;
  fy = 0;
  while ( (count < resolution) && (fx*fx+fy*fy < 4))
  {
    func(xm, ym, startcx, startcy);
    xm = fx;
    ym = fy;
    count++;
  }
  return sqrt(fx*fx + fy*fy);
}

//this function is for x_n+1 = x_n^2 + c, where x_n and c are complex numbers
//exercise left to the reader to see why (a+bi)^2 = (a^2-b^2)+(2ab)i
void func(float x, float y, float startcx, float startcy)
{
  //These are the special cases (just (a+bi)^2 and (a+bi)^3
  if (power < 2.01 && power > 1.99)
  {
    fx = x*x - y*y + startcx;
    fy = 2*x*y + startcy;
  } else if (power < 3.01 && power > 2.99)
  {
    fx = x*x*x-3*x*y*y + startcx;
    fy = 3*x*x*y-y*y*y + startcy;
  } else 
  {
    //Polar raising to a power using DeMoivre's Theorem.
    //Polar is slower (but cleaner and more general code).

    float r = sqrt(x*x + y*y);
    float theta = 0;
    r = pow(r, power);
    if (x > 0)
    {
      theta = atan(y/x);
    } else if (x<0)
    {
      theta = atan(y/x);
      theta = theta + PI;
    } else
    {
      theta = 0;
    }

    theta = power * theta;
    fx = r*cos(theta) + startcx;
    fy = r*sin(theta) + startcy;
  }
}
