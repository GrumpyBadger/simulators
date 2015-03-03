//
//  Seed.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "Seed.h"

@implementation Seed

- (id) initWithInitialVelocity:(double)velocityKms andOffsetDistance:(double)offsetYAU andInitialDistance:(double)offsetXAU andTimeStep:(double)hoursOffset andMass:(double)mass
{
    self.x = offsetXAU * METERS_PER_AU;
    self.y = offsetYAU * METERS_PER_AU;
    self.z = 0;
    
    self.v = 0;
    self.theta = 0;
    self.m = mass;
    
    return self;
}

- (void) stepSimulation
{
    self.steps++;
    self.time += _timeStep;
}

@end
