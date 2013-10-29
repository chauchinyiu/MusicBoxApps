//
//  AniShadow.h
//  MusicBox
//
//  Created by Ming Kei Wong on 13年4月30日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"
#import "AppDelegate.h"

@interface AniShadow : NSObject<AnimationGroup>{
    AnimationObject bg;
    
    AnimationObject movingBG1;
    AnimationObject movingBG2;
    AnimationObject movingBG3;
    AnimationObject movingBG4;
    AnimationObject movingObj1;
    AnimationObject movingObj2;
    
    AnimationObject msgObj;
    
    float _movingobject_starting_x_position;
    GLfloat objY;
    GLfloat objX;
    UIColor* msgColor;
    GLfloat translationX;
    GLfloat originalX;
}
-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)startMove;
-(void)changeThemeTo:(MusicBoxThemeType) theme;
-(void)updateMessage:(NSString*)msg;
@end

