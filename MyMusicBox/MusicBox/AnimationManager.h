//
//  AnimationManager.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicBoxConstants.h"


@class MusicBoxViewController;
@class AniWheel;
@class AniComb;
@class AniVerticalGear;
@class AniPlayLever;
@class AniShadow;
@class AniDecoration;
@class AniGear;
@class AniPhotoFrame;
@class AniPhotoStyle;
@class AniDarkScreen;
@class AniGui;

@interface AnimationManager : NSObject{
    NSMutableArray *groups;
    AniWheel* aw;
    AniComb* ac;
    AniVerticalGear* av;
    AniPlayLever* ap;
    AniShadow* asp;
    AniDecoration* ad;
    AniGear* ag;
    AniPhotoFrame* aph;
    AniPhotoStyle* aps;
    AniGui* agui;
    AniDarkScreen* ads;
}
-(id)init;
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay;
-(void)updateAniObjsStep;
-(void)leverRotated:(GLfloat)angle;


-(void)fillBuffer;
-(void)changeThemeTo:(MusicBoxThemeType) theme ThemeName:(NSString*)tname;
-(void)changeSongTo:(NSString*)sname;
-(void)changeAutoPlay:(BOOL)isplaying ButtonPressed:(BOOL)ispressed;
-(void)startPinLocations:(NSArray *) indexs;

-(void)updateMessage:(NSString*)msg isDefault:(BOOL)isDefault;
-(void)updatePhoto:(int)photoCnt;
-(void)switchStyle:(int)style;

-(void)showPullDown:(BOOL)isVisible;
-(void)pullDownPlayButton;
-(void)returnPlayButton;
-(void)clickPlayButton;

-(void)darkenScreen:(BOOL)darken;
@end
