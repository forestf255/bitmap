#include <stdio.h>
#include "bmp.h"

int main(int argc, char *argv[]) {
    Bitmap *b = bm_create(128,128);

    bm_set_color(b, bm_atoi("black"));
    bm_set_alpha(b, 255);
    bm_puts(b, 30, 60, "Hello World");

    FILE *fp = fopen("rgb.dat", "w");
    fwrite(b->data, 128 * 128 * 4, 1, fp);
    fclose(fp);
    return 0;
}
