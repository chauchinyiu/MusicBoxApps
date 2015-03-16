//
//  NSString_MusicConstants.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/12/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#define CD_USE_OWN_FILEUTILS

#define IS_IPHONE_5   ( double )[ [ UIScreen mainScreen ] bounds].size.width >= ( double )568 
#define IS_IPHONE_5B ( ( ( double )[ [ UIScreen mainScreen ] bounds ].size.height / ( double )[ [ UIScreen mainScreen ] bounds ].size.width  ) > 1.6 )

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
typedef enum  {
    VALENTINE,
    CHRISTMAS,
    CLASSIC,
    CARNIVAL
} MusicBoxThemeType;
#define PRODUCT_IDENTIFIER_CLASSIC  @"com.woowtag.mobile.musicboxtheatre.classic"
#define PRODUCT_IDENTIFIER_CARNIVAL @"com.woowtag.mobile.musicboxtheatre.carnival"

#define TEXTURE_BG    0
#define TEXTURE_TEXT  1
#define TEXTURE_TEXT2 2
#define TEXTURE_DEC_B 3
#define TEXTURE_WHEEL 4
#define TEXTURE_COMB  5
#define TEXTURE_VGEAR 6
#define TEXTURE_PLAY  7
#define TEXTURE_LBOX  8
#define TEXTURE_GEAR  9
#define TEXTURE_MSG   10
#define TEXTURE_DEC_F 11

//#define TOUCH_OBJ_NONE      0
//#define TOUCH_OBJ_PLAY_BTN  1
//#define TOUCH_OBJ_HANDLE    2
//#define TOUCH_OBJ_MSG_BAR   3

#define TOUCH_OBJ_NONE      0
#define TOUCH_OBJ_PLAY_BTN  1
#define TOUCH_OBJ_HANDLE    2
#define TOUCH_OBJ_MSG_BAR   3
#define TOUCH_OBJ_PHOTO     4
#define TOUCH_OBJ_PLAY_TAB_DOWN 5
#define TOUCH_OBJ_PLAY_TAB_UP   6
#define TOUCH_OBJ_PLAY_RECORD   7

// theme name

#define VALENTINE_NAME @"valentine"
#define CHRISTMAS_NAME @"christmas"
#define CLASSIC_NAME @"classic"
#define CARNIVAL_NAME @"carnival"
