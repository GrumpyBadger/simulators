//
//  Simulator.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "Simulator.h"
#import "AppDelegate.h"

@implementation Simulator
{
    double _stepPeriod;
    double _starMass;
    unsigned long _steps;
    
    StarView *_starView;
}

- (id) initWithStepPeriod:(double)period andStarMass:(double)mass onStarView:(StarView *)view
{
    _stepPeriod = period;
    _starMass = mass;
    _starView = view;
    
    self.planets = [NSMutableArray array];
    self.projectiles = [NSMutableArray array];
    _steps = 0;
    
    return self;
    
}

- (void) addPlanet:(Planet *)planet
{
    [self.planets addObject:planet];
}

- (void) addProjectile:(Projectile *)projectile
{
    [self.projectiles addObject:projectile];
}

- (void) step
{
    double spanX = 2*_starView.displayScale;
    double spanY = spanX * (_starView.frame.size.height/_starView.frame.size.width);
    
//    NSImageView *starImageView = _starView.starImageView;
//    
//    NSRect starFrame = NSMakeRect(starImageView.frame.size.width/2 + starImageView.frame.size.width/2,
//                                  starImageView.frame.size.height/2 + starImageView.frame.size.height/2,
//                                  starImageView.frame.size.width, starImageView.frame.size.height);
//    
//    [starImageView setFrame:starFrame];
    
//    NSLog(@"spanX = %f, spanY = %f", spanX, spanY);
    
    //  Calculate New Projectile Locations
    for( int pp=0; pp<self.projectiles.count; pp++ )
    {
        Projectile *thisProjectile = [self.projectiles objectAtIndex:pp];
        
        double deltaX = _stepPeriod*thisProjectile.vx;  // km
        double deltaY = _stepPeriod*thisProjectile.vy;  // km
        
        thisProjectile.x += deltaX*1000;
        thisProjectile.y += deltaY*1000;
        
//        NSLog(@"computing projectile vx,x,y,dx,dy = %f, %f, %f, %f, %f", thisProjectile.vx, thisProjectile.x, thisProjectile.y, deltaX, deltaY);
        
        //  Draw a line from the old location to the new
        [self drawline:thisProjectile];
        
        thisProjectile.oldX = thisProjectile.x;
        thisProjectile.oldY = thisProjectile.y;
        
        //  Recalculate Velocities
        double deltaVX = [self calDeltaVX:thisProjectile];
        double deltaVY = [self calDeltaVY:thisProjectile];
        
        thisProjectile.vx += deltaVX;
        thisProjectile.vy += deltaVY;
        
        for( int ip=0; ip<self.planets.count; ip ++)
        {
            Planet *thisPlanet = [self.planets objectAtIndex:ip];
            
            thisProjectile.vx += [self calDeltaVX:thisProjectile forPlanet:thisPlanet];
            thisProjectile.vy += [self calDeltaVY:thisProjectile forPlanet:thisPlanet];
        }
    }
    
    //  Calculate New Planet Locations
    Planet *thisPlanet;
    
    for( int ip=0; ip<self.planets.count; ip ++)
    {
        thisPlanet = [self.planets objectAtIndex:ip];
        
        double deltaTheta = (_stepPeriod/thisPlanet.period) * 2 * M_PI;
        thisPlanet.theta =  fmod((thisPlanet.theta + deltaTheta), 2 * M_PI);
        
        thisPlanet.x = thisPlanet.r * cos( thisPlanet.theta );
        thisPlanet.y = thisPlanet.r * sin( thisPlanet.theta );
        
//        NSLog(@"planet period,sp,dt,x,y,theta = (%f, %f, %f, %f, %f, %f)", thisPlanet.period, _stepPeriod, deltaTheta, thisPlanet.x, thisPlanet.y, thisPlanet.theta );
        
        double placeX = spanX/2 + thisPlanet.x;
        double placeY = spanY/2 + thisPlanet.y;
        
//        NSLog(@"placeX = %f, placeY = %f", placeX, placeY);
        
        NSRect newImageFrame = NSMakeRect((placeX/spanX)*_starView.frame.size.width - thisPlanet.image.frame.size.width/2,
                                          (placeY/spanY)*_starView.frame.size.height - thisPlanet.image.frame.size.height/2,
                                          thisPlanet.image.frame.size.width, thisPlanet.image.frame.size.height);
        
        [thisPlanet.image setFrame:newImageFrame];
    }
    
    //  Display
    
    _steps++;
}

