/******************************************************************************
* read_input_from_kbd.c
* Date 01/01/2015
* Rev A
* Description:
* This program is a debug version of read_input which will read the characters
* from the keyboard and return the following as byte:
*                   'w'   returns 1
*                   's'   returns 2
*                   'z'   returns 3
*                   'a'   returns 4
* This function's return is 'which_button'.
* 
*******************************************************************************/
#include "defines.h"
int read_input_from_kbd (void) { 
    char inputted_char;
    static int which_button;
    inputted_char = Serial.read(); 
        switch (inputted_char) {
            case 'w' : {
                    which_button = 1;
                    break;
            }
            case 's' : {
                    which_button = 2;
                    break;
            }
            case 'z' : {
                    which_button = 3;
                    break;
            }
            case 'a' : {
                    which_button = 4;
                    break;
            }
            case 'c' : {
                    which_button = DIAGNOSTIC;
                    break;
            }
            case 'r' : {
                    which_button = START;
                    break;
            }
            case 'p' : {
                    which_button = PLAYBACK;
                    break;
            }
        }
            return which_button;
    }
