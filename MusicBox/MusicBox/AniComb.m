//
//  AniComb.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月23日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "AniComb.h"
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@implementation AniComb
const float COMBPOSITION[] = {24,33.5,43,52,61.5,71,80.5,90,99,108.5,118,127,136.5,146,155.5,165,174,183.5,193,202,211.5,221,230.5,239.5};
const int STRIP_TYPE[] = {1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,0,1};

-(void)updateAniObjs:(GLfloat)timeUnits IsAuto:(BOOL)autoplay{
    for (int i = 0; i < 24; i++) {
        if(strip[i].visible){
            timer[i] += timeUnits;
            if (timer[i] > 1.0f) {
                strip[i].visible = false;
            }
        }
    }
}

-(void)handleRotate:(GLfloat)angle{
}


-(void)fillBuffer{
    [[MusicBoxViewController sharedInstance] addAnimationObject:comb];
    for (int i = 0; i < 24; i++) {
        [[MusicBoxViewController sharedInstance] addAnimationObject:strip[i]];
    }
}

-(id)initWithOffSetX:(GLfloat)x OffSetY:(GLfloat)y{
    comb.w = (265.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
    comb.h = (127.0f / STD_HEIGHT) * 2.0f;
    comb.x = ((x + (265.0f / 2.0f)) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
    comb.y = 1.0f - ((y + (127.0f / 2.0f)) / STD_HEIGHT) * 2.0f;
    comb.r = 0.0f;
    
    comb.textCoordx1 = 0.0f;
    comb.textCoordy1 = 0.0f;
    comb.textCoordx2 = 530.0f/1024.0f;
    comb.textCoordy2 = 253.0f/256.0f;
    comb.textID = TEXTURE_COMB;
    comb.visible = TRUE;
    
    for (int i = 0; i < 24; i++) {
        strip[i].w = (8.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f;
        strip[i].h = (39.0f / STD_HEIGHT) * 2.0f;
        strip[i].x = ((x + COMBPOSITION[i]) / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * 2.0f - 1.0f;
        strip[i].y = 1.0f - ((y + 31) / STD_HEIGHT) * 2.0f;
        strip[i].r = 0.0f;

        strip[i].textCoordy1 = 0.0f;
        strip[i].textCoordy2 = 77.0f/256.0f;
        if(STRIP_TYPE[i]==1){
            strip[i].textCoordx1 = 530.0f/1024.0f;
            strip[i].textCoordx2 = (530.0f + 16.0f)/1024.0f;
        }
        else{
            strip[i].textCoordx1 = (530.0f + 16.0f)/1024.0f;
            strip[i].textCoordx2 = (530.0f + 16.0f + 15.0f)/1024.0f;
        }
        strip[i].textID = TEXTURE_COMB;
        strip[i].visible = false;
    }
    
    
    return self;
}

-(void)startPinLocations:(NSArray *) indexs{
    for(int i=0 ; i<[indexs count] ; i++){
        NSNumber *number = (NSNumber*)[indexs objectAtIndex:i];
        strip[[number intValue]].visible = true;
        timer[[number intValue]] = 0.0f;
    }
}

-(void)removeAllPins{
    for (int i = 0; i < 24; i++) {
        strip[i].visible = false;
    }
}


@end
