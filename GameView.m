//
//  GameView.m
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/1/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import "GameView.h"
#import <QuartzCore/QuartzCore.h>
#import "ExplodingBlock.h"
#import "SuperBlock.h"

@interface GameView()

@property (nonatomic) Player *hero;
@property (strong, nonatomic) NSMutableArray *blocks;
@property (nonatomic) int blockNum;
@property (nonatomic) int scorePlus;
@property (nonatomic) int score;
@property (nonatomic) int highScore;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *highScoreLabel;
@property (strong, nonatomic) NSMutableArray *fragments;
@property (nonatomic) NSTimer *introTimer;
@property (nonatomic) int spawnFlag;
@property (nonatomic) NSMutableArray *storeBombsDuringPause;

@end

@implementation GameView

@synthesize storeBombsDuringPause = _storeBombsDuringPause;
@synthesize spawnFlag = _spawnFlag;
@synthesize introTimer = _introTimer;
@synthesize hero = _hero;
@synthesize blocks = _blocks;
@synthesize blockNum = _blockNum;
@synthesize scorePlus = _scorePlus;
@synthesize score = _score;
@synthesize scoreLabel = _scoreLabel;
@synthesize highScoreLabel = _highScoreLabel;
@synthesize highScore = _highScore;
@synthesize timer = _timer;
@synthesize fragments = _fragments;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        //[self setGame];
        [self createIntro];
        
    }
    return self;
    
}

-(void)createExplosionAtX:(int)x andY:(int)y removeSelf:(id)bomb
{
    int explosivenum = 0;
        for(Player * p in self.blocks)
        {
            if([p isKindOfClass:[ExplodingBlock class]])
                explosivenum++;
            
        }
    for(int i = 0; i < 5; i++)
    {
        
        Player *fragmentLayer = [[Player alloc] init];
        fragmentLayer.yv = -1 * (arc4random() % 25);
        
        fragmentLayer.xv = (arc4random() % 2 ? 1 : -1) * (arc4random() % 13);
        
        [fragmentLayer setupSizeWithX:x andY:y];
        fragmentLayer.frame = CGRectMake(x, y, 2, 2);
        fragmentLayer.backgroundColor = [[UIColor blackColor] CGColor];
        
        [self.layer addSublayer:fragmentLayer];
        [self.fragments addObject:fragmentLayer];
    }
    [self.blocks removeObject:bomb];
    
}
- (void)addIntroBlock
{
    if(!self.spawnFlag)
        self.spawnFlag = 0;
    self.spawnFlag++;

    if(self.spawnFlag == 10)
    {
        int loc = (arc4random() % ((int)self.frame.size.width));
        Player *p = [[Player alloc] init];
        [p setupSizeWithX:loc andY:-5];
        [self.blocks addObject:p];
        [self.layer addSublayer:p];
        p.yv = arc4random() % 5 + 2;
        if (self.spawnFlag == 10) {
            self.spawnFlag = 0;
            
        }
    }
    
    
    for(int i = 0; i < self.blocks.count; i++)
    {
        Player *p = [self.blocks objectAtIndex:i];
        [p setPosition:CGPointMake(p.position.x, p.position.y + p.yv)];
        if(p.position.y > self.frame.size.height + 10)
         {
             [p removeFromSuperlayer];
             [self.blocks removeObject:p];
             i--;
         }
    }
    
}
- (void)createIntro
{
    self.blocks = [[NSMutableArray alloc] init];
    self.introTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addIntroBlock) userInfo:nil repeats:YES];
    

    UITextView *title = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width , 200)];
    [self addSubview:title];
    title.text = @"Pixel Pass";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Courier" size:100];
    //title.backgroundColor = [UIColor blueColor];
    title.editable = NO;
    
    UITextView *highScore = [[UITextView alloc] initWithFrame:CGRectMake(0,275, self.frame.size.width , 70)];
    [self addSubview:highScore];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"])
        highScore.text = [@"HIGH SCORE: " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"]];
    else
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"highScore"];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.font = [UIFont fontWithName:@"Courier" size:30];
    //highScore.backgroundColor = [UIColor redColor];
    highScore.editable = NO;
    
    UIButton *begin = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 375, self.frame.size.width / 2, 75)];
    [self addSubview:begin];
    [begin setTitle:@"BEGIN" forState:UIControlStateNormal];
    begin.layer.cornerRadius = 10;
    begin.clipsToBounds = YES;
    begin.titleLabel.font = [UIFont fontWithName:@"Courier" size:30];
    begin.backgroundColor = [UIColor blackColor];
    [begin addTarget:self action:@selector(initGame) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)initGame
{
    [self.introTimer invalidate];
    [self.blocks makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.blocks removeAllObjects];
    for(int i = 0; i < self.subviews.count; i++)
    {
        UIView *view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        i--;
    }
    self.fragments = [NSMutableArray array];

    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, self.frame.size.width , 60)];
    [self addSubview:self.scoreLabel];
    self.scoreLabel.text = @"0";
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.font = [UIFont fontWithName:@"Courier" size:72];
    
    self.highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 60)];
    [self addSubview:self.highScoreLabel];
    self.highScoreLabel.text = @"0";
    self.highScoreLabel.textAlignment = NSTextAlignmentLeft;
    self.highScoreLabel.font = [UIFont fontWithName:@"Courier" size:12];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"])
    {
        self.highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"] integerValue];
        self.highScoreLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
    }
    else
        self.highScoreLabel.text = @"0";
    
    self.hero = [[Player alloc] init];

    
    self.score = 0;
    self.scorePlus = 0;
    self.blockNum = 60;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    UITapGestureRecognizer *pause = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pause)];
    pause.numberOfTapsRequired = 2;
    [self addGestureRecognizer:pause];
    
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    [self addGestureRecognizer:swipeDown];
    [self addGestureRecognizer:swipeUp];
    
    [self setGame];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    


}

