//
//  AniGui.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月17日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"



@interface AniGui : NSObject<AnimationGroup>{
    AnimationObject playButton;
    AnimationObject pullDownButton;
    float waitTime;
    int animationState;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)showPullDown:(BOOL)isVisible;
-(void)pullDownPlayButton;
-(void)returnPlayButton;
-(void)clickPlayButton;

@end
