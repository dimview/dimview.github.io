// Generates printable dragon curve template

#include <stdio.h>
#define cimg_display 0
#include "CImg.h" // from http://cimg.sourceforge.net
using namespace cimg_library;

int main(void) {
  const unsigned rows = 36; // picture size in cells
  const unsigned cols = 32;
  unsigned x = 23; // starting position in cells
  unsigned y = 12;
  const int cellsize = 24; // in pixels
  int xn = 3; // horizontal tiles
  int yn = 3; // vertical tiles
  int nn = 512; // curve length

  bool flags[cols * 2 + 1][rows * 2 + 1] = { 0 };
  bool up_right = true;
  bool up_left = true;
  for ( int n = 0
      ; x > 0 && x < cols && y > 0 && y < rows && n < nn
      ; n++
      ) {
    bool turn_right = (((n & -n) << 1) & n);
    if (up_right) {
      if (up_left) { // going up
        y--;
        if (turn_right) {
          flags[x * 2 + 1][y * 2 + 1] = true;
          up_left = false;
        } else {
          flags[x * 2][y * 2 + 1] = true;
          up_right = false;
        }
      } else { // going right
        x++;
        if (turn_right) {
          up_right = false;
          flags[x * 2][y * 2 + 1] = true;
        } else {
          up_left = true;
          flags[x * 2][y * 2] = true;
        }
      }
    } else {
      if (up_left) { // going left
        x--;
        if (turn_right) {
          up_right = true;
          flags[x * 2 + 1][y * 2] = true;
       } else {
          up_left = false;
          flags[x * 2 + 1][y * 2 + 1] = true;
        }
      } else { // going down
        y++;
        if (turn_right) {
          up_left = true;
          flags[x * 2][y * 2] = true;
        } else {
          up_right = true;
          flags[x * 2 + 1][y * 2] = true;
        }
      }
    }
  }
  CImg<> image = CImg<>(1,1,1,3, 255,255,255).resize(cols * cellsize * 2,rows * cellsize * 2);
  unsigned char black[] = { 0,0,0 };
  for (unsigned row = 0; row < rows * 2; row++) {
    for (unsigned col = 0; col < cols * 2; col++) {
      if (flags[col][row]) {
        int x0 = (col + 1) * cellsize;
        int y0 = (row + 1) * cellsize;
        int x1 = x0;
        int x2 = x0;
        int y1 = y0;
        int y2 = y0;
        if (row & 1) {
          if (col & 1) {
            y0 += cellsize;
            x2 += cellsize;
          } else {
            y2 += cellsize;
            x1 += cellsize; x2 += cellsize;
          }
        } else {
          if (col & 1) {
            y1 += cellsize; y2 += cellsize;
            x2 += cellsize;
          } else {
            y0 += cellsize; y1 += cellsize;
            x1 += cellsize; x2 += cellsize;
          }
        }
        image.draw_line(x0, y0, 0, (x0 + 3 * x1) / 4, (y0 + 3 * y1) / 4, 0, black);
        image.draw_line((x0 + 3 * x1) / 4, (y0 + 3 * y1) / 4, 0, (x2 + 3 * x1) / 4, (y2 + 3 * y1) / 4, 0, black);
        image.draw_line((x2 + 3 * x1) / 4, (y2 + 3 * y1) / 4, 0, x2, y2, 0, black);
      }
    }
  }
  int w = image.width();
  int h = image.height();
  for (int y = 0; y < yn; y++) {
    for (int x = 0; x < xn; x++) {
      char f[64];
      snprintf(f, sizeof(f) - 1, "dragon%d%d.png", x, y); // tiles
      image.get_crop(x * w / xn, y * h / yn, (x + 1) * w / xn, (y + 1) * h / yn).save(f);
    }
  }
  image.save("dragon.png"); // overall picture
}