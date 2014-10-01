//
//  PixelViewController.m
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/1/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "PixelViewController.h"

@interface PixelViewController ()

@end

@implementation PixelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    GameView *game = [[GameView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:game];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
