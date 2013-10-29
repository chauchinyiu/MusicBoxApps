//
//  AniVerticalGear.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月23日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniVerticalGear.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniVerticalGear

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:timeUnits];
    }
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        rotateAmt += angle * 9.2f;
        while (rotateAmt > 6.0f) {
            rotateAmt -= 6.0f;
        }
    }
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:gearbg];
    for (int i = 0; i < 21; i++) {
        teeth[i].y = 1.0f - ((objY + (6.0f / 2.0f) + (6.0f * i) - rotateAmt) / STD_HEIGHT) * 2.0f;
        [[MusicBoxViewController sharedInstance] addAnimationObject:teeth[i]];
    }
    [[MusicBoxViewController sharedInstance] addAnimationObject:gearmask];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    objY = y;
    gearbg.w = (8.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    gearbg.h = (126.0f / STD_HEIGHT) * 2.0f;
    gearbg.x = ((x + (8.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    gearbg.y = 1.0f - ((y + (126.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    gearbg.r = 0.0f;
    
    gearbg.textCoordx1 = 0.0f;
    gearbg.textCoordy1 = 0.0f;
    gearbg.textCoordx2 = 16.0f/64.0f;
    gearbg.textCoordy2 = 251.0f/256.0f;
    gearbg.textID = TEXTURE_VGEAR;
    gearbg.visible = TRUE;
    gearbg.alpha = 1.0f;
    gearbg.followShift = true;
    
    
    gearmask.w = (9.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    gearmask.h = (126.0f / STD_HEIGHT) * 2.0f;
    gearmask.x = ((x + (9.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    gearmask.y = 1.0f - ((y + (126.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    gearmask.r = 0.0f;
    
    gearmask.textCoordx1 = 16.0f/64.0f;
    gearmask.textCoordy1 = 0.0f;
    gearmask.textCoordx2 = (16.0f + 18.0f)/64.0f;
    gearmask.textCoordy2 = 251.0f/256.0f;
    gearmask.textID = TEXTURE_VGEAR;
    gearmask.visible = TRUE;
    gearmask.alpha = 1.0f;
    gearmask.followShift = true;
    
    
    for (int i = 0; i < 21; i++) {
        teeth[i].w = (8.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
        teeth[i].h = (6.0f / STD_HEIGHT) * 2.0f;
        teeth[i].x = ((x + (8.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
        teeth[i].r = 0.0f;
        
        teeth[i].textCoordx1 = (16.0f + 18.0f)/64.0f;
        teeth[i].textCoordy1 = 0.0f;
        teeth[i].textCoordx2 = (16.0f + 18.0f + 16.0f)/64.0f;
        teeth[i].textCoordy2 = 12.0f/256.0f;
        teeth[i].textID = TEXTURE_VGEAR;
        teeth[i].visible = TRUE;
        teeth[i].alpha = 1.0f;
        teeth[i].followShift = true;
        
    }
    rotateAmt = 0;
    
    return self;
}

@end
