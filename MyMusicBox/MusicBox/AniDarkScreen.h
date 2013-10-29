//
//  AniDarkScreen.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年7月9日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniDarkScreen : NSObject<AnimationGroup>{
    AnimationObject photoFrame;
}
-(id)init;
-(void)darkenScreen:(BOOL)darken;

@end
