//
//  ExplodingBlock.h
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/4/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "Player.h"
#import "Explosion.h"

@interface ExplodingBlock : Player
@property (nonatomic) int colorFlag;
@property (nonatomic) NSTimer* timer;
@property (nonatomic) NSTimer* fastTimer;
@property (nonatomic) int secondsTillExplosion;
@property (nonatomic) NSTimer *detonator;
@property (nonatomic) id<Explosion> enviro;


- (void) begin;
- (void)flash;

@end
