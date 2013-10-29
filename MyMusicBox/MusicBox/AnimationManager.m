//
//  AnimationManager.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AnimationManager.h"
#import "AniBackground.h"
#import "AniWheel.h"
#import "AniComb.h"
#import "AniVerticalGear.h"
#import "AnimationGroup.h"
#import "AniPlayLever.h"
#import "AniShadow.h"
#import "AniDecoration.h"
#import "AniGear.h"
#import "AniPhotoFrame.h"
#import "AniPhotoStyle.h"
#import "AniDarkScreen.h"
#import "AniGui.h"

@implementation AnimationManager

-(id)init{
    groups = [[NSMutableArray alloc] init];
    AniBackground* ab = [[AniBackground alloc]init];
    [groups addObject:ab];
    
    
    aw = [[AniWheel alloc]initWithOffSetX:27.0f + (IS_IPHONE_5? 26.0f : 0.0f) OffSetY:0.0f];
    [groups addObject:aw];
    ac = [[AniComb alloc]initWithOffSetX:47.5f + (IS_IPHONE_5? 26.0f : 0.0f) OffSetY:90.0f];
    [groups addObject:ac];
    av = [[AniVerticalGear alloc]initWithOffSetX:311.0f + (IS_IPHONE_5? 26.0f : 0.0f) OffSetY:0.0f];
    [groups addObject:av];
    
    aph = [[AniPhotoFrame alloc]initWithOffSetX:311.0f + (IS_IPHONE_5? 26.0f : 0.0f) OffSetY:111.0f];
    [groups addObject:aph];
    ap = [[AniPlayLever alloc]initWithOffSetX:402.0f + (IS_IPHONE_5? 26.0f : 0.0f) OffSetY:80.0f];
    [groups addObject:ap];
    asp = [[AniShadow alloc]initWithOffSetX:0.0f OffSetY:200.0f];
    [groups addObject:asp];
    ad = [[AniDecoration alloc]init];
    [groups addObject:ad];
    ag = [[AniGear alloc]initWithOffSetX:(IS_IPHONE_5? 26.0f : 0.0f) OffSetY:0.0f];
    [groups addObject:ag];
    agui = [[AniGui alloc]initWithOffSetX:(IS_IPHONE_5? 26.0f : 0.0f) OffSetY:0.0f];
    [groups addObject:agui];

    ads = [[AniDarkScreen alloc]init];
    [groups addObject:ads];
    
    aps = [[AniPhotoStyle alloc]initWithOffSetX:(IS_IPHONE_5? 26.0f : 0.0f) OffSetY:0.0f];

    return self;
}

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    for (int i = 0; i < groups.count; i++) {
        [[groups objectAtIndex:i] updateAniObjs:timeUnits IsAuto:autoplay];
    }
    if([MusicBoxViewController sharedInstance].getIsInAniSelect){
        [aps updateAniObjs:timeUnits IsAuto:autoplay];
    }
}

-(void)fillBuffer{
    for (int i = 0; i < groups.count; i++) {
        [[groups objectAtIndex:i] fillBuffer];
    }
    if([MusicBoxViewController sharedInstance].getIsInAniSelect){
        [aps fillBuffer];
    }
}

-(void)updateAniObjsStep{
    [asp startMove];
}

- (void)leverRotated:(GLfloat)angle{
    for (int i = 0; i < groups.count; i++) {
        [[groups objectAtIndex:i] handleRotate:angle];
    }

}

-(void)changeThemeTo:(MusicBoxThemeType) theme ThemeName:(NSString*)tname{    
    [asp changeThemeTo:theme];
    [ad changeThemeTo:theme];
    [aw removeAllPins];
    [ac removeAllPins];
    [asp updateMessage:NSLocalizedString(@"EMPTY_MESSAGE", @"Displayed when message bar is empty") isDefault:TRUE];
}

-(void)changeSongTo:(NSString*)sname{
    [aw removeAllPins];
    [ac removeAllPins];
    [ap resetRotationPosition];
}

-(void)changeAutoPlay:(BOOL)isplaying ButtonPressed:(BOOL)ispressed{
    [ap changeAutoPlay:isplaying ButtonPressed:ispressed];
}

-(void)startPinLocations:(NSArray *) indexs{
    [aw startPinLocations:indexs];
    [ac startPinLocations:indexs];
}

-(void)updateMessage:(NSString*)msg isDefault:(BOOL)isDefault{
    [asp updateMessage:msg isDefault:isDefault];
}

-(void)updatePhoto:(int)photoCnt{
    [aph updatePhoto:photoCnt];
    [aps updatePhoto:photoCnt];
}

-(void)switchStyle:(int)style{
    [aph switchStyle:style];
}

-(void)showPullDown:(BOOL)isVisible{
    [agui showPullDown:isVisible];
}

-(void)pullDownPlayButton{
    [agui pullDownPlayButton];
}

-(void)returnPlayButton{
    [agui returnPlayButton];
}

-(void)clickPlayButton{
    [agui clickPlayButton];
}

-(void)darkenScreen:(BOOL)darken{
    [ads darkenScreen:darken];
}


@end
