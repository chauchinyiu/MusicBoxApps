//
//  AniPhotoStyle.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月7日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniPhotoStyle.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniPhotoStyle
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    [self handleRotate:timeUnits];
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        if (photoCount > 1) {            
            waitTime0 += angle;
            if (waitTime0 > 10.0f) {
                changePhoto0 += angle;
                if (changePhoto0 > 3.0f) {
                    if (photoCount == 2) {
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_0 :TEXTURE_ANI_STYLE_2_0];
                    }
                    else{
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_0 :TEXTURE_ANI_STYLE_3_0];
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_0 :TEXTURE_ANI_STYLE_2_0];
                    }
                    
                    [self initAnimation0];
                }
                else{
                    photo2.alpha = changePhoto0 / 3.0f;
                }
            }
            waitTime1 += angle;
            if (waitTime1 > 10.0f) {
                changePhoto1 += angle;
                if (changePhoto1 > 3.0f) {
                    if (photoCount == 2) {
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_1 :TEXTURE_ANI_STYLE_2_1];
                    }
                    else{
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_1 :TEXTURE_ANI_STYLE_3_1];
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_1 :TEXTURE_ANI_STYLE_2_1];
                    }
                    
                    [self initAnimation1];
                }
                else{
                    if (changePhoto1 < 1.5f) {
                        photo1A.w = fullWidth * (1.0 - (changePhoto1 / 1.5f));
                        photo1A.h = fullHeight * (1.0 - (changePhoto1 / 1.5f));
                    }
                    else{
                        photo2A.w = fullWidth * (changePhoto1 - 1.5f) / 1.5f;
                        photo2A.h = fullHeight * (changePhoto1 - 1.5f) / 1.5f;
                    }
                    
                }
            }
            waitTime2 += angle;
            if (waitTime2 > 10.0f) {
                changePhoto2 += angle;
                if (changePhoto2 > 6.0f) {
                    if (photoCount == 2) {
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_2 :TEXTURE_ANI_STYLE_2_2];
                    }
                    else{
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_2 :TEXTURE_ANI_STYLE_3_2];
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_ANI_STYLE_1_2 :TEXTURE_ANI_STYLE_2_2];
                    }
                    
                    [self initAnimation2];
                }
                else{
                    photo1B.textCoordx1 = 0.5f * changePhoto2 / 6.0f;
                    photo1B.textCoordx2 = 0.5f + (0.5f * changePhoto2 / 6.0f);
                    photo2B.textCoordx1 = (0.5f * changePhoto2 / 6.0f) - 0.5f;
                    photo2B.textCoordx2 = 0.5f * changePhoto2 / 6.0f;
                    
                }
            }
            
        }
    }
}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:photoFrame];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photoMSG];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo2];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo1A];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo2A];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo3A];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo1B];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photo2B];
}


