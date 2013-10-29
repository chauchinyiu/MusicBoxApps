//
//  AniShadow.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年4月30日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "AniShadow.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniShadow
-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:timeUnits];
    }
    
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        if (movingObj1.x + movingObj1.w / 2.0f > -1.0f) {
            movingObj1.x -= angle * 20.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        }
        else{
            movingObj1.x = 1.0f + movingObj1.w / 2.0f;
        }
        movingObj2.x = movingObj1.x;
        
        translationX += angle * 2.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        if (translationX - originalX > movingBG1.w) {
            translationX -= movingBG1.w;
        }
        //round sub pixel movement
        movingBG1.x = round(((translationX) + 1.0f) / 2.0f * (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * (IS_RETINA ? 2.0f : 1.0f)) / (IS_RETINA ? 2.0f : 1.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f - 1.0f;
        movingBG2.x = movingBG1.x - movingBG1.w;
    }
    
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:bg];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG2];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingObj1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingObj2];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    objX = x;
    objY = y;
    
    bg.w = 2.0f;
    bg.h = (90.0f / STD_HEIGHT) * 2.0f;
    bg.x = ((x + ((IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    bg.y = 1.0f - ((y + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
    bg.r = 0.0f;
    
    bg.textCoordx1 = 0.0f;
    bg.textCoordy1 = 640.0f/1024.0f;
    bg.textCoordx2 = 1136.0f/2048.0f;
    bg.textCoordy2 = (640.0f + 178.0f)/1024.0f;
    bg.textID = TEXTURE_BG;
    bg.visible = TRUE;
    
    _movingobject_starting_x_position = (IS_IPHONE_5 ? 568 : 480);
    
    [self changeThemeTo:[[ThemeManager sharedInstance] getCurrentTheme]];
    
    return self;
}

-(void) changeThemeTo:(MusicBoxThemeType) theme{
    
    //TODO make it more generic solution
    
    
    NSString *imgString = @"lightbox_%d_gl";
    int replace_number = 0;
    switch (theme) {
        case CHRISTMAS:
            replace_number = 1;
            break;
        case CLASSIC:
            replace_number = 2;
            break;
        case CARNIVAL:
            replace_number = 3;
            break;
        case VALENTINE:
            replace_number = 4;
            break;
        default:
            return;
            break;
    }
    
    imgString = [NSString stringWithFormat:imgString,replace_number];
    [[MusicBoxViewController sharedInstance] reloadTexture:TEXTURE_LBOX :imgString];
    
    switch (theme) {
        case CHRISTMAS:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 96.0f) / STD_HEIGHT) * 2.0f;
            movingBG1.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 193.0f)/512.0f;
            
            movingBG2.h = ((IS_IPHONE_5 ? 75.0f : 96.0f) / STD_HEIGHT) * 2.0f;
            movingBG2.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG2.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG2.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 193.0f)/512.0f;
            
            
            movingObj1.w = 125.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (48.0f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 125.0f + 125.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 250.0f)/2048.0f;
            movingObj1.textCoordy2 = 96.0f/512.0f;
            
            movingObj2.w = 125.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj2.h = (49.0f / STD_HEIGHT) * 2.0f;
            movingObj2.x = ((_movingobject_starting_x_position - 125.0f + 125.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj2.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj2.r = 0.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 250.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 250.0f + 250.0f)/2048.0f;
            movingObj2.textCoordy2 = 98.0f/512.0f;
            
            break;
        case CLASSIC:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 61.0f) / STD_HEIGHT) * 2.0f;
            movingBG1.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 122.0f)/512.0f;
            
            movingBG2.h = ((IS_IPHONE_5 ? 75.0f : 61.0f) / STD_HEIGHT) * 2.0f;
            movingBG2.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG2.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG2.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 122.0f)/512.0f;
            
            movingObj1.w = 47.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (66.0f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 47.0f + 47.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 94.0f)/2048.0f;
            movingObj1.textCoordy2 = 132.0f/512.0f;
            
            movingObj2.w = 47.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj2.h = (66.0f / STD_HEIGHT) * 2.0f;
            movingObj2.x = ((_movingobject_starting_x_position - 47.0f + 47.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj2.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj2.r = 0.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 94.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 94.0f + 94.0f)/2048.0f;
            movingObj2.textCoordy2 = 132.0f/512.0f;
            
            break;
        case CARNIVAL:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 73.0f) / STD_HEIGHT) * 2.0f;
            movingBG1.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 147.0f)/512.0f;
            
            movingBG2.h = ((IS_IPHONE_5 ? 75.0f : 73.0f) / STD_HEIGHT) * 2.0f;
            movingBG2.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG2.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG2.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 147.0f)/512.0f;
            
            
            movingObj1.w = 67.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (73.0f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 67.0f + 67.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 135.0f)/2048.0f;
            movingObj1.textCoordy2 = 147.0f/512.0f;
            
            movingObj2.w = 67.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj2.h = (73.0f / STD_HEIGHT) * 2.0f;
            movingObj2.x = ((_movingobject_starting_x_position - 67.0f + 67.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj2.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj2.r = 0.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 135.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 135.0f + 135.0f)/2048.0f;
            movingObj2.textCoordy2 = 147.0f/512.0f;
            
            break;
        case VALENTINE:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 69.0f) / STD_HEIGHT) * 2.0f;
            movingBG1.y = 1.0f - ((objY + (90.0f/ 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 139.0f)/512.0f;
            
            movingBG2.h = ((IS_IPHONE_5 ? 75.0f : 69.0f) / STD_HEIGHT) * 2.0f;
            movingBG2.y = 1.0f - ((objY + (90.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
            
            movingBG2.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG2.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 139.0f)/512.0f;
            
            
            movingObj1.w = 72.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (67.0f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 72.0f + 72.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 145.0f)/2048.0f;
            movingObj1.textCoordy2 = 134.0f/512.0f;
            
            movingObj2.w = 72.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj2.h = (67.0f / STD_HEIGHT) * 2.0f;
            movingObj2.x = ((_movingobject_starting_x_position - 72.0f + 72.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj2.y = 1.0f - ((objY + (90.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
            movingObj2.r = 0.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 145.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 145.0f + 145.0f)/2048.0f;
            movingObj2.textCoordy2 = 134.0f/512.0f;
            
            break;
        default:
            break;
    }
    
    movingBG1.w = (IS_IPHONE_5 ? 600.0f / WIDE_WIDTH : 500.0f / STD_WIDTH) * 2.0f;
    movingBG1.x = ((objX + (IS_IPHONE_5 ? 600.0f : 500.0f) / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    translationX = movingBG1.x;
    originalX = movingBG1.x;
    movingBG1.r = 0.0f;
    
    
    movingBG1.textCoordx1 = 0.0f;
    movingBG1.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG1.textID = TEXTURE_LBOX;
    movingBG1.visible = TRUE;
    
    movingBG2.w = movingBG1.w;
    movingBG2.x = movingBG1.x - movingBG1.w;
    movingBG2.r = 0.0f;
    
    movingBG2.textCoordx1 = 0.0f;
    movingBG2.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG2.textID = TEXTURE_LBOX;
    movingBG2.visible = TRUE;
    
    
    movingObj1.textID = TEXTURE_LBOX;
    movingObj1.visible = TRUE;
    
    movingObj2.textID = TEXTURE_LBOX;
    movingObj2.visible = FALSE;
}


-(void) startMove{
    movingObj1.visible = !movingObj1.visible;
    movingObj2.visible = !movingObj2.visible;
    
}

-(void)updateMessage:(NSString*)msg{
    [[MusicBoxViewController sharedInstance] renderTextLoc:600 : 30 * 2
                                                          :msgColor
                                                          :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
                                                          :UITextAlignmentCenter
                                                          :msg:TEXTURE_MSG];
}




@end
