//
//  AniNamePlate.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月25日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniNamePlate.h"

@implementation AniNamePlate

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
}

-(void)handleRotate:(GLfloat)angle{
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:plate];
    [[MusicBoxViewController sharedInstance] addAnimationObject:label1];
    [[MusicBoxViewController sharedInstance] addAnimationObject:label2];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    plate.w = (133.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    plate.h = (64.0f / STD_HEIGHT) * 2.0f;
    plate.x = ((x + (133.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    plate.y = 1.0f - ((y + (64.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    plate.r = 0.0f;
    
    plate.textCoordx1 = 1136.0f/2048.0f;
    plate.textCoordy1 = 0.0f;
    plate.textCoordx2 = (1136.0f + 266.0f)/2048.0f;
    plate.textCoordy2 = 128.0f/1024.0f;
    plate.textID = TEXTURE_BG;
    plate.visible = TRUE;
    
    label1.w = ((133.0f - 10.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    label1.h = (40.0f / STD_HEIGHT) * 2.0f;
    label1.x = ((x + 5 + ((133.0f - 10.0f) / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    label1.y = 1.0f - ((y + 5 + (40.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    label1.r = 0.0f;
    
    label1.textCoordx1 = 0.0f;
    label1.textCoordy1 = 0.0f;
    label1.textCoordx2 = ((133.0f - 10.0f) * 2.0f)/256.0f;
    label1.textCoordy2 = 80.0f/256.0f;
    label1.textID = TEXTURE_TEXT2;
    label1.visible = TRUE;
    
    
    label2.w = ((133.0f - 10.0f) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    label2.h = (40.0f / STD_HEIGHT) * 2.0f;
    label2.x = ((x + 5 + ((133.0f - 10.0f) / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    label2.y = 1.0f - ((y + 40 + (40.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    label2.r = 0.0f;
    
    label2.textCoordx1 = 0.0f;
    label2.textCoordy1 = 0.0f;
    label2.textCoordx2 = ((133.0f - 10.0f) * 2.0f)/256.0f;
    label2.textCoordy2 = (80.0f/256.0f);
    label2.textID = TEXTURE_TEXT;
    label2.visible = TRUE;
    
    return self;
}

-(void)setThemeLabel:(NSString *)themestring{
    [[MusicBoxViewController sharedInstance] renderTextLoc:(133 - 10) * 2 :40
                                                          :[UIColor blackColor]
                                                          :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(20.0)]
                                                          :UITextAlignmentCenter
                                                          :themestring:TEXTURE_TEXT];
    
}

-(void)setSongLabel:(NSString *) songString{
    [[MusicBoxViewController sharedInstance] renderTextLoc:(133 - 10) * 2 :80
                                                          :[UIColor blackColor]
                                                          :[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(26.0)]
                                                          :UITextAlignmentCenter
                                                          :songString:TEXTURE_TEXT2];
}
@end
