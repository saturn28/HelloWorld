/*******************************************************************************
* output_delay.ino
* Author Jeff Crockett
* Date 01/06/15
* Rev A
* Description - This module handles the delay of ouputting of results 
*******************************************************************************/
#include "defines.h"
#define BLANKIT 1
#define DONE 2
int output_delay (int *dispval_ptr) {
    int to_stat;
    static long int init_time;
    static int init_state;
    static int orig_disp_val;
    long int current_time;
    if (init_state == 0) {
        init_time = millis ();
        init_state = BLANKIT;
        to_stat = 0;
        orig_disp_val = *dispval_ptr;
    }
    else if (init_state == BLANKIT) {
        *dispval_ptr = 0;       //Do the blanking
        current_time = millis ();
        if ((current_time - init_time > BLANK_TIME) && (init_time < current_time)) {
            to_stat = 1;
            init_time = millis ();
            init_state = DONE;
        }
    }
    else {
        current_time = millis ();
        *dispval_ptr = orig_disp_val;   //Restore display value and hold
        if ((current_time - init_time > PLAYBACK_WAIT_TIME - BLANK_TIME) && (init_time < current_time)) {            
            init_state = 0;
        }
    }
    return to_stat;
}
