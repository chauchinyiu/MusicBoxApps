//
//  AniDecoration.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年5月1日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniDecoration.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniDecoration
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
}

-(void)handleRotate:(GLfloat)angle{
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:bg];
}

-(id)init{
    bg.w = 2.0f;
    bg.h = 2.0f;
    bg.x = 0.0f;
    bg.y = 0.0f;
    bg.r = 0.0f;
    
    bg.textCoordx1 = 0.0f;
    bg.textCoordy1 = 0.0f;
    bg.visible = TRUE;
    
    return self;
}

-(void) changeThemeTo:(MusicBoxThemeType) theme{
    NSString* formatstring =@"%@_decoration%@";
    NSArray* themes =[[ThemeManager sharedInstance] getArrayOfThemes];
    for(int i=0 ; i< [themes count] ; i++){
        MusicBoxThemeType type = [[themes objectAtIndex:i] intValue];
        if(theme == type){
            NSString *name =[[ThemeManager sharedInstance] getThemeNameBy:type];
            NSString *imagename = [NSString stringWithFormat:formatstring,name, (IS_IPHONE_5 ? @"_wide" : @"")];

            bg.textID = TEXTURE_BG;
            
            if(IS_IPHONE_5){
                bg.textCoordx2 = 1136.0f/2048.0f;
                bg.textCoordy2 = 640.0f/1024.0f;
            }
            else{
                bg.textCoordx2 = 960.0f/1024.0f;
                bg.textCoordy2 = 640.0f/1024.0f;
            }
            
            if(theme == CHRISTMAS){
                bg.textID = TEXTURE_DEC_F;
                [[MusicBoxViewController sharedInstance] reloadTexture:TEXTURE_DEC_F :imagename];
            }
            else{
                bg.textID = TEXTURE_DEC_B;
                [[MusicBoxViewController sharedInstance] reloadTexture:TEXTURE_DEC_B :imagename];
            }
            
            break;
        }
    }

}
@end

