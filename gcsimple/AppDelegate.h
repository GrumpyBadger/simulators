//
//  AppDelegate.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/14/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StarView.h"
#import "Simulator.h"

@class GCSGlobal;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSButton *startSimulationButton;
@property (weak) IBOutlet NSButton *pauseSimulationButton;

@property (weak) IBOutlet NSTextField *initialVelocityText;
@property (weak) IBOutlet NSTextField *initialOffsetText;
@property (weak) IBOutlet NSTextField *initialDistanceText;
@property (weak) IBOutlet NSTextField *timeIncrementText;

@property (weak) IBOutlet NSTextField *displayScaleText;

@property (strong, nonatomic) IBOutlet StarView *starView;
@property (strong, nonatomic) IBOutlet NSImageView *starImageView;
@property (strong, nonatomic) IBOutlet NSImageView *giantPlanetImageView;
@property (strong, nonatomic) IBOutlet NSImageView *terrestialPlanetImageView;

@property (weak) IBOutlet NSWindow *mainWindow;

- (IBAction)startSimulation:(id)sender;
- (IBAction)pauseSimulation:(id)sender;

//  Magic Parameters
#define METERS_PER_AU   1.5E11          //  (m) 150M km
#define TARGET_RADIUS   6.0E6           // Earth Radius (m)
#define TARGET_MASS     6.0E24          // Earth Mass (kg)
#define TARGET_DISTANCE 1               // Earth's Distance to Star (AU)
#define TARGET_PERIOD   (365*24*3600)     // Earth's orbital period

#define JUPITER_MASS        2.0E27          // Jupiter Mass (kg)
#define JUPITER_DISTANCE    6           // Jupiter's Distance to Star (AU)
#define JUPITER_PERIOD      (11.8618*365*24*3600) // Jupiter's orbital period

#define STAR_RADIUS     7.0E8           // Star's Radius (m)
#define STAR_MASS       2.0E30          // Star's Mass (kg)

#define UGC             6.67E-11        // Universal Gravitational Constant

#define TARGET_FORCE    (UGC * TARGET_MASS) //  G x Mass of Target
#define STAR_FORCE      (UGC * STAR_MASS)   //  G x Mass of Star

//
//  Our first attempts at simulation assume that all the planets around the target star are coplanar and move in circular orbits and that
//  the seed is also coplanar with them as it approaches. We assume only two planets (one target orbiting at 1AU and of the Earth's Mass). A Jupiter mass and
//  sized planet orbiting at 6AU and the star itself which is identical to the Sun.
//
//  The x direction is a line between the target star and our sun and each seed approaches in that direction initially and coplanar with the planets.
//  The y direction is coplanar with the star's planets and perpedicular to the x direction and
//  clockwise wrt x. The z-direction (later) is perpendicular to the x and y directions in a right handed manner So x is positive and decreasing as the seed
//  approaches the star and negative and increasing in magnitude at it recedes. The y and z offsets can be positive (to the left or upward respectively) or
//  negative.
//
//  The force acting on the seed has: a magnitude and a direction defined by two angles theta and phi. Theta is the angle in the x-y plane
//  between the x axis and the direction of the seed in a clockwise manner. Phi is the angle, in the x-z plane. For the first simulations phi is zero.
//
//  Seeds approach in the plane of the planets with an initialy velocity and an offsets X & Y, the offset Z is zero in the first simulations.
//
//  Initially the planets are placed in orbit randomly around the target star. This is therefore a four body problem. Each seed is initialized wrt to Y and it is
//  assumed to have a negligible mass. At each step the force is calculated between the seed, the planets and target star and the position of the seed is updated.
//  Then the planets and the target star are adjusted wrt each other and the step is repeated. The interactions between the planets are ignored. All the plannets are
//  assumed to orbit in a clockwise direction. Furthemore we assume that the planets move at uniform spped in circular orbits.
//
//  Seeds continue until they impact the star or a planet. Impact occurs if the seed approaches the target within one radius.

@end

extern GCSGlobal *gGlobal;

