//
//  AniBackground.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniBackground.h"
#import "MusicBoxViewController.h"

@implementation AniBackground 


-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
}

-(void)handleRotate:(GLfloat)angle{
}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:bg];
}

-(id)init{
    bg.w = 2.0f;
    bg.h = 2.0f;
    bg.x = 0.0f;
    bg.y = 0.0f;
    bg.r = 0.0f;
    
    bg.textCoordx1 = 0.0f;
    bg.textCoordy1 = 0.0f;
    bg.textCoordx2 = 1136.0f/2048.0f;
    bg.textCoordy2 = 640.0f/1024.0f;
    bg.textID = TEXTURE_BG;
    bg.visible = TRUE;
    bg.alpha = 1.0f;
    bg.followShift = true;
    return self;
}
@end
