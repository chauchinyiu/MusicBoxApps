//
//  AniGear.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年5月3日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniGear.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniGear

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:timeUnits];
    }
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        gear1.r -= (angle * M_PI / 50.0f);
        if (gear1.r < -2 * M_PI) {
            gear1.r += 2 * M_PI;
        }
        gear2.r += (angle * M_PI / 10.0f);
        if (gear2.r > -2 * M_PI) {
            gear2.r -= 2 * M_PI;
        }
    }
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:gear1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:gear2];
    [[MusicBoxViewController sharedInstance] addAnimationObject:gearFrame];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    
    gear1.w = (86.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    gear1.h = (86.0f / STD_HEIGHT) * 2.0f;
    gear1.x = ((x - 70.0f + (86.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    gear1.y = 1.0f - ((y + 12.0f + (86.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    gear1.r = 0.0f;
    
    gear1.textCoordx1 = 0.0f;
    gear1.textCoordy1 = 0.0f;
    gear1.textCoordx2 = 171.0f/512.0f;
    gear1.textCoordy2 = 171.0f/256.0f;
    gear1.textID = TEXTURE_GEAR;
    gear1.visible = TRUE;
    
    gear2.w = (19.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    gear2.h = (19.0f / STD_HEIGHT) * 2.0f;
    gear2.x = ((x + 4.0f + (19.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    gear2.y = 1.0f - ((y + 76.0f + (19.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    gear2.r = 0.0f;
    
    gear2.textCoordx1 = 0.0f;
    gear2.textCoordy1 = 171.0f/256.0f;
    gear2.textCoordx2 = 37.0f/512.0f;
    gear2.textCoordy2 = (171.0f + 37.0f)/256.0f;
    gear2.textID = TEXTURE_GEAR;
    gear2.visible = TRUE;
    
    gearFrame.w = (63.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    gearFrame.h = (105.0f / STD_HEIGHT) * 2.0f;
    gearFrame.x = ((x - 25.0f + (63.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    gearFrame.y = 1.0f - ((y + 12.0f + (105.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    gearFrame.r = 0.0f;
    
    gearFrame.textCoordx1 = 171.0f/512.0f;
    gearFrame.textCoordy1 = 0.0f;
    gearFrame.textCoordx2 = (171.0f + 126.0f)/512.0f;
    gearFrame.textCoordy2 = 209.0f/256.0f;
    gearFrame.textID = TEXTURE_GEAR;
    gearFrame.visible = TRUE;
    
    return self;
}
@end
