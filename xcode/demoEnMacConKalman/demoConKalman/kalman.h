//
//  kalman.h
//  demoConKalman
//
//  Created by Juan Ignacio Braun on 10/1/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//  http://interactive-matter.eu/blog/2009/12/18/filtering-sensor-data-with-a-kalman-filter/


#include <math.h>

typedef struct {
    double q; //process noise covariance
    double r; //measurement noise covariance
    double x; //value
    double p; //estimation error covariance
    double k; //kalman gain
} kalman_state;

kalman_state kalman_init(double q, double r, double p, double intial_value);

void kalman_update(kalman_state* state, double measurement);