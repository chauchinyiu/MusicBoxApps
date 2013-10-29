//
//  AniVerticalGear.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月23日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniVerticalGear : NSObject<AnimationGroup>{
    AnimationObject gearbg;
    AnimationObject gearmask;
    AnimationObject teeth[21];
    GLfloat rotateAmt;
    GLfloat objY;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
@end

