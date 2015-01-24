/*******************************************************************************
* playtone.ino
* Author Jeff Crockett
* 01/18/15
* Description - This function plays the tones for Simon.
*******************************************************************************/
#include "defines.h"
const int notes[5] = {
   0, NOTE_C4, NOTE_E4, NOTE_G4, NOTE_C5
};

void playtone (int button) {
   int note;
   if (button > 0 && button <= 4) {
       switch (button) {
            case 1 : {
                note = 1;
                break;
            }
            case 2 : {
                note = 2;
                break;
            }
            case 4 : {
                note = 4;
                break; 
            } 
            case 8 : {
                note = 3;
                break;
            }
            default : {
                note = 0;
                break;
            }
       }
       note = notes[button];
       playOneTone (note, 3000/8);
   }
}

void playOneTone(int note, int noteDuration){
    tone(TONE_PIN, note, noteDuration);
}

