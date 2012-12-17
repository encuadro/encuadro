//
//  kalman.h
//  demoConKalman
//
//  Created by Juan Ignacio Braun on 10/1/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//  http://interactive-matter.eu/blog/2009/12/18/filtering-sensor-data-with-a-kalman-filter/


#include <math.h>
#include "vvector.h"
#include "svd.h"


typedef struct {
    float q; //process noise covariance
    float r; //measurement noise covariance
    float x; //value
    float p; //estimation error covariance
    float k; //kalman gain
} kalman_state;

typedef struct {
    float** q; //process noise covariance
    float** r; //measurement noise covariance
    float* x; //value
    float** p; //estimation error covariance
    float** k; //kalman gain
} kalman_state_n;

kalman_state kalman_init(float q, float r, float p, float intial_value);

void kalman_update(kalman_state* state, float measurement);

kalman_state_n kalman_init_3x3(float** q, float** r, float** p, float** k, float* intial_value);

void kalman_update_3x3(kalman_state_n* state, float* measurement,float** A, float** H);

void kalman_sensors_update(kalman_state_n* state, float* measurement,float** A, float** H);