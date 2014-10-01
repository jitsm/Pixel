//
//  SuperBlock.h
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/4/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "Player.h"

@interface SuperBlock : Player


@property (nonatomic) int colorFlag;
@property (nonatomic) NSTimer* timer;


- (void) begin;


@end
