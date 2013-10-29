//
//  AniGear.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年5月3日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniGear : NSObject<AnimationGroup>{
    AnimationObject gear1;
    AnimationObject gear2;
    AnimationObject gearFrame;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
@end

