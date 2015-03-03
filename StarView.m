//
//  StarView.m
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/28/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import "StarView.h"
#import "AppDelegate.h"
#import "GCSGlobal.h"

@implementation StarView
{
}

- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor blueColor] set];
    [NSBezierPath fillRect: [self bounds]];
    
    [[NSColor whiteColor] set];
    [NSBezierPath strokeRect:[self bounds]];
    
    NSRect b = [self bounds];
    
//    NSLog(@"bounds = (%f, %f), (%f, %f)", b.origin.x, b.origin.y, b.size.width, b.size.height);
    
    NSPoint bottom = NSMakePoint((b.size.width/2), 0);
    NSPoint top = NSMakePoint((b.size.width/2), (b.size.height));
    NSPoint left = NSMakePoint(0, (b.size.height/2));
    NSPoint right = NSMakePoint(b.size.width, (b.size.height/2));
    
    [NSBezierPath strokeLineFromPoint:top toPoint:bottom];
    [NSBezierPath strokeLineFromPoint:right toPoint:left];
    
    NSBezierPath *thisPath = [NSBezierPath bezierPath];
    
    if( gGlobal.simulator.projectiles.count > 0)
    {        
        for( int pp=0; pp<gGlobal.simulator.projectiles.count; pp++ )
        {
            Projectile *thisProjectile = [gGlobal.simulator.projectiles objectAtIndex:pp];
            
//            NSLog(@"projectile has %lu points", (unsigned long)thisProjectile.points.count);
            
            for( int pi=0; pi<thisProjectile.points.count; pi++ )
            {
                NSPoint p = [[thisProjectile.points objectAtIndex:pi] pointValue];
                
                if( pi == 0 )
                {
//                    NSLog(@"moving to (%f, %f)", p.x, p.y);

                    [thisPath moveToPoint:p];
                }
                else
                {
//                    NSLog(@"line to (%f, %f)", p.x, p.y);
                    
                    [thisPath lineToPoint:p];
                }
            }
     
        }
    }
    
    [thisPath stroke];
    [self needsToDrawRect:b];

}

@end
