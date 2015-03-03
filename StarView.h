//
//  StarView.h
//  gcsimple
//
//  Created by Martin Dunsmuir on 2/28/15.
//  Copyright (c) 2015 Martin Dunsmuir. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StarView : NSView

@property (assign) double displayScale;
@property (weak) NSImageView *starImageView;

@end
