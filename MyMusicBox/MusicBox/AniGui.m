//
//  AniGui.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月17日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniGui.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

#define ANIMATION_STATE_NONE        0
#define ANIMATION_STATE_MOVE_DOWN   1
#define ANIMATION_STATE_MOVE_UP     2


@implementation AniGui

GLfloat initY;

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    [self handleRotate:timeUnits];
}

-(void)handleRotate:(GLfloat)angle{
    if (animationState == ANIMATION_STATE_MOVE_DOWN) {
        waitTime += angle;
        pullDownButton.y -= (angle * 43.0f / 1.5f / STD_HEIGHT) * 2.0f;
        playButton.y -= (angle * 43.0f / 1.5f / STD_HEIGHT) * 2.0f;
        if (waitTime >= 1.5f) {
            animationState = ANIMATION_STATE_NONE;
            pullDownButton.y = 1.0f - ((129.0f / 2.0f) / STD_HEIGHT) * 2.0f;
            playButton.y = 1.0f - ((66.0f / 2.0f) / STD_HEIGHT) * 2.0f;

            pullDownButton.textCoordy1 = 128.0f/256.0f;
            pullDownButton.textCoordy2 = (128.0f + 42.0f)/256.0f;
        }
    }
    else if (animationState == ANIMATION_STATE_MOVE_UP) {
        waitTime += angle;
        pullDownButton.y += (angle * 43.0f / 1.5f / STD_HEIGHT) * 2.0f;
        playButton.y += (angle * 43.0f / 1.5f / STD_HEIGHT) * 2.0f;
        if (waitTime >= 1.5f) {
            animationState = ANIMATION_STATE_NONE;
            pullDownButton.y = 1.0f - ((43.0f / 2.0f) / STD_HEIGHT) * 2.0f;
            playButton.y = 1.0f + ((20.0f / 2.0f) / STD_HEIGHT) * 2.0f;
            
            pullDownButton.textCoordy1 = 86.0f/256.0f;
            pullDownButton.textCoordy2 = 128.0f/256.0f;
        }
    }

}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:playButton];
    [[MusicBoxViewController sharedInstance] addAnimationObject:pullDownButton];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    pullDownButton.w = 64.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
    pullDownButton.h = (21.0f / STD_HEIGHT) * 2.0f;
//    pullDownButton.x = ((180.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) *2.0f - 1.0f;
    pullDownButton.x =(IS_IPHONE_5 ? -0.65f : -0.65f ) ;
    pullDownButton.y = 1.0f - ((43.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    pullDownButton.r = 0.0f;
    
    pullDownButton.textCoordx1 = 0.0f;
    pullDownButton.textCoordy1 = 86.0f/256.0f;
    pullDownButton.textCoordx2 = 1.0f;
    pullDownButton.textCoordy2 = 128.0f/256.0f;
    pullDownButton.textID = TEXTURE_PLAY_GUI;
    pullDownButton.visible = false;
    pullDownButton.alpha = 1.0f;
    pullDownButton.followShift = false;

    playButton.w = 64.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
    playButton.h = (43.0f / STD_HEIGHT) * 2.0f;
//    playButton.x =((180.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    playButton.x = (IS_IPHONE_5 ? -0.65f : -0.65f);
    playButton.y = 1.0f + ((20.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    playButton.r = 0.0f;
    
    playButton.textCoordx1 = 0.0f;
    playButton.textCoordy1 = 0.0f;
    playButton.textCoordx2 = 1.0f;
    playButton.textCoordy2 = 86.0f/256.0f;
    playButton.textID = TEXTURE_PLAY_GUI;
    playButton.visible = TRUE;
    playButton.alpha = 1.0f;
    playButton.followShift = false;
    
    animationState = ANIMATION_STATE_NONE;
     
    return self;
}

-(void)showPullDown:(BOOL)isVisible{
    if (isVisible) {
        pullDownButton.visible = true;
    }
    else{
        pullDownButton.visible = false;
    }
}

-(void)pullDownPlayButton{
    waitTime = 0.0f;
    pullDownButton.y = 1.0f - ((43.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    playButton.y = 1.0f + ((20.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    animationState = ANIMATION_STATE_MOVE_DOWN;
}

-(void)returnPlayButton{
    waitTime = 0.0f;
    pullDownButton.y = 1.0f - ((129.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    playButton.y = 1.0f - ((66.0f / 2.0f) / STD_HEIGHT) * 2.0f;
    animationState = ANIMATION_STATE_MOVE_UP;
}

-(void)clickPlayButton{
}


@end
