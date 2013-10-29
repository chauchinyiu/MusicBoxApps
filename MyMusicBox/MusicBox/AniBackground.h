//
//  AniBackground.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniBackground : NSObject<AnimationGroup>{
    AnimationObject bg;
}
-(id)init;
@end

