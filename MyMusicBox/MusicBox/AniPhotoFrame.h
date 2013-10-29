//
//  AniPhotoFrame.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月3日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniPhotoFrame : NSObject<AnimationGroup>{
    AnimationObject photoFrame;
    AnimationObject photoMsg;
    AnimationObject photo1;
    AnimationObject photo2;
    int photoCount;
    float waitTime;
    float changePhoto;
    int animationType;
    float fullWidth;
    float fullHeight;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)updatePhoto:(int)photoCnt;
-(void)switchStyle:(int)style;

@end

