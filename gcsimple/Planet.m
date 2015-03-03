//
//  Planet.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "Planet.h"

@implementation Planet

- (id) initWithPeriod:(double)period andRadius:(double)radius atDistance:(double)distance andTheta:(double)theta andMass:(double)mass andImageView:(NSImageView *)imageView andName:(NSString *)pname
{
    self.period = period;
    self.radius = radius;
    self.r = distance;
    self.theta = theta;
    self.mass = mass;
    self.image = imageView;
    self.name = pname;
    
    return self;
}

@end
