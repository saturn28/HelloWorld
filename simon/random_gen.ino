/*******************************************************************************
* random_gen.ino
* Author: Jeff Crockett
* Date: 01/03/2015
* Rev A
* Arguments: none
* Returns: int
* Description:
* Generates a random number from 1 to 4
* 
*******************************************************************************/
#include "defines.h"
int random_gen (void) {
    long unsigned int raw_random_number;
    unsigned long time_ms;
    time_ms = millis ();
    randomSeed (time_ms & SEED_MASK);
    raw_random_number = random (0,RANDOM_MAX);
    return (raw_random_number % 4L) + 1L;
}
