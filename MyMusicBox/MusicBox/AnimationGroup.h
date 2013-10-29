//
//  AnimationObj.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MusicBoxViewController;

@protocol AnimationGroup
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay;
-(void)handleRotate:(GLfloat)angle;
-(void)fillBuffer;
@end
