//
//  AppDelegate.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "AppDelegate.h"
#import "Simulator.h"
#import "GCSGlobal.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    //  Simulation Parameters
    double _initialVelocity;    // km per second
    
    double _initialOffset;  //  AU
    
    double _initialDistance;    // AU
    
    double _timeIncrement;  //  hours
    
    BOOL _bSimulating;
    
    //  Display Parameters
    double _displayScale;   // AU (vertically)
    
    NSTimer *_thisTimer;
    NSTimer *_displayTimer;
    BOOL _bPaused;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    gGlobal = [[GCSGlobal alloc] init];
    
    _bSimulating = NO;
    _bPaused = NO;
    
    [self.pauseSimulationButton setHidden:YES];
    [_thisTimer invalidate];
    _thisTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [_displayTimer invalidate];
    _displayTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(displayTimerHandler:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)pauseSimulation:(id)sender
{
    if( _bSimulating )
    {
        NSLog(@"simulation paused");
        
        _bSimulating = NO;
        _bPaused = YES;
        
        [self.startSimulationButton setTitle:@"Resume"];
        [self.pauseSimulationButton setHidden:YES];
    }
    
}

- (IBAction)startSimulation:(id)sender
{
    if( _bPaused )
    {
        _bSimulating = YES;
        _bPaused = NO;
        [self.startSimulationButton setTitle:@"Stop"];
        [self.pauseSimulationButton setHidden:NO];
        
        return;
    }
    
    if( _bSimulating )
    {
        NSLog(@"simulation stopped");
        
        _bSimulating = NO;
        _bPaused = NO;
        
        [self.startSimulationButton setTitle:@"Start"];
        [self.starView setHidden:YES];
        [self.pauseSimulationButton setHidden:YES];
    }
    else
    {
        _initialVelocity = self.initialVelocityText.doubleValue;
        _initialOffset = self.initialOffsetText.doubleValue;
        _initialDistance = self.initialDistanceText.doubleValue;
        _timeIncrement = self.timeIncrementText.doubleValue;
        self.starView.displayScale = self.displayScaleText.doubleValue;
        self.starView.starImageView = self.starImageView;
        
        NSLog(@"simulation started iv=%.2f km/s, io=%.0f AU, id=%.0f AU, ti=%.0f hrs, ds=%.0f AU",
              _initialVelocity, _initialOffset, _initialDistance, _timeIncrement, _displayScale);
        
        _bSimulating = YES;
        _bPaused = NO;
        
        gGlobal.simulator = [[Simulator alloc] initWithStepPeriod:_timeIncrement*3600.0 andStarMass:STAR_MASS onStarView:self.starView];
        
        //  Add the Planets
        Planet *thisPlanet = [[Planet alloc] initWithPeriod:JUPITER_PERIOD andRadius:TARGET_RADIUS atDistance:JUPITER_DISTANCE andTheta:0.0 andMass:JUPITER_MASS andImageView:self.giantPlanetImageView andName:@"Jupiter"];
        [gGlobal.simulator  addPlanet:thisPlanet];
        
        thisPlanet = [[Planet alloc] initWithPeriod:TARGET_PERIOD andRadius:TARGET_RADIUS atDistance:TARGET_DISTANCE andTheta:0.0 andMass:TARGET_MASS andImageView:self.terrestialPlanetImageView andName:@"Earth"];
        [gGlobal.simulator  addPlanet:thisPlanet];
        
        //  Add the Projectiles
        Projectile *thisProjectile = [[Projectile alloc] initWithX:-self.starView.displayScale/2 andY:_initialOffset andVX:_initialVelocity andVY:0.0];
        [gGlobal.simulator addProjectile:thisProjectile];
        
        //  Step the Simulator to get in Drawn
        [gGlobal.simulator  step];
        
        [self.starView setHidden:NO];
        [self.startSimulationButton setTitle:@"Stop"];
        [self.mainWindow makeFirstResponder:nil];
        [self.pauseSimulationButton setHidden:NO];
     }
    
}

#pragma mark timer

unsigned long simulatorSteps = 0;

- (void) timerHandler:(NSTimer *)timer
{
    if( _bSimulating == NO )
        return;
    
    NSLog(@"%lu simulator steps", simulatorSteps++);
    [gGlobal.simulator step];
}

- (void) displayTimerHandler:(NSTimer *)timer
{
    if( _bSimulating == NO )
        return;
    
    [self.starView setNeedsDisplay:YES];
}


@end
