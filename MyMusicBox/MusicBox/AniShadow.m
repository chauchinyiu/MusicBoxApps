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
    if(isDefaultMsg){
        waitTime += timeUnits;
        if (waitTime < 4.0f) {
            msgObj.alpha = (4.0f - waitTime) * (4.0f - waitTime)  / 16.0f;
        }
        else{
            msgObj.alpha = (waitTime - 4.0f) * (waitTime - 4.0f) / 16.0f;
        }
        if (waitTime > 8.0f) {
            waitTime -= 8.0f;
        }
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
        
        movingBG1.x += angle * 2.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        movingBG2.x += angle * 2.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        movingBG3.x += angle * 2.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        movingBG4.x += angle * 2.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
        
        if (movingBG1.x - movingBG1.w / 2.0f >= 1.0f) {
            movingBG1.x = movingBG4.x - movingBG1.w;
        }
        if (movingBG2.x - movingBG2.w / 2.0f >= 1.0f) {
            movingBG2.x = movingBG1.x - movingBG1.w;
        }
        if (movingBG3.x - movingBG3.w / 2.0f >= 1.0f) {
            movingBG3.x = movingBG2.x - movingBG1.w;
        }
        if (movingBG4.x - movingBG4.w / 2.0f >= 1.0f) {
            movingBG4.x = movingBG3.x - movingBG1.w;
        }
        if(displayLen == [userMsg length]){
            displayScroll += angle * 20.0f;
            displayScroll = [[MusicBoxViewController sharedInstance] renderTextLocScroll:600 : 30 * 2
                                                        :msgColor
                                                        :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
                                                        :UITextAlignmentLeft
                                                                                        :userMsg:TEXTURE_MSG :displayScroll :true];
        }
    }
    
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:bg];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG2];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG3];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingBG4];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingObj1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:movingObj2];
    [[MusicBoxViewController sharedInstance] addAnimationObject:msgObj];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    objX = x;
    objY = y;
    isDefaultMsg = true;
    
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
    bg.alpha = 1.0f;
    bg.followShift = true;
    
    
    msgObj.w = 300.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
    msgObj.h = (30.0f / STD_HEIGHT) * 2.0f;
    msgObj.x = (-45.0f/ STD_HEIGHT) * 2.0f;
    msgObj.y = 1.0f - ((y + 12.0f + (30.0f / 2.0f))/ STD_HEIGHT) * 2.0f;
    msgObj.r = 0.0f;
    
    msgObj.textCoordx1 = 0.0f;
    msgObj.textCoordy1 = 0.0f;
    msgObj.textCoordx2 = 600.0f / 1024.0f;
    msgObj.textCoordy2 = 30.0f * 2.0f/64.0f;
    msgObj.textID = TEXTURE_MSG;
    msgObj.visible = TRUE;
    msgObj.alpha = 1.0f;
    msgObj.followShift = true;

    
    _movingobject_starting_x_position = (IS_IPHONE_5 ? 568 : 480);
    
    [self changeThemeTo:[[ThemeManager sharedInstance] getCurrentTheme]];
    
    userMsg = @"";
    displayLen = 0;
    displayScroll = 0.0f;
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
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 96.0f) * 0.6f / STD_HEIGHT) * 2.0f;
            movingBG1.y = ((IS_IPHONE_5 ? 75.0f : 96.0f) * 0.6f) / 2.0f / STD_HEIGHT * 2.0f - 1.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 193.0f)/512.0f;
            
            movingObj1.w = 125.0f * 0.6f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (48.0f * 0.6f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 125.0f + 125.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = movingBG1.y;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 250.0f)/2048.0f;
            movingObj1.textCoordy2 = 96.0f/512.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 250.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 250.0f + 250.0f)/2048.0f;
            movingObj2.textCoordy2 = 98.0f/512.0f;
            
            msgColor = [UIColor colorWithRed:212.0f / 255.0f green:107.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f];
            
            break;
        case CLASSIC:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 61.0f) * 0.6f / STD_HEIGHT) * 2.0f;
            movingBG1.y = ((IS_IPHONE_5 ? 75.0f : 61.0f) * 0.6f) / 2.0f / STD_HEIGHT * 2.0f - 1.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 122.0f)/512.0f;
            
            movingObj1.w = 47.0f * 0.6f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (66.0f * 0.6f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 47.0f + 47.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = movingBG1.y;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 94.0f)/2048.0f;
            movingObj1.textCoordy2 = 132.0f/512.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 94.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 94.0f + 94.0f)/2048.0f;
            movingObj2.textCoordy2 = 132.0f/512.0f;
            
            msgColor = [UIColor colorWithRed:212.0f / 255.0f green:107.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f];
            
            
            break;
        case CARNIVAL:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 73.0f) * 0.6f / STD_HEIGHT) * 2.0f;
            movingBG1.y = ((IS_IPHONE_5 ? 75.0f : 73.0f) * 0.6f) / 2.0f / STD_HEIGHT * 2.0f - 1.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 147.0f)/512.0f;
            
            movingObj1.w = 67.0f * 0.6f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (73.0f * 0.6f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 67.0f + 67.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = movingBG1.y;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 135.0f)/2048.0f;
            movingObj1.textCoordy2 = 147.0f/512.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 135.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 135.0f + 135.0f)/2048.0f;
            movingObj2.textCoordy2 = 147.0f/512.0f;
            
            msgColor = [UIColor colorWithRed:212.0f / 255.0f green:107.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f];
            
            break;
        case VALENTINE:
            movingBG1.h = ((IS_IPHONE_5 ? 75.0f : 69.0f) * 0.6f / STD_HEIGHT) * 2.0f;
            movingBG1.y = ((IS_IPHONE_5 ? 75.0f : 69.0f) * 0.6f) / 2.0f / STD_HEIGHT * 2.0f - 1.0f;
            
            movingBG1.textCoordy1 = (IS_IPHONE_5 ? 0.0f : 150.0f)/512.0f;
            movingBG1.textCoordy2 = (IS_IPHONE_5 ? 150.0f : 150.0f + 139.0f)/512.0f;
            
            movingObj1.w = 72.0f * 0.6f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 2.0f;
            movingObj1.h = (67.0f * 0.6f / STD_HEIGHT) * 2.0f;
            movingObj1.x = ((_movingobject_starting_x_position - 72.0f + 72.0f / 2.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
            movingObj1.y = movingBG1.y;
            movingObj1.r = 0.0f;
            
            movingObj1.textCoordx1 = 1200.0f/2048.0f;
            movingObj1.textCoordy1 = 0.0f;
            movingObj1.textCoordx2 = (1200.0f + 145.0f)/2048.0f;
            movingObj1.textCoordy2 = 134.0f/512.0f;
            
            movingObj2.textCoordx1 = (1200.0f + 145.0f)/2048.0f;
            movingObj2.textCoordy1 = 0.0f;
            movingObj2.textCoordx2 = (1200.0f + 145.0f + 145.0f)/2048.0f;
            movingObj2.textCoordy2 = 134.0f/512.0f;
            
            msgColor = [UIColor colorWithRed:195.0f / 255.0f green:92.0f / 255.0f blue:109.0f / 255.0f alpha:1.0f];
            
            break;
        default:
            break;
    }
    
    movingBG1.w = (IS_IPHONE_5 ? 600.0f / WIDE_WIDTH : 500.0f / STD_WIDTH) * 0.6f * 2.0f;
    movingBG1.x = ((objX + (IS_IPHONE_5 ? WIDE_WIDTH - (600.0f / 2.0f): STD_WIDTH - (500.0f / 2.0f)) * 0.6f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    movingBG1.r = 0.0f;
    
    movingBG1.textCoordx1 = 0.0f;
    movingBG1.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG1.textID = TEXTURE_LBOX;
    movingBG1.visible = TRUE;
    movingBG1.alpha = 1.0f;
    movingBG1.followShift = true;

    
    movingBG2.h = movingBG1.h;
    movingBG2.y = movingBG1.y;
    
    movingBG2.textCoordy1 = movingBG1.textCoordy1;
    movingBG2.textCoordy2 = movingBG1.textCoordy2;
    
    movingBG2.w = movingBG1.w;
    movingBG2.x = movingBG1.x - movingBG1.w;
    movingBG2.r = 0.0f;
    
    movingBG2.textCoordx1 = 0.0f;
    movingBG2.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG2.textID = TEXTURE_LBOX;
    movingBG2.visible = TRUE;
    movingBG2.alpha = 1.0f;
    movingBG2.followShift = true;
    
    movingBG3.h = movingBG1.h;
    movingBG3.y = movingBG1.y;
    
    movingBG3.textCoordy1 = movingBG1.textCoordy1;
    movingBG3.textCoordy2 = movingBG1.textCoordy2;
    
    movingBG3.w = movingBG1.w;
    movingBG3.x = movingBG2.x - movingBG1.w;
    movingBG3.r = 0.0f;
    
    movingBG3.textCoordx1 = 0.0f;
    movingBG3.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG3.textID = TEXTURE_LBOX;
    movingBG3.visible = TRUE;
    movingBG3.alpha = 1.0f;
    movingBG3.followShift = true;
    
    movingBG4.h = movingBG1.h;
    movingBG4.y = movingBG1.y;
    
    movingBG4.textCoordy1 = movingBG1.textCoordy1;
    movingBG4.textCoordy2 = movingBG1.textCoordy2;
    
    movingBG4.w = movingBG1.w;
    movingBG4.x = movingBG3.x - movingBG1.w;
    movingBG4.r = 0.0f;
    
    movingBG4.textCoordx1 = 0.0f;
    movingBG4.textCoordx2 = (IS_IPHONE_5 ? 1200.0f : 1000.0f)/2048.0f;
    
    movingBG4.textID = TEXTURE_LBOX;
    movingBG4.visible = TRUE;
    movingBG4.alpha = 1.0f;
    movingBG4.followShift = true;
    
    movingObj1.textID = TEXTURE_LBOX;
    movingObj1.visible = TRUE;
    movingObj1.alpha = 1.0f;
    movingObj1.followShift = true;

    movingObj2.w = movingObj1.w;
    movingObj2.h = movingObj1.h;
    movingObj2.x = movingObj1.x;
    movingObj2.y = movingObj1.y;
    movingObj2.r = 0.0f;
    
    movingObj2.textID = TEXTURE_LBOX;
    movingObj2.visible = FALSE;
    movingObj2.alpha = 1.0f;
    movingObj2.followShift = true;
}

-(void) startMove{
    movingObj1.visible = !movingObj1.visible;
    movingObj2.visible = !movingObj2.visible;
    if(displayLen < [userMsg length]){
        displayLen++;
        displayScroll = [[MusicBoxViewController sharedInstance] renderTextLocScroll:600 : 30 * 2
                                                                      :msgColor
                                                                      :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
                                                                      :UITextAlignmentLeft
                                                                                    :[userMsg substringToIndex:displayLen]:TEXTURE_MSG:0:false];
    }
}

-(void)updateMessage:(NSString*)msg isDefault:(BOOL)isDefault{
    userMsg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    isDefaultMsg = isDefault;
    waitTime = 0;
    displayLen = 0;
    displayScroll = 0.0f;
    if (!isDefault) {
        msgObj.alpha = 1.0f;
    }
    [[MusicBoxViewController sharedInstance] renderTextLocAutoSize:600 : 30 * 2
                                                          :msgColor
                                                          :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(48.0)]
                                                          :UITextAlignmentCenter
                                                          :msg:TEXTURE_MSG];
}

@end
