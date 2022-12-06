BSL
#include <GL/glut.h>
#include <iostream>
using namespace std;
double slope(int x1, int y1, int x2, int y2)
{
  if (x2 - x1 == 0)
    return 1.1;
  return (double)(y2 - y1) / (double)(x2 - x1);
}
void init()
{
  glClearColor(1.0, 1.0, 1.0, 0.0);
  glColor3f(0.0f, 0.0f, 0.0f);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-320, 320, -240, 240);
};
void bline(int sx, int sy, int ex, int ey)
{
  glBegin(GL_POINTS);
  int dx = abs(ex - sx);
  int dy = abs(ey - sy);
  int slp = slope(sx, sy, ex, ey);

  int incx = sx > ex ? -1 : 1, incy = sy > ey ? -1 : 1;
  if (slp < 1)
  {
    int pk = 2 * dy - dx;
    for (int x = sx, y = sy; x < ex;)
    {
      glVertex2d(x, y);
      if (pk >= 0)
        y += incy, pk = pk + 2 * (dy - dx);
      else
        pk = pk + 2 * dy;
      x += incx;
    }
  }
  else
  {
    int pk = 2 * dx - dy;
    for (int x = sx, y = sy; y < ey;)
    {
      glVertex2d(x, y);
      if (pk >= 0)
        x += incx, pk = pk + 2 * (dx - dy);
      else
        pk = pk + 2 * dx;
      y += incy;
    }
  }
  glEnd();
};
void display()
{
  glClear(GL_COLOR_BUFFER_BIT);
  bline(-320, 0, 320, 0);
  bline(0, -240, 0, 240);
  bline(0, 0, 100, 100);
  bline(0, 0, 100, -100);
  bline(-100, -100, 0, 0);
  bline(-100, 100, 0, 0);
  glFlush();
};
int main(int argc, char *argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(640, 480);
  glutCreateWindow("hello world");
  glutDisplayFunc(display);
  init();
  glutMainLoop();

  return 0;
}

BSC
#include <GL/glut.h>
#include <vector>
#include <utility>
 
using namespace std;
 
void init()
{
 glClearColor(1.0, 1.0, 1.0, 0);
 glColor3f(0.0, 0.0, 0.0);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 gluOrtho2D(-340, 340, -240, 240);
}
void bsc(int r, int xc, int yc)
{
 int pk = 1 - r, x = 0, y = r;
 while (y >= x)
 {
   ++x;
   if (pk >= 0)
     --y, pk = pk + 1 + 2 * (x - y);
   else
     pk += 1 + 2 * x;
 
   if (x > y)
     break;
 
   vector<pair<int, int>> pts{
       {x + xc, y + yc},
       {x + xc, -y + yc},
       {-x + xc, y + yc},
       {-x + xc, -y + yc},
       {y + xc, x + yc},
       {y + xc, -x + yc},
       {-y + xc, x + yc},
       {-y + xc, -x + yc}};
   glBegin(GL_POINTS);
   for (auto [a, b] : pts)
     glVertex2d(a, b);
   glEnd();
 }
}
void display()
{
 glClear(GL_COLOR_BUFFER_BIT);
 bsc(10, 100, 100);
 glFlush();
}
int main(int argc, char *argv[])
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
 glutInitWindowSize(680, 480);
 glutCreateWindow("bsc");
 glutDisplayFunc(display);
 init();
 glutMainLoop();
 return 0;
}

