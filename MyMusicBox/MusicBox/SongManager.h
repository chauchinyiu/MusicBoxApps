//
//  SongManager.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/30/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ThemeManager.h"

/************
 *  KEY -Notes
 *  KEY - Names;
 *  KEY - Speeds 
 ***********/

@interface SongManager : NSObject{
    NSMutableDictionary *_themeSongsDict;
    NSMutableDictionary *_songNotesDict;
    NSMutableDictionary *_songSpeedsDict;
    NSMutableDictionary *_songNamesDict;
}
 

+(SongManager *) sharedInstance;
-(NSArray *)getThemeSongKeys:(MusicBoxThemeType)theme;
-(NSString *)getSongNote:(NSString*) key;
-(NSString *)getSongName:(NSString*) key;
-(NSNumber *) getNoteSpeed:(NSString*) key;
-(void)initDictionaries;
@end
