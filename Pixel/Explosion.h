//
//  Explosion.h
//  Pixel
//
//  Created by Jitesh Maiyuran on 7/4/14.
//  Copyright (c) 2014 Jitesh Maiyuran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Explosion <NSObject>

- (void)createExplosionAtX:(int) x andY:(int) y removeSelf:(id) bomb;
@end