3dTrans
#include <GL/glut.h>
#include <GL/freeglut.h>
#include <iostream>
#include <string>
#include <cmath>
using namespace std;
void printCube(double vertices[8][3])
{
 cout << "Plotting" << endl;
 glBegin(GL_QUADS);
 glColor3f(0, 0, 1); // behind
 glVertex3dv(vertices[0]);
 glVertex3dv(vertices[1]);
 glVertex3dv(vertices[2]);
 glVertex3dv(vertices[3]);
 glColor3f(0, 1, 1); // bottom
 glVertex3dv(vertices[0]);
 glVertex3dv(vertices[1]);
 glVertex3dv(vertices[5]);
 glVertex3dv(vertices[4]);
 glColor3f(1, 1, 0); // left
 glVertex3dv(vertices[0]);
 glVertex3dv(vertices[4]);
 glVertex3dv(vertices[7]);
 glVertex3dv(vertices[3]);
 glColor3f(1.0, 0, 1); // right
 glVertex3dv(vertices[1]);
 glVertex3dv(vertices[2]);
 glVertex3dv(vertices[6]);
 glVertex3dv(vertices[5]);
 glColor3f(0, 1, 0); // up
 glVertex3dv(vertices[2]);
 glVertex3dv(vertices[3]);
 glVertex3dv(vertices[7]);
 glVertex3dv(vertices[6]);
 glColor3f(1.0, 0, 0); // front
 glVertex3dv(vertices[4]);
 glVertex3dv(vertices[5]);
 glVertex3dv(vertices[6]);
 glVertex3dv(vertices[7]);
 glEnd();
}
void matrixMultiplication(double T[4][4], double P[4][1], double outputPoints[8][3], int index)
{
 cout << "(" << P[0][0] << "," << P[1][0] << "," << P[2][0] << ") ==> ";
 double res[4][1] = {0, 0, 0, 0};
 for (int i = 0; i < 4; i++)
 {
   for (int j = 0; j < 1; j++)
   {
     for (int k = 0; k < 4; k++)
     {
       res[i][j] += T[i][k] * P[k][j];
     }
   }
 }
 cout << "(" << res[0][0] << "," << res[1][0] << "," << res[2][0] << ")" << endl;
 outputPoints[index][0] = res[0][0];
 outputPoints[index][1] = res[1][0];
 outputPoints[index][2] = res[2][0];
 index++;
 return;
}
void myInit()
{
 glClearColor(1.0, 1.0, 1.0, 0.0);
 glColor3f(0.0f, 0.0f, 0.0f);
 glEnable(GL_DEPTH_TEST);
 glOrtho(-20, 20, -20, 20, -20, 20);
}
void myDisplay()
{
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 glBegin(GL_LINES);
 glColor3f(0.0f, 0.0f, 0.0f);
 glVertex3d(-10, 0, 0);
 glVertex3d(10, 0, 0);
 glVertex3d(0, -10, 0);
 glVertex3d(0, 10, 0);
 glVertex3d(0, 0, -10);
 glVertex3d(0, 0, 10);
 glEnd();
 // printCube();
 int n = 8, choice1, choice2;
 double points[8][3] = {{3, 3, -5}, {8, 3, -5}, {8, 8, -5}, {3, 8, -5}, {1, 1, 0}, {6, 1, 0}, {6, 6, 0}, {1, 6, 0}};
 double outputPoints[8][3];
 printCube(points);
 cout << " 1)Translation \n 2)Rotation \n 3)Scaling \n";
 cout << "Enter your choice: ";
 cin >> choice1;
 switch (choice1)
 {
 case 1:
 {
   cout << "Translation \n";
   double tx, ty, tz;
   cout << "Enter tx, ty, tz: ";
   cin >> tx >> ty >> tz;
   double T[4][4] = {
       1, 0, 0, tx,
       0, 1, 0, ty,
       0, 0, 1, tz,
       0, 0, 0, 1};
   for (int i = 0; i < n; i++)
   {
     double P[4][1] = {points[i][0], points[i][1], points[i][2], 1};
     matrixMultiplication(T, P, outputPoints, i);
   }
   printCube(outputPoints);
   break;
 }
 case 2:
 {
   cout << "Rotation \n";
   cout << " 1)About X-axis\n 2)About Y-axis\n 3)About Z-axis\n Enter your choice : ";
   cin >> choice2;
   int theta;
   cout << "Enter the angle of rotation: ";
   cin >> theta;
   double cosTheta = sin((90 - theta) * 3.14 / 180), sinTheta = sin(theta * 3.14 / 180);
   cout << cosTheta << " " << sinTheta << endl;
   double R[4][4] = {
       1, 0, 0, 0,
       0, 1, 0, 0,
       0, 0, 1, 0,
       0, 0, 0, 1};
   if (choice2 == 1)
   {
     R[1][1] = cosTheta;
     R[1][2] = -sinTheta;
     R[2][1] = sinTheta;
     R[2][2] = cosTheta;
   }
   else if (choice2 == 2)
   {
     R[0][0] = cosTheta;
     R[0][2] = sinTheta;
     R[2][0] = -sinTheta;
     R[2][2] = cosTheta;
   }
   else if (choice2 == 3)
   {
     R[0][0] = cosTheta;
     R[0][1] = -sinTheta;
     R[1][0] = sinTheta;
     R[1][1] = cosTheta;
   }
   for (int i = 0; i < n; i++)
   {
     double P[4][1] = {points[i][0], points[i][1], points[i][2], 1};
     matrixMultiplication(R, P, outputPoints, i);
   }
   printCube(outputPoints);
   break;
 }
 case 3:
 {
   cout << "Scaling \n";
   cout << " 1)About Origin\n 2)About (x,y,z)\n Enter your choice: ";
   cin >> choice2;
   double xr = 0, yr = 0, zr = 0, sx, sy, sz;
   if (choice2 == 2)
   {
     cout << "Enter xr, yr, zr: ";
     cin >> xr >> yr >> zr;
   }
   cout << "Enter scaling factors Sx,Sy,Sz: ";
   cin >> sx >> sy >> sz;
   double S[4][4] = {
       sx, 0, 0, xr * (1 - sx),
       0, sy, 0, yr * (1 - sy),
       0, 0, sz, zr * (1 - sz),
       0, 0, 0, 1};
   for (int i = 0; i < n; i++)
   {
     double P[4][1] = {points[i][0], points[i][1], points[i][2], 1};
     matrixMultiplication(S, P, outputPoints, i);
   }
   printCube(outputPoints);
   break;
 }
 }
 glColor3f(0.0, 0.0, 0.0);
 glFlush();
}
int main(int argc, char *argv[])
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
 glutInitWindowSize(500, 500);
 glutCreateWindow("Lokesh");
 glutDisplayFunc(myDisplay);
 myInit();
 glutMainLoop();
 return 1;
}

