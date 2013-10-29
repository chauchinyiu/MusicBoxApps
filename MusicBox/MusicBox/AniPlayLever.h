//
//  AniPlayLever.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月26日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniPlayLever: NSObject<AnimationGroup>{
    AnimationObject circle;
    AnimationObject playShadow;
    AnimationObject playLeverShadow;
    AnimationObject playLever;
    AnimationObject playBtnBg;
    AnimationObject playBtn;
    GLfloat objY;
    GLfloat objX;
    
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)changeAutoPlay:(BOOL)isplaying ButtonPressed:(BOOL)ispressed;
-(void)resetRotationPosition;
-(void)refreshLeverPost;

@end

