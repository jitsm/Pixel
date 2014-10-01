//
//  ExplodingBlock.m
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/4/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "ExplodingBlock.h"

@interface ExplodingBlock()

@end
@implementation ExplodingBlock

@synthesize timer = _timer;
@synthesize colorFlag = _colorFlag;
@synthesize enviro = _enviro;
@synthesize secondsTillExplosion = _secondsTillExplosion;
@synthesize fastTimer = _fastTimer;

- (void) begin
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(flash) userInfo:nil repeats:YES];
    self.secondsTillExplosion = (arc4random() % 5 + 6) * 2;

    self.colorFlag = 0;
}

- (void)flash
{
    if(self.secondsTillExplosion <= 6)
    {
        self.fastTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fastFlash) userInfo:nil repeats:YES];
    }
    if(self.colorFlag == 0)
    {
        self.colorFlag = 1;
        self.backgroundColor = [UIColor whiteColor].CGColor;
    }
    else{
        self.colorFlag = 0;
        self.backgroundColor = [UIColor blackColor].CGColor;

    }
    self.secondsTillExplosion--;
    if(self.secondsTillExplosion <= 0)
    {
        [self.enviro createExplosionAtX:self.position.x andY:self.position.y removeSelf:self];
        [self removeFromSuperlayer];
        [self.timer invalidate];
   
    }

}

-(void)fastFlash
{
    if(self.colorFlag == 0)
    {
        self.colorFlag = 1;
        self.backgroundColor = [UIColor whiteColor].CGColor;
    }
    else{
        self.colorFlag = 0;
        self.backgroundColor = [UIColor blackColor].CGColor;
        
    }
}


@end
