//
//  NSString_MusicConstants.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/12/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE_5B ( ( ( double )[ [ UIScreen mainScreen ] bounds ].size.height / ( double )[ [ UIScreen mainScreen ] bounds ].size.width  ) > 1.6 )

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

typedef enum  {
    VALENTINE,
    CHRISTMAS,
    CLASSIC,
    CARNIVAL
} MusicBoxThemeType;
#define PRODUCT_IDENTIFIER_CLASSIC  @"com.woowtag.mobile.musicboxtheatre.classic"
#define PRODUCT_IDENTIFIER_CARNIVAL @"com.woowtag.mobile.musicboxtheatre.carnival"

#define TEXTURE_BG    0
#define TEXTURE_LBOX  1
#define TEXTURE_PHOTO 2
#define TEXTURE_PHOTO_MSG 3
#define TEXTURE_PHOTO1 4
#define TEXTURE_PHOTO2 5
#define TEXTURE_PHOTO3 6
#define TEXTURE_TEXT  7
#define TEXTURE_TEXT2 8
#define TEXTURE_DEC_B 9
#define TEXTURE_WHEEL 10
#define TEXTURE_COMB  11
#define TEXTURE_VGEAR 12
#define TEXTURE_GEAR  13
#define TEXTURE_MSG   14
#define TEXTURE_DEC_F 15
#define TEXTURE_PLAY  16
#define TEXTURE_ANI_STYLE   17
#define TEXTURE_ANI_MSG     18
#define TEXTURE_ANI_STYLE_1_0 19
#define TEXTURE_ANI_STYLE_2_0 20
#define TEXTURE_ANI_STYLE_3_0 21
#define TEXTURE_ANI_STYLE_1_1 22
#define TEXTURE_ANI_STYLE_2_1 23
#define TEXTURE_ANI_STYLE_3_1 24
#define TEXTURE_ANI_STYLE_1_2 25
#define TEXTURE_ANI_STYLE_2_2 26
#define TEXTURE_ANI_STYLE_3_2 27
#define TEXTURE_PLAY_GUI      28


#define TOUCH_OBJ_NONE      0
#define TOUCH_OBJ_PLAY_BTN  1
#define TOUCH_OBJ_HANDLE    2
#define TOUCH_OBJ_MSG_BAR   3
#define TOUCH_OBJ_PHOTO     4
#define TOUCH_OBJ_PLAY_TAB_DOWN 5
#define TOUCH_OBJ_PLAY_TAB_UP   6
#define TOUCH_OBJ_PLAY_RECORD   7

#define PHOTO_SIZE  512

#define PLAY_BUTTON_STATE_NOT_SHOWING   0
#define PLAY_BUTTON_STATE_SHOW_TAB      1
#define PLAY_BUTTON_STATE_SHOW_FULL     2


// theme name

#define VALENTINE_NAME @"valentine"
#define CHRISTMAS_NAME @"christmas"
#define CLASSIC_NAME @"classic"
#define CARNIVAL_NAME @"carnival"