-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    [[MusicBoxViewController sharedInstance]
     renderTextLocAutoSize:600 : 30 * 2
                        :[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
                        :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
                        :UITextAlignmentCenter
                        :NSLocalizedString(@"SELECT_TRANSITION", @"Ask the user to select a transition style")
                        :TEXTURE_ANI_MSG];


    fullWidth = (128.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    fullHeight = (128.0f / STD_HEIGHT) * 2.0f;
    
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
    photoFrame.visible = TRUE;
    photoFrame.alpha = 1.0f;
    photoFrame.followShift = true;

    photoMSG.w = 300.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
    photoMSG.h = (30.0f / STD_HEIGHT) * 2.0f;
    photoMSG.x = 0.0f;
    photoMSG.y = 1.0f - ((50.0f + 30.0f / 2.0f)/ STD_HEIGHT) * 2.0f;
    photoMSG.r = 0.0f;
    
    photoMSG.textCoordx1 = 0.0f;
    photoMSG.textCoordy1 = 0.0f;
    photoMSG.textCoordx2 = 600.0f / 1024.0f;
    photoMSG.textCoordy2 = 30.0f * 2.0f/64.0f;
    photoMSG.textID = TEXTURE_ANI_MSG;
    photoMSG.visible = TRUE;
    photoMSG.alpha = 1.0f;
    photoMSG.followShift = true;
    
    
    photo1.w = fullWidth;
    photo1.h = fullHeight;
    photo1.x = -0.66f;
    photo1.y = -0.3f;
    photo1.r = 0.0f;
    
    photo1.textCoordx1 = 0.0f;
    photo1.textCoordy1 = 0.0f;
    photo1.textCoordx2 = 0.5f;
    photo1.textCoordy2 = 1.0f;
    photo1.textID = TEXTURE_ANI_STYLE_1_0;
    photo1.visible = TRUE;
    photo1.alpha = 1.0f;
    photo1.followShift = true;
    
    photo2.w = fullWidth;
    photo2.h = fullHeight;
    photo2.x = -0.66f;
    photo2.y = -0.3f;
    photo2.r = 0.0f;
    
    photo2.textCoordx1 = 0.0f;
    photo2.textCoordy1 = 0.0f;
    photo2.textCoordx2 = 0.5f;
    photo2.textCoordy2 = 1.0f;
    photo2.textID = TEXTURE_ANI_STYLE_2_0;
    photo2.visible = TRUE;
    photo2.alpha = 1.0f;
    photo2.followShift = true;
    
    photo1A.w = fullWidth;
    photo1A.h = fullHeight;
    photo1A.x = 0.0F;
    photo1A.y = -0.3f;
    photo1A.r = 0.0f;
    
    photo1A.textCoordx1 = 0.0f;
    photo1A.textCoordy1 = 0.0f;
    photo1A.textCoordx2 = 0.5f;
    photo1A.textCoordy2 = 1.0f;
    photo1A.textID = TEXTURE_ANI_STYLE_1_1;
    photo1A.visible = TRUE;
    photo1A.alpha = 1.0f;
    photo1A.followShift = true;
    
    photo2A.w = fullWidth;
    photo2A.h = fullHeight;
    photo2A.x = 0.0f;
    photo2A.y = -0.3f;
    photo2A.r = 0.0f;
   
    photo2A.textCoordx1 = 0.0f;
    photo2A.textCoordy1 = 0.0f;
    photo2A.textCoordx2 = 0.5f;
    photo2A.textCoordy2 = 1.0f;
    photo2A.textID = TEXTURE_ANI_STYLE_2_1;
    photo2A.visible = TRUE;
    photo2A.alpha = 1.0f;
    photo2A.followShift = true;
    
    photo3A.w = fullWidth;
    photo3A.h = fullHeight;
    photo3A.x = 0.0f;
    photo3A.y = -0.3f;
    photo3A.r = 0.0f;
    
    photo3A.textCoordx1 = 1.0f/2048.0f;
    photo3A.textCoordy1 = (640.0f + 178.0f + 1.0f)/1024.0f;
    photo3A.textCoordx2 = 7.0f/2048.0f;
    photo3A.textCoordy2 = (640.0f + 178.0f + 7.0f)/1024.0f;
    photo3A.textID = TEXTURE_ANI_STYLE;
    photo3A.visible = TRUE;
    photo3A.alpha = 1.0f;
    photo3A.followShift = true;
    
    photo1B.w = fullWidth;
    photo1B.h = fullHeight;
    photo1B.x = 0.66f;
    photo1B.y = -0.3f;
    photo1B.r = 0.0f;
    
    photo1B.textCoordx1 = 0.0f;
    photo1B.textCoordy1 = 0.0f;
    photo1B.textCoordx2 = 0.5f;
    photo1B.textCoordy2 = 1.0f;
    photo1B.textID = TEXTURE_ANI_STYLE_1_2;
    photo1B.visible = TRUE;
    photo1B.alpha = 1.0f;
    photo1B.followShift = true;
    
    photo2B.w = fullWidth;
    photo2B.h = fullHeight;
    photo2B.x = 0.66f;
    photo2B.y = -0.3f;
    photo2B.r = 0.0f;
    
    photo2B.textCoordx1 = 0.0f;
    photo2B.textCoordy1 = 0.0f;
    photo2B.textCoordx2 = 0.5f;
    photo2B.textCoordy2 = 1.0f;
    photo2B.textID = TEXTURE_ANI_STYLE_2_2;
    photo2B.visible = TRUE;
    photo2B.alpha = 1.0f;
    photo2B.followShift = true;
    
    photoCount = 0;
    return self;
}

-(void)updatePhoto:(int)photoCnt{
    photoCount = photoCnt;
    [self initAnimation0];
    [self initAnimation1];
    [self initAnimation2];
}

-(void)initAnimation0{
    waitTime0 = 0;
    changePhoto0 = 0;

    photo1.alpha = 1.0f;
    photo2.alpha = 0.0f;
    photo1.textCoordx1 = 0.0f;
    photo1.textCoordx2 = 0.5f;
    photo2.textCoordx1 = 0.0f;
    photo2.textCoordx2 = 0.5f;
}

-(void)initAnimation1{
    waitTime1 = 0;
    changePhoto1 = 0;
        
    photo1A.alpha = 1.0f;
    photo2A.alpha = 1.0f;
    photo1A.textCoordx1 = 0.0f;
    photo1A.textCoordx2 = 0.5f;
    photo2A.textCoordx1 = 0.0f;
    photo2A.textCoordx2 = 0.5f;
    photo1A.w = fullWidth;
    photo1A.h = fullHeight;
    photo2A.w = 0;
    photo2A.h = 0;
    
}

-(void)initAnimation2{
    waitTime2 = 0;
    changePhoto2 = 0;
        
    photo1B.alpha = 1.0f;
    photo2B.alpha = 1.0f;
    photo1B.textCoordx1 = 0.0f;
    photo1B.textCoordx2 = 0.5f;
    photo2B.textCoordx1 = -0.5f;
    photo2B.textCoordx2 = 0.0f;
}

@end