Animation
#include <GL/glut.h>
#include <math.h>
#include <iostream>
#include <string.h>
#include <unistd.h>
using namespace std;
void myInit()
{
 glClearColor(1.0, 1.0, 1.0, 0.0);
 glColor3f(0.0f, 0.0f, 0.0f);
 glPointSize(10);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 gluOrtho2D(0, 640.0, 0.0, 480.0);
}
void drawParabola(int midX, int midY)
{
 glBegin(GL_POINT);
 for (float x = -200; x <= 200; x += 0.05)
 {
   int y = -(x * x) / (4 * 50);
   glVertex2f(midX + x, midY + y);
 }
 glEnd();
}
 
void delay()
{
 for (int j = 0; j < 1e5; ++j)
 {
 }
}
void drawCircle(int x, int y)
{
 glBegin(GL_LINE_LOOP);
 int r = 10;
 for (float i = 0.0; i < 2 * 3.14; i += 3.14 / 18)
 {
   glVertex2d(x + r * cos(i), y + r * sin(i));
 }
 glEnd();
 delay();
}
float x = -200;
float midX = 300, midY = 300;
void moveCircle(int value)
{
 if (x >= (int)400 || (int)(midX + x) >= 600)
   return;
 glutPostRedisplay();
 float y = -(x * x) / (4 * 150);
 drawCircle(midX + x, midY + y);
 x += 0.05;
 glutTimerFunc(1500, moveCircle, value + 1);
}
void myDisplay()
{
 glClear(GL_COLOR_BUFFER_BIT);
 glBegin(GL_LINE_LOOP);
 glVertex2d(500, 400);
 glVertex2d(600, 400);
 glEnd();
 glBegin(GL_LINE_LOOP);
 glVertex2d(600, 400);
 glVertex2d(600, 100);
 glEnd();
 glBegin(GL_LINE_LOOP);
 glVertex2d(600, 100);
 glVertex2d(500, 100);
 glEnd();
 
 // drawCircle(100, 100);
 // drawParabola(300, 300);
 glBegin(GL_LINE_LOOP);
 moveCircle(0);
 glEnd();
 glFlush();
}
int main(int argc, char *argv[])
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
 glutInitWindowSize(640, 480);
 glutCreateWindow("Bressenham's Circle Drawing Algorithm");
 glutDisplayFunc(myDisplay);
 myInit();
 glutMainLoop();
 return 1;
}
3dProj
#include <iostream>
#include <cstring>
#include <GL/glut.h>
#include <math.h>
using namespace std;
// Global constants
const float WINDOW_WIDTH = 1000;
const float WINDOW_HEIGHT = 1000;
// Global variables to handle rotation
double x_rotate = 0;
double y_rotate = 0;
// Global variable for projection
bool isOrthoProjection = true;
void initializeDisplay();
void keyboardKeys(unsigned char key, int x, int y);
void drawAxes();
int main(int argc, char **argv)
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
 glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT);
 glutCreateWindow("3D Projections");
 // Register the callback functions
 glutDisplayFunc(initializeDisplay);
 glutKeyboardFunc(keyboardKeys);
 // Change to projection mode before applying glOrtho() / gluPerspective()
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 glutMainLoop();
 return 0;
}
void initializeDisplay()
{
 // Initialize display parameters
 glClearColor(1, 1, 1, 1);
 glClear(GL_COLOR_BUFFER_BIT);
 // Line width
 glLineWidth(3);
 // Apply the transformations & drawing on the model view matrix
 glMatrixMode(GL_MODELVIEW);
 // Draw the X and Y axis
 drawAxes();
 // Transform only the drawn object, so use the matrix stack accordingly
 glPushMatrix();
 if (isOrthoProjection)
 {
   // Parallel Projection
   glOrtho(-2, 2, -2, 2, -2, 2);
 }
 else
 {
   // Perspective Projection
   gluPerspective(120, 1, 0.1, 50); // FoVy = 120, Aspect Ratio = 1
 }
 gluLookAt(0, 0, 0.5, 0, 0, 0, 0, 1, 0); // Camera, Center & Up Vector
 glRotatef(x_rotate, 1, 0, 0);           // Keyboard based rotations
 glRotatef(y_rotate, 0, 1, 0);
 glColor4f(0, 0, 1, 0.3); // Draw the object
 glutWireCube(0.5);
 glPopMatrix(); // Pop the matrix back into the model view stack
 glFlush();
}
void drawAxes()
{
 // To draw X and Y axis
 glColor3d(1, 0, 0);
 glBegin(GL_LINES);
 glVertex2f(-2, 0);
 glVertex2f(2, 0);
 glVertex2f(0, -2);
 glVertex2f(0, 2);
 glEnd();
 glFlush();
}
void keyboardKeys(unsigned char key, int x, int y)
{
 // Callback function for keyboard interactivity
 key = tolower(key);
 switch (key)
 {
 case 'w':
 {
   x_rotate += 5;
   break;
 }
 case 's':
 {
   x_rotate -= 5;
   break;
 }
 case 'd':
 {
   y_rotate += 5;
   break;
 }
 case 'a':
 {
   y_rotate -= 5;
   break;
 }
 case 32:
 {
   // Spacebar for changing projections
   isOrthoProjection = !isOrthoProjection;
   break;
 }
 }
 // Update the display
 glutPostRedisplay();
}

