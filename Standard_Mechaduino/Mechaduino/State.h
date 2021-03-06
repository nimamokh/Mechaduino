//Contains the declaration of the state variables for the control loop

#ifndef __STATE_H__
#define __STATE_H__

//---- interrupt vars ----
extern volatile int r;            //target angle
extern volatile int y;           //current angle

extern volatile int u;            // control effort

extern volatile bool dir;         // flag for  dir setting
extern volatile bool enabled;     // flag for  enabled setting

extern volatile bool frequency_test;       // flag for frequency test

//---- PID Gains ----
extern volatile int int_Kp;
extern volatile int int_Ki;
extern volatile int int_Kd;

extern volatile int big_Kp;
extern volatile int big_Ki;
extern volatile int big_Kd;

extern volatile int small_Kp;
extern volatile int small_Ki;
extern volatile int small_Kd;


extern volatile int step_target;        // target as step gets incremented if an step is received

#endif
