//
//  Force.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "Projectile.h"
#import "AppDelegate.h"

@implementation Projectile

- (id) initWithX:(double)ix andY:(double)iy andVX:(double)ivx andVY:(double)ivy
{
    self.oldX = self.x = ix*(METERS_PER_AU);
    self.vx = ivx;
    
    self.oldY = self.y = iy*(METERS_PER_AU);
    self.vy = ivy;
    
    self.points = [NSMutableArray array];
    return self;
}

@end
