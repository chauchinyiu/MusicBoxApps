//
//  ThemeManager.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/29/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "ThemeManager.h"
@interface ThemeManager()

@end
@implementation ThemeManager
@synthesize delegate;
static ThemeManager *sharedObject;

+ (ThemeManager*)sharedInstance
{
    if (sharedObject == nil) {
        sharedObject = [[super allocWithZone:NULL] init];
    }

       
     return sharedObject;
}


-(void) changeToTheme:(MusicBoxThemeType) themetype withDelegate:(id) indelgate{
    self.delegate = indelgate;
    if(themetype == CLASSIC){
        _currentType = CLASSIC;
    }else if(themetype == CARNIVAL){
        _currentType = CARNIVAL;
    }else if(themetype == CHRISTMAS){
        _currentType = CHRISTMAS;
    }else {
        _currentType = VALENTINE;
    }
    
    NSArray *songkeys =[[SongManager sharedInstance] getThemeSongKeys:_currentType];
    NSMutableArray *songnames = [[NSMutableArray alloc] init];
    NSMutableArray *songnotes = [[NSMutableArray alloc] init];
    NSMutableArray *notespeeds = [[NSMutableArray alloc] init];
    for(int i=0 ; i< [songkeys count] ; i++){
        NSString *key = [songkeys objectAtIndex:i];
        NSString * name = [[SongManager sharedInstance] getSongName:key];
        NSString * notes= [[SongManager sharedInstance] getSongNote:key];
        NSNumber * notespeed = [[SongManager sharedInstance] getNoteSpeed:key];
        if(name!=nil)
            [songnames addObject:name];
        if(notes!=nil)
            [songnotes addObject:notes];
      
          [notespeeds addObject:notespeed];
    }
    [self.delegate updateSongKeys:songkeys andSongNames:songnames
                     andSongNotes:songnotes withNoteSpeeds:notespeeds];

}

-(MusicBoxThemeType) getCurrentTheme{
    return _currentType;
}

-(NSArray *) getArrayOfThemes{
    return [[NSMutableArray alloc] initWithObjects:
            [NSNumber numberWithInt:VALENTINE],
            [NSNumber numberWithInt:CARNIVAL],
            nil];

}


-(NSString *)getThemeNameBy:(MusicBoxThemeType) key{

    if(_dictThemeKeyAndName == nil){
        _dictThemeKeyAndName = [[NSMutableDictionary alloc] init];
        [_dictThemeKeyAndName setValue:VALENTINE_NAME forKey:[NSString stringWithFormat:@"THEME:%@",[[NSNumber numberWithInt:VALENTINE] stringValue]]];
        [_dictThemeKeyAndName setValue:CLASSIC_NAME forKey:[NSString stringWithFormat:@"THEME:%@",[[NSNumber numberWithInt:CLASSIC] stringValue]]];
        [_dictThemeKeyAndName setValue:CHRISTMAS_NAME forKey:[NSString stringWithFormat:@"THEME:%@",[[NSNumber numberWithInt:CHRISTMAS] stringValue]]];
        [_dictThemeKeyAndName setValue:CARNIVAL_NAME forKey:[NSString stringWithFormat:@"THEME:%@",[[NSNumber numberWithInt:CARNIVAL] stringValue]]];
    }
    
    return [_dictThemeKeyAndName valueForKey:[NSString stringWithFormat:@"THEME:%@",[[NSNumber numberWithInt:key] stringValue]]];
    
}





@end
