/*******************************************************************************
* write_to_leds.v
* Author Jeff Crockett
* Date 01/01/2015
* Rev A
* Description
* Write the button values t the indicator leds.
********************************************************************************/
#include "defines.h"
void write_to_leds (int led_val) {
   byte led_bits;

   switch (led_val) {
      case 0 : {        //blanking - all off 
            led_bits = 0;
            break;
      }
      case 1 : {
            led_bits = 1;
            break;
      }
      case 2 : {
            led_bits = 2;
            break;
      }
      case 3 : {
            led_bits = 8;
            break;
      }
      case 4 : {
            led_bits = 4;
            break;
      }
      case 8 : {     //all on
            led_bits = 15;
            break;
      }
   }
    
   // refresh the leds
//    for (int rfsh_ctr = 0;rfsh_ctr <= 21;rfsh_ctr++) {
   refreshLeds(led_bits);                                        //Takes about 48ms
//    }
//}
}

void refreshLeds(byte portL_led_mask) {
    static int      not_first_time;
    static long int time_ms;
    static long int new_time_ms;
    char  temp[40];
//    if (not_first_time == 0) {
        PORTL = portL_led_mask;
        digitalWrite(2, HIGH);               
        time_ms = millis ();
        not_first_time = 1;
//        return;
//    } else {
        new_time_ms = millis ();
        if (new_time_ms < time_ms) {
            //Roll over - Turn LEDs off and start over
            digitalWrite(2,LOW);
            not_first_time = 0;
        }
        else if (new_time_ms - time_ms > 17) { 
        delay(16.67);            
            
            if (new_time_ms - time_ms > 34) {
                not_first_time = 0;
            }
            digitalWrite(2, LOW);
        }
        return;
//    }
//        delay(33.33);
}


//void dump_value (char msg[], int value) {                 
//    char str[32];
//    sprintf (str,"%s %02x\t",msg,value);
//    Serial.println(str);
//    return;
//}                                              



