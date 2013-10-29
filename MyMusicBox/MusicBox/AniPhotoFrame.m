//
//  AniPhotoFrame.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月3日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniPhotoFrame.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniPhotoFrame

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:timeUnits];
    }
    if(photoCount == 0){
        waitTime += timeUnits;
        if (waitTime < 4.0f) {
            photoMsg.alpha = (4.0f - waitTime) * (4.0f - waitTime)  / 16.0f;
        }
        else{
            photoMsg.alpha = (waitTime - 4.0f) * (waitTime - 4.0f) / 16.0f;
        }
        if (waitTime > 8.0f) {
            waitTime -= 8.0f;
        }        
    }
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        if (photoCount > 1) {
            waitTime += angle;
            if (waitTime > 20.0f) {
                changePhoto += angle;
                if ((animationType == 2 && changePhoto > 6.0f)
                    || (animationType != 2 && changePhoto > 3.0f)) {
                    if (photoCount == 2) {
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_PHOTO1 :TEXTURE_PHOTO2];
                    }
                    else{
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_PHOTO1 :TEXTURE_PHOTO3];
                        [[MusicBoxViewController sharedInstance] switchTexture:TEXTURE_PHOTO1 :TEXTURE_PHOTO2];
                    }

                    [self initAnimation];
                }
                else{
                    switch (animationType) {
                        case 0:
                            photo2.alpha = changePhoto / 3.0f;
                            break;
                        case 1:
                            if (changePhoto < 1.5f) {
                                photo1.w = fullWidth * (1.0 - (changePhoto / 1.5f));
                                photo1.h = fullHeight * (1.0 - (changePhoto / 1.5f));
                            }
                            else{
                                photo2.w = fullWidth * (changePhoto - 1.5f) / 1.5f;
                                photo2.h = fullHeight * (changePhoto - 1.5f) / 1.5f;
                            }
                            
                            break;
                        case 2:
                            photo1.textCoordx1 = 0.5f * changePhoto / 6.0f;
                            photo1.textCoordx2 = 0.5f + (0.5f * changePhoto / 6.0f);
                            photo2.textCoordx1 = (0.5f * changePhoto / 6.0f) - 0.5f;
                            photo2.textCoordx2 = 0.5f * changePhoto / 6.0f;
                        default:
                            break;
                    }
                }
            }
        }
    }
}

-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:photoFrame];
    [[MusicBoxViewController sharedInstance] addAnimationObject:photoMsg];
    if (photoCount > 0) {
        [[MusicBoxViewController sharedInstance] addAnimationObject:photo1];
    }
    if (photoCount > 1) {
        [[MusicBoxViewController sharedInstance] addAnimationObject:photo2];
    }
}


