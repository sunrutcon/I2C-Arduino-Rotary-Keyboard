I2C-Arudino-Rotary-Keyboard
========================

Handling multiple rotary encoders with microcontroller and acting like i2c keyboard.

1 Introduction

When handling big amount of code with microcontroller with lot of interrupts, serial port, IR communication, handling one or more rotary encoders could be quite problem and it could decrese quality of functionality by inserting lot of errors or may stop working for some amount of time while waiting for other operations to be finished. Rotary encoders should be scanned quite fast to get great response and quality, so I decided to make a new module that would act as I2C device providing information about rotarys rotation steps and buttons pressed.

2 Prerequisites

Arduino IDE should have installed Rotary, Button and Wire library.
Wire library must be changed to provide some functionality on which depends main program. One must add definition and declaration of function write_raw in Wire.h and Wire.cpp.

