//
//  Planet.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Planet : NSObject

@property (assign) double period;
@property (assign) double radius;   // km
@property (assign) double mass;
@property (assign) double vt;
@property (assign) double theta;

@property (assign) double x;        // km
@property (assign) double y;        // km
@property (assign) double r;        // km

@property (strong, nonatomic) NSString *name;        // km

@property (weak) NSImageView *image;

- (id) initWithPeriod:(double)period andRadius:(double)radius atDistance:(double)distance andTheta:(double)theta andMass:(double)mass andImageView:(NSImageView *)imageView andName:(NSString *)pname;

@end
