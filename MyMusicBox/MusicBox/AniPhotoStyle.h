//
//  AniPhotoStyle.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年6月7日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniPhotoStyle : NSObject<AnimationGroup>{
    AnimationObject photoFrame;
    AnimationObject photoMSG;
    AnimationObject photo1;
    AnimationObject photo2;

    AnimationObject photo1A;
    AnimationObject photo2A;
    AnimationObject photo3A;
    
    AnimationObject photo1B;
    AnimationObject photo2B;
    int photoCount;
    float waitTime0;
    float changePhoto0;
    float waitTime1;
    float changePhoto1;
    float waitTime2;
    float changePhoto2;
    float fullWidth;
    float fullHeight;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)updatePhoto:(int)photoCnt;

@end
