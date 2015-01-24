/*******************************************************************************
* defines.h
* Author Jeff Crockett
* Date 01/01/2015
* Rev A
* Description
* This file contains all of the includes and defines for the Simon arduino 
* project
*******************************************************************************/
#include <stdio.h>
#include <SoftwareSerial.h>
#include "pitches.h"
#define STRB        2
#define DBG_LED     13
#define BAUDRATE    9600
#define RANDOM_MAX  0x8000L
#define SEED_MASK   0x7FFFL
#define PLAYBACK_WAIT_TIME_SLOW  500L
#define PLAYBACK_WAIT_TIME_MED  250L
#define PLAYBACK_WAIT_TIME_FAST  125L
#define MEDIUM_SPEED_TH              6
#define HIGH_SPEED_TH                10
#define BLANK_TIME  100L
#define TONE_PIN     8

#define DIAGNOSTIC 16    
#define START      17 
#define INPLAY     18
#define PLAYBACK   19
#define EXAMINEUSR 20
#define WAITB4PLAYBACK  21

    
//#define TESTMODE  