- (void)pause
{
    [self.timer invalidate];
    if(!self.storeBombsDuringPause)
        self.storeBombsDuringPause = [NSMutableArray array];
    UIButton *begin = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 375, self.frame.size.width / 2, 75)];
    [self addSubview:begin];
    [begin setTitle:@"CONTINUE" forState:UIControlStateNormal];
    begin.layer.cornerRadius = 10;
    begin.clipsToBounds = YES;
    begin.titleLabel.font = [UIFont fontWithName:@"Courier" size:30];
    begin.backgroundColor = [UIColor blackColor];
    [begin addTarget:self action:@selector(continu) forControlEvents:UIControlEventTouchUpInside];
    for(Player *p in self.blocks) {
        if([p isKindOfClass:[ExplodingBlock class]]) {
            ExplodingBlock *b = (ExplodingBlock *)p;
            [b.timer invalidate];
            
            [self.storeBombsDuringPause addObject:[NSNumber numberWithInt:b.secondsTillExplosion]];
            
        }
    } 
}

-  (void)continu
{
    [[self.subviews lastObject] removeFromSuperview];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    for(Player *p in self.blocks) {
        if([p isKindOfClass:[ExplodingBlock class]]) {
            ExplodingBlock *b = (ExplodingBlock *)p;
            b.secondsTillExplosion = [[self.storeBombsDuringPause firstObject] intValue];
            b.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:b selector:@selector(flash) userInfo:nil repeats:YES];
            
            [self.storeBombsDuringPause removeObjectAtIndex:0];
            
        }
    }
}

