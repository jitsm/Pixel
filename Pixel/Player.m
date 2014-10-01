//
//  Player.m
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/1/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize xv = _xv;
@synthesize yv = _yv;

- (void) setupSizeWithX:(int) x andY:(int) y
{
    self.frame = CGRectMake(0, 0, 4, 4);
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    self.position = CGPointMake(x, y);
    [CATransaction commit];
    self.backgroundColor = [UIColor colorWithRed:1.0 green:67/255.0 blue:67/255.0 alpha:1.0].CGColor;
}
@end
