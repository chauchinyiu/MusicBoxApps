//
//  AniDecoration.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年5月1日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniDecoration : NSObject<AnimationGroup>{
    AnimationObject bg;
}
-(void) changeThemeTo:(MusicBoxThemeType) theme;

@end

