
//
//  Simulator.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarView.h"
#import "Planet.h"
#import "Projectile.h"

@interface Simulator : NSObject

@property (strong) NSMutableArray *planets;
@property (strong) NSMutableArray *projectiles;

- (id) initWithStepPeriod:(double)period andStarMass:(double)mass onStarView:(StarView *)view;
- (void) addPlanet:(Planet *)planet;
- (void) addProjectile:(Projectile *)projectile;
- (void) step;
- (void) drawline:(Projectile *)p;

@end
