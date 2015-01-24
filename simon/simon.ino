/*******************************************************************************
* simon.c
* Author Jeff Crockett
* Date 01/01/2015
* Rev A
* Description:
* Top level program for simon
*******************************************************************************/
#include "defines.h"
#include <stdio.h>
void setup () {
  // Open serial communications and wait for port to open:
  Serial.begin(BAUDRATE);
  Serial.println("Please enter the following:");
  Serial.println("      w  1");
  Serial.println("a 4           s 2");
  Serial.println("      z  3");
  Serial.println("r to start");
  Serial.println("c to calibrate IO pins");
  Serial.println("p to playback the sequence to follow");
  //Set up multiplexed LED displays for output
    DDRL   = B11111111;
  // initialize the I/O pins as outputs

  pinMode(STRB, OUTPUT);
  pinMode(DBG_LED, OUTPUT); 
  
  // take the col pins (i.e. the cathodes) low to ensure that
  // the LEDS are off: 
  digitalWrite(STRB, LOW);
  digitalWrite(DBG_LED, LOW);
}

void loop () {
    unsigned int seq_to_follow_buf[40];      //This buffer holds the sequence to follow
    static int disp_code;
    static int index_count;
    static int mode;
    static int random_num;
    static int button;
    static int playback_index;
    int sequence_count;
    int led_code;
    char temp[80];
    static int ready;
    if (ready == 1) {
        button = read_input_from_kbd();
        random_num = random_gen ();
        write_to_follow_seq_buf (seq_to_follow_buf, random_num, 0);
        if (button != 0) {
            sprintf(temp,"button = %i",button);
            Serial.println(temp);
        }
                                  
        if (button >  15) {
            mode = button;
            button = 0;
        }
    }
    disp_code = dispatcher (&mode, seq_to_follow_buf, random_num, button, ready);
    write_to_leds (disp_code);
    playtone(disp_code);
    ready = Serial.available();
}
   

