// create XOR image texture

#include <stdio.h>
#include <string.h>
#include <gd.h>

int main(void) {
 FILE *pngout = {0};
 gdImagePtr img;
 int white, color;
 int width, height;
 int pix, x, y;
 int red, green, blue;

 width = height = 256;
 white = color = pix = x = y = 0;
 red = green = blue = 0;

 img = gdImageCreateTrueColor(width, height);
 white = gdImageColorAllocate(img, 255, 255, 255);

 for(x = 0; x < width; x++) {
  for(y = 0; y < height; y++) {
   /* pix = x ^ y ^ pix; */
   pix = x ^ y;
   red = gdImageRed(img, pix);
   /* red = 255 - pix; */
   green = gdImageGreen(img, pix);
   /* green = pix; */
   blue  = gdImageBlue(img, pix);
   /* blue  = pix % 128; */
   color = gdImageColorAllocate(img, red, green, blue);

   gdImageSetPixel(img, x, y, color);
  }
 }

 pngout = fopen("xorimagetexture.png", "wb");
 gdImagePng(img, pngout);
 fclose(pngout);
 gdImageDestroy(img);

 return 0;
}
