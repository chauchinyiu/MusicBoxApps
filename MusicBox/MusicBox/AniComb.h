//
//  AniComb.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月23日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniComb : NSObject<AnimationGroup>{
    AnimationObject comb;
    AnimationObject strip[24];
    GLfloat timer[24];
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)startPinLocations:(NSArray *) indexs;
-(void)removeAllPins;
@end

