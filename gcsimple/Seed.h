//
//  Seed.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//enum seedType {
//    Star, SmallPlanet, GiantPlanet, Projectile
//};

@interface Seed : NSObject
{
    double _timeStep;
}

@property (assign) double v;
@property (assign) double x;
@property (assign) double y;
@property (assign) double z;
@property (assign) double t;

@property (assign) double r;
@property (assign) double theta;

@property (assign) int steps;
@property (assign) double time;
@property (assign) double m;
//@property (assign) enum seedType type;


- (id) initWithInitialVelocity:(double)velocity andOffsetDistance:(double)offsetY andInitialDistance:(double)offsetX andTimeStep:(double)hoursOffset andMass:(double)mass;

- (void) stepSimulation;

@end