#include <iostream>
#include <GL/glut.h>
 
using namespace std;
 
void init()
{
 glClearColor(1, 1, 1, 0);
 glLoadIdentity();
 glEnable(GL_LIGHTING);
 glEnable(GL_LIGHT0);
 glEnable(GL_DEPTH_TEST);
 glMatrixMode(GL_PROJECTION);
 // glOrtho(-500, 500, -500, 500, -500, 500);
 gluPerspective(75, 1, 1, 20);
 glMatrixMode(GL_MODELVIEW);
}
 
void display1()
{
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 gluLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
 
 glPushMatrix();
 glColor3f(0, 0, 0);
 glRotatef(100, 0, 1, 0);
 glutSolidCone(1, 1, 20, 20);
 glPopMatrix();
 
 glFlush();
}
 
void display2() {}
 
int main(int argc, char *argv[])
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
 glutInitWindowSize(1000, 1000);
 glutCreateWindow("hllo");
 init();
 glutDisplayFunc(display1);
 glutMainLoop();
 return 1;
}

3dScene
#include <iostream>
#include <cstring>
#include <GL/glut.h>
#include <math.h>
const float WINDOW_WIDTH = 800;
const float WINDOW_HEIGHT = 800;
const int FPS = 60;
// Global variables for handling animation
float translate_x = 0;
int frame = 0;
int direction = 1;
using namespace std;
void initializeDisplay();
void renderAnimation(int val);
void setLights();
void setMaterialParams(float aR, float aG, float aB, float dR, float dG,
                      float dB, float sR, float sG, float sB, float shiny);
