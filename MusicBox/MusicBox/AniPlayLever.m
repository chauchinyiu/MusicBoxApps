//
//  AniPlayLever.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月26日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniPlayLever.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniPlayLever
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:(timeUnits * M_PI / 10.0f)];
    }
}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:circle];
    [[MusicBoxViewController sharedInstance] addAnimationObject:playShadow];
    [[MusicBoxViewController sharedInstance] addAnimationObject:playLeverShadow];
    [[MusicBoxViewController sharedInstance] addAnimationObject:playLever];
    [[MusicBoxViewController sharedInstance] addAnimationObject:playBtnBg];
    [[MusicBoxViewController sharedInstance] addAnimationObject:playBtn];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    objX = x;
    objY = y;

    circle.w = (124.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    circle.h = (124.0f / STD_HEIGHT) * 2.0f;
    circle.x = (x / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    circle.y = 1.0f - (y / STD_HEIGHT) * 2.0f;
    circle.r = 0.0f;
    
    circle.textCoordx1 = 0.0f;
    circle.textCoordy1 = 0.0f;
    circle.textCoordx2 = 247.0f/512.0f;
    circle.textCoordy2 = 247.0f/512.0f;
    circle.textID = TEXTURE_PLAY;
    circle.visible = TRUE;
    
    playShadow.w = (50.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    playShadow.h = (85.0f / STD_HEIGHT) * 2.0f;
    playShadow.x = (x / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    playShadow.y = 1.0f - ((y - 20.0f) / STD_HEIGHT) * 2.0f;
    playShadow.r = 0.0f;
    
    playShadow.textCoordx1 = 247.0f/512.0f;
    playShadow.textCoordy1 = 0.0f;
    playShadow.textCoordx2 = (247.0f + 99.0f)/512.0f;
    playShadow.textCoordy2 = 170.0f/512.0f;
    playShadow.textID = TEXTURE_PLAY;
    playShadow.visible = TRUE;
    

    playLeverShadow.w = (68.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    playLeverShadow.h = (48.0f / STD_HEIGHT) * 2.0f;
    
    playLeverShadow.textCoordx1 = (247.0f + 99.0f)/512.0f;
    playLeverShadow.textCoordy1 = 0.0f;
    playLeverShadow.textCoordx2 = (247.0f + 99.0f + 136.0f)/512.0f;
    playLeverShadow.textCoordy2 = 95.0f/512.0f;
    playLeverShadow.textID = TEXTURE_PLAY;
    playLeverShadow.visible = TRUE;

    playLever.w = (89.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    playLever.h = (22.0f / STD_HEIGHT) * 2.0f;
    
    playLever.textCoordx1 = 0.0f;
    playLever.textCoordy1 = 247.0f/512.0f;
    playLever.textCoordx2 = 177.0f/512.0f;
    playLever.textCoordy2 = (247.0f + 44.0f)/512.0f;
    playLever.textID = TEXTURE_PLAY;
    playLever.visible = TRUE;
    
    playBtnBg.w = (45.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    playBtnBg.h = (45.0f / STD_HEIGHT) * 2.0f;
    playBtnBg.x = (x / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    playBtnBg.y = 1.0f - (y / STD_HEIGHT) * 2.0f;
    playBtnBg.r = 0.0f;
    
    playBtnBg.textCoordx1 = 0.0f;
    playBtnBg.textCoordy1 = (247.0f + 44.0f)/512.0f;
    playBtnBg.textCoordx2 = 90.0f/512.0f;
    playBtnBg.textCoordy2 = (247.0f + 44.0f + 90.0f)/512.0f;
    playBtnBg.textID = TEXTURE_PLAY;
    playBtnBg.visible = TRUE;

    playBtn.w = (42.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    playBtn.h = (42.0f / STD_HEIGHT) * 2.0f;
    playBtn.x = (x / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    playBtn.y = 1.0f - (y / STD_HEIGHT) * 2.0f;
    playBtn.r = 0.0f;
    
    playBtn.textCoordx1 = (247.0f + 99.0f)/512.0f;
    playBtn.textCoordy1 = 95.0f/512.0f;
    playBtn.textCoordx2 = (247.0f + 99.0f + 83.0f)/512.0f;
    playBtn.textCoordy2 = (95.0f + 83.0f)/512.0f;
    playBtn.textID = TEXTURE_PLAY;
    playBtn.visible = TRUE;

    [self resetRotationPosition];
    return self;
}

-(void)changeAutoPlay:(BOOL)isplaying ButtonPressed:(BOOL)ispressed{
    if (isplaying) {
        playBtn.textCoordx1 = (247.0f + 99.0f + 83.0f)/512.0f;
        playBtn.textCoordx2 = (247.0f + 99.0f + 83.0f + 83.0f)/512.0f;
    }
    else{
        playBtn.textCoordx1 = (247.0f + 99.0f)/512.0f;
        playBtn.textCoordx2 = (247.0f + 99.0f + 83.0f)/512.0f;
    }
    if (ispressed) {
        playBtn.textCoordy1 = (95.0f + 83.0f)/512.0f;
        playBtn.textCoordy2 = (95.0f + 83.0f + 83.0f)/512.0f;
    }
    else{
        playBtn.textCoordy1 = 95.0f/512.0f;
        playBtn.textCoordy2 = (95.0f + 83.0f)/512.0f;
    }

}

-(void)resetRotationPosition{
    playLever.r = -M_PI / 2.0f;
    playLeverShadow.r = -M_PI / 2.0f;
    [self refreshLeverPost];
}

-(void)refreshLeverPost{
    playLeverShadow.x = ((objX - cosf(playLeverShadow.r) * 20.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    playLeverShadow.y = 1.0f - ((objY + sinf(playLeverShadow.r) * 20.0f) / STD_HEIGHT) * 2.0f;
    playLever.x = playLeverShadow.x;
    playLever.y = playLeverShadow.y;
}

-(void)handleRotate:(GLfloat)angle{

    playLever.r -= angle;
    if (playLeverShadow.r < -2 * M_PI) {
        playLeverShadow.r += 2 * M_PI;
    }
    if (playLeverShadow.r > 2 * M_PI) {
        playLeverShadow.r -= 2 * M_PI;
    }
    
    playLeverShadow.r = playLever.r;
    [self refreshLeverPost];
    
}
@end
