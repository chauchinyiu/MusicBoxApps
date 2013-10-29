//
//  AniDarkScreen.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年7月9日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniDarkScreen.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniDarkScreen
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
}

-(void)handleRotate:(GLfloat)angle{
}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:photoFrame];
}

-(id)init{
    photoFrame.w = 2.0f;
    photoFrame.h = 2.0f;
    photoFrame.x = 0.0f;
    photoFrame.y = 0.0f;
    photoFrame.r = 0.0f;
    
    photoFrame.textCoordx1 = 1.0f/2048.0f;
    photoFrame.textCoordy1 = (640.0f + 178.0f + 1.0f)/1024.0f;
    photoFrame.textCoordx2 = 7.0f/2048.0f;
    photoFrame.textCoordy2 = (640.0f + 178.0f + 7.0f)/1024.0f;
    photoFrame.textID = TEXTURE_ANI_STYLE;
    photoFrame.visible = FALSE;
    photoFrame.alpha = 1.0f;
    return self;
}

-(void)darkenScreen:(BOOL)darken{
    photoFrame.visible = darken;
}

@end
