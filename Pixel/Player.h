//
//  Player.h
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/1/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : CALayer
@property (nonatomic) int xv;
@property (nonatomic) int yv;
- (void) setupSizeWithX:(int) x andY:(int) y;
@end
