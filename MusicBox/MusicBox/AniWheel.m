//
//  AniWheel.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月22日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniWheel.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniWheel

const float PINPOSITION[] = {45,54,63.5,73,82,91,101,110,120,129,138,148,157,166,176,185,195,204,213,223,232,241,251,260};


-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    if (autoplay) {
        [self handleRotate:timeUnits];
    }
}

-(void)handleRotate:(GLfloat)angle{
    if (angle > 0) {
        for (int i = 0; i < 100; i++) {
            if(pins[i].visible){
                pins[i].y += angle / 15.0f;
                if (pins[i].y > wheelMask.y + (wheelMask.h - pins[i].h)/ 2) {
                    pins[i].visible = FALSE;
                }
            }
        }
    }
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:wheelShadow];
    [[MusicBoxViewController sharedInstance] addAnimationObject:wheel];
    [[MusicBoxViewController sharedInstance] addAnimationObject:blackOnWheel];
    [[MusicBoxViewController sharedInstance] addAnimationObject:blackStick];
    for (int i = 0; i < 100; i++) {
        [[MusicBoxViewController sharedInstance] addAnimationObject:pins[i]];
    }
    [[MusicBoxViewController sharedInstance] addAnimationObject:wheelMask];
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    objX = x;
    objY = y;

    pinIndex = 0;
    for (int i = 0; i < 100; i++) {
        pins[i].w = (12.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
        pins[i].h = (12.0f / STD_HEIGHT) * 2.0f;
        pins[i].r = 0.0f;
        
        pins[i].textCoordx1 = 518.0f/1024.0f;
        pins[i].textCoordy1 = (230.0f + 106.0f)/512.0f;
        pins[i].textCoordx2 = (518.0f + 23.0f)/1024.0f;
        pins[i].textCoordy2 = (230.0f + 106.0f + 24.0f)/512.0f;
        pins[i].textID = TEXTURE_WHEEL;
        pins[i].visible = FALSE;
    }
    
    wheelShadow.w = (327.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    wheelShadow.h = (159.0f / STD_HEIGHT) * 2.0f;
    wheelShadow.x = ((x + (327.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    wheelShadow.y = 1.0f - ((y + (159.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    wheelShadow.r = 0.0f;
    
    wheelShadow.textCoordx1 = 598.0f/1024.0f;
    wheelShadow.textCoordy1 = 0.0f;
    wheelShadow.textCoordx2 = (597.0f + 327.0f)/1024.0f;
    wheelShadow.textCoordy2 = 159.0f/512.0f;
    wheelShadow.textID = TEXTURE_WHEEL;
    wheelShadow.visible = TRUE;

    
    wheel.w = (299.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    wheel.h = (115.0f / STD_HEIGHT) * 2.0f;
    wheel.x = ((x + (299.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    wheel.y = 1.0f - ((y + (115.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    wheel.r = 0.0f;
    
    wheel.textCoordx1 = 0.0f;
    wheel.textCoordy1 = 0.0f;
    wheel.textCoordx2 = 597.0f/1024.0f;
    wheel.textCoordy2 = 230.0f/512.0f;
    wheel.textID = TEXTURE_WHEEL;
    wheel.visible = TRUE;

    wheelMask.w = (259.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    wheelMask.h = (94.0f / STD_HEIGHT) * 2.0f;
    wheelMask.x = ((x + 23 + (259.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    wheelMask.y = 1.0f - ((y + 10 + (94.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    wheelMask.r = 0.0f;
    
    wheelMask.textCoordx1 = 0.0f;
    wheelMask.textCoordy1 = 230.0f/512.0f;
    wheelMask.textCoordx2 = 518.0f/1024.0f;
    wheelMask.textCoordy2 = (230.0f + 188.0f)/512.0f;
    wheelMask.textID = TEXTURE_WHEEL;
    wheelMask.visible = TRUE;
    
    blackOnWheel.w = (14.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    blackOnWheel.h = (54.0f / STD_HEIGHT) * 2.0f;
    blackOnWheel.x = ((x + 3 + (14.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    blackOnWheel.y = 1.0f - ((y + 30 + (54.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    blackOnWheel.r = 0.0f;
    
    blackOnWheel.textCoordx1 = 518.0f/1024.0f;
    blackOnWheel.textCoordy1 = 230.0f/512.0f;
    blackOnWheel.textCoordx2 = (518.0f + 27.0f)/1024.0f;
    blackOnWheel.textCoordy2 = (230.0f + 105.0f)/512.0f;
    blackOnWheel.textID = TEXTURE_WHEEL;
    blackOnWheel.visible = TRUE;

    blackStick.w = (57.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    blackStick.h = (121.0f / STD_HEIGHT) * 2.0f;
    blackStick.x = ((x - 1 + (57.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    blackStick.y = 1.0f - ((y + 80 + (121.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    blackStick.r = 0.0f;
    
    blackStick.textCoordx1 = (518.0f + 27.0f)/1024.0f;
    blackStick.textCoordy1 = 230.0f/512.0f;
    blackStick.textCoordx2 = (518.0f + 27.0f + 113.0f)/1024.0f;
    blackStick.textCoordy2 = (230.0f + 239.0f)/512.0f;
    blackStick.textID = TEXTURE_WHEEL;
    blackStick.visible = TRUE;

    return self;
}

-(void)startPinLocations:(NSArray *) indexs{
    for(int i=0 ; i<[indexs count] ; i++){
        pins[pinIndex].visible = TRUE;
        pins[pinIndex].x = ((objX + PINPOSITION[[((NSNumber*)[indexs objectAtIndex:i]) intValue]]) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
        
        pins[pinIndex].y = 1.0f - ((objY + 100 + (12.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
        
        pinIndex++;
        if (pinIndex == 100) {
            pinIndex = 0;
        }
    }


}

-(void)removeAllPins{
    for (int i = 0; i < 100; i++) {
        pins[i].visible = FALSE;
    }    
}
@end
