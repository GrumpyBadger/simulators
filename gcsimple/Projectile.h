//
//  Force.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Projectile : NSObject

@property (assign) double x;
@property (assign) double y;
@property (assign) double vx;   // km/sec.
@property (assign) double vy;

@property (assign) double oldX;
@property (assign) double oldY;

@property (strong) NSMutableArray *points;

- (id) initWithX:(double)ix andY:(double)iy andVX:(double)ivx andVY:(double)ivy;

@end
