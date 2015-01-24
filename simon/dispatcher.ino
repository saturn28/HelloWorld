/*******************************************************************************
* dispatcher.c
* Author: Jeff Crockett
* Date 01/06/2015
* Rev A
* Description - This program decides what to do with the key or button presses.
* Parameters int mode - mode or button code
* Returns int display_code - display code is the code which is passed to 
* disp(int) in main loop.
*******************************************************************************/
#include "defines.h"
int dispatcher (int *mode, unsigned int buff[], int rnum, int button, int havechr) {
        static int  disp;
        static int i,j;
        static int speed_index;
        static int sequence_count;
        static int examine_count;
        static int havepress;
        static unsigned int *examine_ptr = NULL;
        int     a,b;
        char        temp[80];
        switch (*mode) {          //TODO Move to command_dispatcher
            case DIAGNOSTIC : {
               disp = button;      //Diagnostic might not be needed
               break;
            }
            case START : {
               *mode = INPLAY;
               examine_ptr = buff;
               disp = 0;
               break;
            }
            case INPLAY : {
               // Playback to *seq_ctr_ptr
               // start timeout timer
               // get button and compare
               // if good increment *seq_ctr_ptr
               sequence_count = 1;
               examine_count  = 1;
               speed_index = 0;
               *mode = PLAYBACK;
               break;
            }
            case PLAYBACK : {   
              if( i < sequence_count) {
                  disp = buff[i];
                  if (output_delay (&disp, speed[speed_index]) == 0) {                     
                      sprintf(temp,"buffer data %i buffer index %i\n",buff[i],i);
                      Serial.println(temp);
                      disp = buff[i];
                      i++;
                  }
              }
              else {
                  if (output_delay (&disp, speed[0]) == 0) {
                      *mode = EXAMINEUSR;
                      i = 0;
                      if (sequence_count == MEDIUM_SPEED_TH) {
                         speed_index = 1;
                      } 
                      else if (sequence_count == HIGH_SPEED_TH) {
                         speed_index = 2;
                      }
                      sequence_count++;
                  }
              }
              break;
            }
            case EXAMINEUSR : {
                if (j < examine_count)  {
                    a = button;
                    disp = 0;               
                    if (a <= 4 && a > 0 && havechr == 1) {
                        disp = a;
                        if (a == *examine_ptr) {    
                        button = 0;
                        j++;
                        examine_ptr++;
                        }
                        else {                          //Failure
                            Serial.println("Error");
                            sprintf(temp,"You entered %i",button);
                            Serial.println(temp);                                   
                            sprintf(temp,"You should have entered %i",*examine_ptr);
                            Serial.println(temp);
                            disp = *examine_ptr;   
                        }
                    }        
                }
                else {
                    *mode = WAITB4PLAYBACK;
                    j = 0;
                    examine_count++;
                    button = 0;
                    examine_ptr = buff;
                    if (output_delay (&disp,speed[0]) == 0) {
                      disp = 0;
                    }
                    Serial.println("Done Sequence");
                    return disp;
                }
                break;
            }
            case WAITB4PLAYBACK : {
                disp = 0;
                if (output_delay (&disp,speed[0]) == 0) {
                    *mode = PLAYBACK;
                }
                break;
            }
        }
        return disp;
}

    