- (void) drawline:(Projectile *)p
{
    double minX = -_starView.displayScale/2;
    double maxX = _starView.displayScale/2;
    double minY = -_starView.displayScale * (_starView.frame.size.height/_starView.frame.size.width)/2;
    double maxY = _starView.displayScale * (_starView.frame.size.height/_starView.frame.size.width)/2;

    if( (p.x <= (minX*METERS_PER_AU)) || (p.oldX > (maxX*METERS_PER_AU))
       || (p.y <= (minY*METERS_PER_AU)) || (p.oldY > (maxY*METERS_PER_AU)) )
        return; // off display
    
//    NSLog(@"about to draw line from (%f, %f) to (%f, %f), (%f, %f)", p.oldX, p.oldY, p.x, p.y, minX, minY);
//    NSLog(@"view is %f x %f", _starView.frame.size.width, _starView.frame.size.height);
    
    int iX = (((p.oldX/METERS_PER_AU)-minX)/(maxX-minX))*_starView.frame.size.width;
    int eX = (((p.x/METERS_PER_AU)-minX)/(maxX-minX))*_starView.frame.size.width;
    int iY = (((p.oldY/METERS_PER_AU)-minY)/(maxY-minY))*_starView.frame.size.height;
    int eY = (((p.y/METERS_PER_AU)-minY)/(maxY-minY))*_starView.frame.size.height;
   
//    NSLog(@"would draw line from (%d, %d) to (%d, %d)", iX, iY, eX, eY);
    
    NSPoint start = NSMakePoint(iX, iY);
    NSPoint end = NSMakePoint(eX, eY);
    
    if( p.points.count == 0 )
        [p.points addObject:[NSValue valueWithPoint:start]];
    
    [p.points addObject:[NSValue valueWithPoint:end]];
    
//    [_starView setNeedsDisplay:YES];
}

double dvStar = 0;   // km per sec
double rStar = 0;

- (double) calDeltaVX:(Projectile *)p
{
    // Calculate the change in velocity vs. the Star
    //
    //  F = ma = GM(star)/r^2
    //
    double starRadius = STAR_RADIUS;
    
    rStar = sqrt(p.x*p.x + p.y*p.y);
    
    if( rStar < starRadius )
    {
        NSLog(@"Hits Star!!");
        return -p.vx;
    }
    
    double thetaStar = asin(p.x/rStar);
    
    NSLog(@"distance (%.2f, %.2f, %.2f %.2f) to star=%.2f AU, theta=%.f degrees", p.x/METERS_PER_AU, p.y/METERS_PER_AU, p.vx, p.vy, rStar/METERS_PER_AU, thetaStar*360/(M_PI*2));
    
    dvStar = ((UGC*STAR_MASS/(rStar * rStar)));   // m per sec per sec
    
    double dVX = 0;
    
    NSLog(@"aradial = %.9f m/s/s", dvStar);
    
    dVX = -p.x/rStar * dvStar * _stepPeriod/1000;
    NSLog(@"dVX = %.9f km/s", dVX);
    
    // Calculate the change in velocity vs. the Planets
    return dVX;
}

- (double) calDeltaVY:(Projectile *)p
{
    double starRadius = STAR_RADIUS;
    
    if( rStar < starRadius )
    {
        NSLog(@"Hits Star!!");
        return -p.vy;
    }
    
    double dVY = 0;
    
    dVY = -p.y/rStar * dvStar * _stepPeriod/1000;
    NSLog(@"dVY = %.9f", dVY);
    
    // Calculate the change in velocity vs. the Planets
    return dVY;
}

double dvPlanet = 0;   // km per sec
double rPlanet = 0;

- (double) calDeltaVX:(Projectile *)p forPlanet:(Planet *)planet
{
    // Calculate the change in velocity vs. the Star
    //
    //  F = ma = GM(star)/r^2
    //
    double planetX = planet.x*METERS_PER_AU;    //  Planet coordinates are in AU
    double planetY = planet.y*METERS_PER_AU;
    
    double dPlanetX = p.x - planetX;
    double dPlanetY = p.y - planetY;
    
    rPlanet = sqrt(dPlanetX*dPlanetX + dPlanetY*dPlanetY);
    
    if( rPlanet < planet.radius )
    {
        NSLog(@"Hits %@!!", planet.name);
        return -p.vx;
    }
    
    double thetaPlanet = asin(dPlanetX/rPlanet);
    
    NSLog(@"%@ distance (%.2f, %.2f, %.2f %.2f) to planet=%.2f AU, theta=%.f degrees", planet.name, dPlanetX/METERS_PER_AU, dPlanetY/METERS_PER_AU, p.vx, p.vy, rPlanet/METERS_PER_AU, thetaPlanet*360/(M_PI*2));
    
    dvPlanet = ((UGC*planet.mass/(rPlanet * rPlanet)));   // m per sec per sec
    
    double dVX = 0;
    
    NSLog(@"%@ dvradial = %.9f km/s", planet.name, dvPlanet);
    
    dVX = -dPlanetX/rPlanet * dvPlanet * _stepPeriod/1000;
    NSLog(@"dVX %@ = %.9f", planet.name, dVX);
    
    // Calculate the change in velocity vs. the Planets
    return dVX;
}

- (double) calDeltaVY:(Projectile *)p forPlanet:(Planet *)planet
{
    double planetX = planet.x*METERS_PER_AU;    //  Planet coordinates are in AU
    double planetY = planet.y*METERS_PER_AU;
    
    double dPlanetX = p.x - planetX;
    double dPlanetY = p.y - planetY;
    double dVY = 0;
    
    dVY = -dPlanetY/rPlanet * dvPlanet * _stepPeriod/1000;
    NSLog(@"dVY %@ = %.9f", planet.name, dVY);
    
    // Calculate the change in velocity vs. the Planets
    return dVY;
}

@end
