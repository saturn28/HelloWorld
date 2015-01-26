/*******************************************************************************
* timeout.ino
* Author Jeff Crockett
* Date 01/26/2015
* Rev A
* Description - This function determines if the user takes too long to repeat the
* sequence.
*******************************************************************************/
#include "defines.h"
void timeout (int *status, int rst) {
   static long int init_time;
   static long int init_state;
   long int current_time;
   if (rst == 1) {
      *status = 0;
      init_time = millis ();
   }
   current_time = millis ();
   if ((current_time - init_time > TIMEOUT_TIME) && (init_time < current_time)) {
       *status = 1;
       init_time = millis ();
   }
}

   
      

