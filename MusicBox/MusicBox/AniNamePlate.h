//
//  AniNamePlate.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月25日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGroup.h"
#import "MusicBoxViewController.h"

@interface AniNamePlate : NSObject<AnimationGroup>{
    AnimationObject plate;
    AnimationObject label1;
    AnimationObject label2;
}


-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y;
-(void)setThemeLabel:(NSString *)themestring;
-(void)setSongLabel:(NSString *) songString;
@end
