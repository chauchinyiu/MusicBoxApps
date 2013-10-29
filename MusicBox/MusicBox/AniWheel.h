//
//  AniWheel.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月22日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniWheel : NSObject<AnimationGroup>{
    AnimationObject wheel;
    AnimationObject wheelShadow;
    AnimationObject wheelMask;
    AnimationObject blackOnWheel;
    AnimationObject blackStick;
    AnimationObject pins[100];
    int pinIndex;
    GLfloat objY;
    GLfloat objX;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)startPinLocations:(NSArray *) indexs;
-(void)removeAllPins;
@end

