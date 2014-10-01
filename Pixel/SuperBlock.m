//
//  SuperBlock.m
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/4/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "SuperBlock.h"

@implementation SuperBlock

@synthesize timer = _timer;
@synthesize colorFlag = _colorFlag;


- (void) begin
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(flash) userInfo:nil repeats:YES];
    self.colorFlag = 0;
}

- (void)flash
{

    
    switch (self.colorFlag)
    {
        case 1:
            self.backgroundColor = [UIColor redColor].CGColor;
            break;
        case 2:
            self.backgroundColor = [UIColor orangeColor].CGColor;
            break;
        case 3:
            self.backgroundColor = [UIColor yellowColor].CGColor;
            break;
        case 4:
            self.backgroundColor = [UIColor greenColor].CGColor;
            break;
        case 5:
            self.backgroundColor = [UIColor blueColor].CGColor;
            break;
        case 0:
            self.backgroundColor = [UIColor purpleColor].CGColor;
            break;
    }
    self.colorFlag++;
    self.colorFlag = (self.colorFlag > 5 ? 0 : self.colorFlag);
    

}


@end