int main(int argc, char **argv)
{
 glutInit(&argc, argv);
 glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
 glutInitWindowPosition(0, 0);
 glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT);
 glutCreateWindow("3D Animation ");
 glutDisplayFunc(initializeDisplay);
 glutTimerFunc(1000 / FPS, renderAnimation, 0);
 glEnable(GL_DEPTH_TEST);
 setLights();
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 gluPerspective(40, 1, 4, 20);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();
 gluLookAt(5, 5, 5, 0, 0, 0, 0, 1, 0);
 glutMainLoop();
}
void initializeDisplay()
{
 glClearColor(1, 1, 1, 1);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 glMatrixMode(GL_MODELVIEW);
 glColor4f(0, 0, 0, 0.3);
 // Draw a car
 glPushMatrix();
 glTranslatef(translate_x, 0, 0);
 // Body
 glPushMatrix();
 glScalef(5, 2, 2);
 setMaterialParams(0.75, 0.2, 0.75, 1, 1, 1, 1, 1, 1, 100);
 glutSolidCube(0.5);
 glPopMatrix();
 // Wheels
 setMaterialParams(0, 0, 0, 0, 0, 0, 1, 1, 1, 1);
 // Back Left
 glPushMatrix();
 glTranslatef(-1.25, -1, 0.25);
 glutSolidTorus(0.1, 0.25, 30, 30);
 glPopMatrix();
 // Front Left
 glPushMatrix();
 glTranslatef(0.75, -1, 0.25);
 glutSolidTorus(0.1, 0.25, 30, 30);
 glPopMatrix();
 // Back Right
 glPushMatrix();
 glTranslatef(-1.25, -1, -0.7);
 glutSolidTorus(0.1, 0.25, 30, 30);
 glPopMatrix();
 // Front Right
 glPushMatrix();
 glTranslatef(0.75, -1, -0.7);
 glutSolidTorus(0.1, 0.25, 30, 30);
 glPopMatrix(); // Headlights
 setMaterialParams(1, 1, 0.2, 1, 1, 1, 1, 1, 0.2, 300);
 // Left
 glPushMatrix();
 glTranslatef(1.25, -0.25, 0.25);
 glutSolidSphere(0.1, 30, 30);
 glPopMatrix();
 // Right
 glPushMatrix();
 glTranslatef(1.25, -0.25, -0.25);
 glutSolidSphere(0.1, 30, 30);
 glPopMatrix();
 // Roof Hat
 glPushMatrix();
 glRotatef(270, 1, 0, 0);
 glTranslatef(0.75, 0, 0.5); // Order important . Rotate - > Translate
                             // Last command acted on first in OpenGL , thus rotate about fixed point
 setMaterialParams(0, 0.25, 1, 0, 0.5, 1, 1, 1, 1, 1);
 // setMaterialParams (0 , 0.5 , 1 , 0 , 0.5 , 1 , 1 , 1 , 1 , 50) ;
 glutSolidCone(0.5, 0.75, 30, 30);
 glPopMatrix();
 glPopMatrix();
 glFlush();
 glutSwapBuffers(); // Swap the offscreen buffer to screen
}
void renderAnimation(int val)
{
 // Render an animation frame by frame
 frame = (frame % FPS) + 1;
 if (frame % 5 == 0)
 {
   translate_x += (0.04 * direction);
   // glutPostRedisplay();
   // initializeDisplay();
 }
 if (translate_x >= 1.40 || translate_x <= -3.40)
 {
   direction *= -1;
 }
 // Call the timer function again to keep animating
 glutTimerFunc(1000 / FPS, renderAnimation, 0);
}
void setMaterialParams(float aR, float aG, float aB, float dR, float dG,
                      float dB, float sR, float sG, float sB, float shiny)
{
 float ambient[3] = {aR, aG, aB};
 float diffuse[3] = {dR, dG, dB};
 float specular[3] = {sR, sG, sB};
 glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, ambient);
 glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuse);
 glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular);
 glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, shiny);
}
void setLights()
{
 glShadeModel(GL_SMOOTH); // Enable smooth shading of objects
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();
 float lightPosition[] = {0.0, 10.0, 5.0};
 float lightColor[] = {0.5, 0.5, 0.5};
 float ambientColor[] = {0.3, 0.3, 0.3};
 float spotDirection[] = {-1.0, -1.0, -1.0};
 glEnable(GL_LIGHTING);
 glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor);
 glEnable(GL_LIGHT0);
 glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
 glLightfv(GL_LIGHT0, GL_AMBIENT, lightColor);
 glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor);
 glLightfv(GL_LIGHT0, GL_SPECULAR, lightColor);
 glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 37.0);
 glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, spotDirection);
 glLightf(GL_LIGHT0, GL_SPOT_EXPONENT, 1);
}

