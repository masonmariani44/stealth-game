#include <stdio.h>
#include "myprogram.h"

int MY_VAR = 2;

float add(float a, float b) {
    MY_VAR = 17;
    return a + b;
}