- (void)spawnHero
{

    [self.hero setupSizeWithX:self.frame.size.width/2 andY:25];

    [self.hero setBackgroundColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0].CGColor];
    self.hero.yv = 2;
    [self.layer addSublayer:self.hero];
}
- (void)populateEnemies
{
    BOOL setSuper = NO;
    for(int i = 0; i < self.blockNum; i++)
    {
         Player *newBlock = [[Player alloc] init];
        
        int x;
        int y;
        bool wontOverlap = NO;
        
        while (wontOverlap == NO)
        {
            wontOverlap = YES;
            
            x = ( + (arc4random() % ((int)self.frame.size.width)));
            y = (90 +(arc4random() %( (int)self.frame.size.height- 100)));
            
            [newBlock setupSizeWithX:x andY:y];

            for (Player *p in self.blocks)
            {
                CGRect expandedToCheckAdjacency = CGRectMake(newBlock.frame.origin.x - 3, newBlock.frame.origin.y - 3, newBlock.frame.size.width + 3, newBlock.frame.size.height + 3);
                if(CGRectIntersectsRect(p.frame, expandedToCheckAdjacency))
                    wontOverlap = NO;
                
            }
        }
        if(i % 31 == 0)
        {
            ExplodingBlock *exploder = [[ExplodingBlock alloc] init];
            exploder.enviro = self;
            [exploder setupSizeWithX:x andY:y];
            [exploder begin];
            [exploder setBackgroundColor:[UIColor blackColor].CGColor];
            [self.layer addSublayer:exploder];
            [self.blocks addObject:exploder];
            continue;
        }
        
        if(i % 29 == 0)
        {
            
            UIBezierPath *customPath = [UIBezierPath bezierPath];
            [customPath moveToPoint:CGPointMake(x, y)];
            [customPath addLineToPoint:CGPointMake(x + 50, y)];
            [customPath addLineToPoint:CGPointMake(x + 50, y + 50)];
            [customPath addLineToPoint:CGPointMake(x, y + 50)];
            [customPath addLineToPoint:CGPointMake(x, y)];
            
            newBlock.anchorPoint = CGPointZero;
            [self.layer addSublayer:newBlock];
            
            CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            pathAnimation.repeatCount = 10;
            pathAnimation.duration = arc4random() % 3 + 1;
            pathAnimation.path = customPath.CGPath;
            pathAnimation.calculationMode = kCAAnimationLinear;
            [newBlock addAnimation:pathAnimation forKey:@"movingAnimation"];
            [newBlock setBackgroundColor:[UIColor greenColor].CGColor];
            
            [self.blocks addObject:newBlock];
        }
        
        if(y < self.frame.size.height * 0.25 && !setSuper && (arc4random() % 10 == 7))
        {
            SuperBlock *superblock = [[SuperBlock alloc] init];
            [superblock setupSizeWithX:x andY:y];
            [superblock begin];
            [self.layer addSublayer:superblock];
            [self.blocks addObject:superblock];
            setSuper = YES;
            
        }
        else{
            
            [self.layer addSublayer:newBlock];
            [self.blocks addObject:newBlock];
        }
        
        


        
    }
}
- (void)leftSwipe
{
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"wush" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    
     if(self.hero.yv + self.hero.xv != 0)
        self.hero.xv = -30;


}

- (void)rightSwipe
{
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"whoosh" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    if(self.hero.yv + self.hero.xv != 0)
        self.hero.xv = 30;

}
- (void)downSwipe
{

    
    if(self.hero.yv + self.hero.xv != 0)
        self.hero.yv = 20;
}
- (void)upSwipe
{
    
    
    if(self.hero.yv + self.hero.xv != 0)
        self.hero.yv = 2;
}
- (void)updateGame
{
    [self.hero setPosition:CGPointMake(self.hero.position.x + self.hero.xv, self.hero.position.y + self.hero.yv)];
    if(self.hero.xv != 0)
        self.hero.xv = 0;
    if([self didCollide])
       [self resetGame];
    if(self.hero.position.y > self.frame.size.height)
        [self setGame];
    
    if(self.hero.position.x < 0)
    {
        self.hero.xv = -30;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        self.hero.position = CGPointMake(self.frame.size.width/* - (abs(self.hero.position.x))*/, self.hero.position.y);

        [CATransaction commit];
    }
    
    if(self.hero.position.x > self.frame.size.width)
    {
        self.hero.xv = 30;

        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        self.hero.position = CGPointMake(0/*self.hero.position.x - self.frame.size.width*/, self.hero.position.y);

        [CATransaction commit];
    }
    for(int i = 0; i < self.fragments.count; i++)
    {
        Player *p = [self.fragments objectAtIndex:i];
        [p setPosition:CGPointMake(p.position.x + p.xv, p.position.y + p.yv)];
        p.yv +=2;
        if(p.position.y > self.frame.size.height + 100)
        {
           [self.fragments removeObject:p];
            [p removeFromSuperlayer];
        }
        
    }
    
    
    self.score += self.scorePlus * (self.hero.yv == 20 ? 2 : 1);
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
    
    
}
- (void)resetGame
{
    NSLog(@"length is %i, %i, %i", self.fragments.count, self.blocks.count, self.storeBombsDuringPause.count);
    if(self.score > self.highScore)
    {
        
        self.highScore = self.score;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", self.highScore] forKey:@"highScore"];
        self.highScoreLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.scorePlus = 0;
    self.blockNum = 60;
    UIButton *restart = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 200, self.frame.size.width / 2, 75)];
    [self addSubview:restart];
    [restart setTitle:@"RESTART" forState:UIControlStateNormal];
    restart.layer.cornerRadius = 10;
    restart.clipsToBounds = YES;
    restart.titleLabel.font = [UIFont fontWithName:@"Courier" size:30];
    restart.backgroundColor = [UIColor blackColor];
    [restart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
}
- (void)restart
{
    NSLog(@"Hello");
    self.score = 0;
    [self setGame];
}