-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    animationType = 1;
    fullWidth = (136.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    fullHeight = (136.0f / STD_HEIGHT) * 2.0f;
    
    photoFrame.w = (185.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    photoFrame.h = (165.0f / STD_HEIGHT) * 2.0f;
    photoFrame.x = ((x + (185.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    photoFrame.y = 1.0f - ((y + (165.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    photoFrame.r = 0.0f;
    
    photoFrame.textCoordx1 = 0.0f;
    photoFrame.textCoordy1 = 0.0f;
    photoFrame.textCoordx2 = 370.0f/512.0f;
    photoFrame.textCoordy2 = 330.0f/1024.0f;
    photoFrame.textID = TEXTURE_PHOTO;
    photoFrame.visible = TRUE;
    photoFrame.alpha = 1.0f;
    photoFrame.followShift = true;

    [[MusicBoxViewController sharedInstance]
     renderTextLocAutoSize:512 : 128
            :[UIColor colorWithRed:0.1f green:0.1f blue:0.2f alpha:1.0f]
            :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
            :UITextAlignmentCenter
            :NSLocalizedString(@"NO_PHOTO", @"NO_PHOTO")
            :TEXTURE_PHOTO_MSG];
    
    photoMsg.w = fullWidth;
    photoMsg.h = (40.0f / STD_HEIGHT) * 2.0f;
    photoMsg.x = ((x + 26.0f + (136.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    photoMsg.y = 1.0f - ((y + 23.0f + (136.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    photoMsg.r = 8.6f * 2.0f * 3.141592f / 360.0f;
    
    photoMsg.textCoordx1 = 0.0f;
    photoMsg.textCoordy1 = 0.0f;
    photoMsg.textCoordx2 = 1.0f;
    photoMsg.textCoordy2 = 1.0f;
    photoMsg.textID = TEXTURE_PHOTO_MSG;
    photoMsg.visible = TRUE;
    photoMsg.alpha = 1.0f;
    photoMsg.followShift = true;
    
    
    photo1.w = fullWidth;
    photo1.h = fullHeight;
    photo1.x = ((x + 26.0f + (136.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    photo1.y = 1.0f - ((y + 23.0f + (136.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    photo1.r = 8.6f * 2.0f * 3.141592f / 360.0f;
    
    photo1.textCoordx1 = 0.0f;
    photo1.textCoordy1 = 0.0f;
    photo1.textCoordx2 = 0.5f;
    photo1.textCoordy2 = 1.0f;
    photo1.textID = TEXTURE_PHOTO1;
    photo1.visible = TRUE;
    photo1.alpha = 1.0f;
    photo1.followShift = true;
    
    photo2.w = fullWidth;
    photo2.h = fullHeight;
    photo2.x = ((x + 26.0f + (136.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    photo2.y = 1.0f - ((y + 23.0f + (136.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    photo2.r = 8.6f * 2.0f * 3.141592f / 360.0f;
    
    photo2.textCoordx1 = 0.0f;
    photo2.textCoordy1 = 0.0f;
    photo2.textCoordx2 = 0.5f;
    photo2.textCoordy2 = 1.0f;
    photo2.textID = TEXTURE_PHOTO2;
    photo2.visible = TRUE;
    photo2.alpha = 1.0f;
    photo2.followShift = true;

    photoCount = 0;
    return self;
}

-(void)updatePhoto:(int)photoCnt{
    photoCount = photoCnt;
    [self initAnimation];
}

-(void)initAnimation{
    waitTime = 0;
    changePhoto = 0;
    if (photoCount == 0) {
        photoFrame.textCoordy1 = 0.0f/1024.0f;
        photoFrame.textCoordy2 = 330.0f/1024.0f;
        photoMsg.visible = true;
        photoMsg.alpha = 1.0f;
    }
    else{
        photoFrame.textCoordy1 = 330.0f/1024.0f;
        photoFrame.textCoordy2 = 660.0f/1024.0f;
        photoMsg.visible = false;
    }
    switch (animationType) {
        case 0:
            photo1.alpha = 1.0f;
            photo2.alpha = 0.0f;
            photo1.textCoordx1 = 0.0f;
            photo1.textCoordx2 = 0.5f;
            photo2.textCoordx1 = 0.0f;
            photo2.textCoordx2 = 0.5f;
            photo1.w = fullWidth;
            photo1.h = fullHeight;
            photo2.w = fullWidth;
            photo2.h = fullHeight;
            break;
        case 1:
            photo1.alpha = 1.0f;
            photo2.alpha = 1.0f;
            photo1.textCoordx1 = 0.0f;
            photo1.textCoordx2 = 0.5f;
            photo2.textCoordx1 = 0.0f;
            photo2.textCoordx2 = 0.5f;
            photo1.w = fullWidth;
            photo1.h = fullHeight;
            photo2.w = 0.0f;
            photo2.h = 0.0f;
            break;
        case 2:
            photo1.alpha = 1.0f;
            photo2.alpha = 1.0f;
            photo1.textCoordx1 = 0.0f;
            photo1.textCoordx2 = 0.5f;
            photo2.textCoordx1 = -0.5f;
            photo2.textCoordx2 = 0.0f;
            photo1.w = fullWidth;
            photo1.h = fullHeight;
            photo2.w = fullWidth;
            photo2.h = fullHeight;
            
        default:
            break;
    }

}

-(void)switchStyle:(int)style{
    animationType = style;
    [self initAnimation];    
}


@end