-(void) cueSuperMode
{
    int spacesAlongLine = 0;
    int y = self.frame.size.height * 0.8;
    double randomSpace = (arc4random() % 70 + 10) / 100.0;
    NSMutableArray *toAdd = [NSMutableArray array];
    BOOL flag = NO;
    for(int i = 0; i < self.blocks.count; i++)
    {
        Player *p = [self.blocks objectAtIndex:i];
        
        if([p isKindOfClass:[ExplodingBlock class] ])
        {
            ExplodingBlock *expb = (ExplodingBlock *)p;
            [self.blocks removeObject:p];
            [expb.timer invalidate];
            [p removeFromSuperlayer];
            i--;
            continue;
        }
        
        spacesAlongLine += 4;
        
        if(spacesAlongLine < self.frame.size.width * (0.1 +randomSpace) && spacesAlongLine > self.frame.size.width * randomSpace)
        {
            [p setPosition:CGPointMake(0, y)];
            ExplodingBlock *exploder = [[ExplodingBlock alloc] init];
            exploder.enviro = self;
            [exploder setupSizeWithX:spacesAlongLine andY:y];
            [exploder begin];
            exploder.secondsTillExplosion = 4;
            flag = !flag;
            [toAdd addObject:exploder];
            [self.layer addSublayer:exploder];
        }
        else {
            [p removeAllAnimations];
            [p setPosition:CGPointMake(spacesAlongLine, y)];

        }
            
    }
    while(spacesAlongLine < self.frame.size.width)
    {
        Player *p = [[Player alloc] init];
        [p setupSizeWithX:spacesAlongLine andY:y];
        spacesAlongLine += 4;
        [self.blocks addObject:p];
        [self.layer addSublayer:p];
    }
    for(ExplodingBlock *expB in toAdd)
        [self.blocks addObject:expB];
}

- (bool)didCollide
{
    for(int i = 0; i < self.blocks.count; i++)
    {
        Player *p = [self.blocks objectAtIndex:i];
        CALayer *pLayer = (CALayer *)self.hero.presentationLayer;
        CALayer *blockLayer = (CALayer *)p.presentationLayer;
        if(CGRectIntersectsRect(pLayer.frame, blockLayer.frame))
        {

            if([p isKindOfClass:[SuperBlock class]])
            {
                self.score += 1000;
                [p removeFromSuperlayer];
                [self.blocks removeObject:p];
                i--;
                [self cueSuperMode];
                return NO;
            }
            self.hero.yv = 0;

            return YES;
        }
    }
    for(Player *p in self.fragments)
    {
        CALayer *pLayer = (CALayer *)self.hero.presentationLayer;
        CALayer *blockLayer = (CALayer *)p.presentationLayer;
        if(CGRectIntersectsRect(pLayer.frame, blockLayer.frame))
        {
            self.hero.yv = 0;
            return YES;
        }
    }
    return NO;
}

- (void)setGame

{

    for(int i = 0; i < self.subviews.count; i++)
    {
        UIView *view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        i--;
    }
    self.blockNum *= 1.2;
    [self.scoreLabel removeFromSuperview];
    [self.highScoreLabel removeFromSuperview];

    for(int i = 0; i < self.blocks.count; i++)
    {
        Player *p = [self.blocks objectAtIndex:i];
        if([p isKindOfClass:[ExplodingBlock class]])
        {
            ExplodingBlock *expB = (ExplodingBlock *)p;
            [expB.timer invalidate];
        }
        [self.blocks removeObject:p];
        i--;
        
    }
    self.scorePlus++;
    
    for(int i = 0; i < self.layer.sublayers.count; i++)
    {
        [[self.layer.sublayers objectAtIndex:i] removeFromSuperlayer];
        i--;
    }
    [self.fragments removeAllObjects];
    
    
    [self populateEnemies];
    [self spawnHero];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.highScoreLabel];

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
