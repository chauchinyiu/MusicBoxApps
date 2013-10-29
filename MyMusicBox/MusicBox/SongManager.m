//
//  SongManager.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/30/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "SongManager.h"
@interface SongManager()
-(void) initSongNotesDict;
-(void) initSongNamesDict;
-(void) initSongSpeedsDict;
@end

@implementation SongManager
static SongManager *sharedObject;
+ (SongManager*) sharedInstance
{
    if (sharedObject == nil) {
        sharedObject = [[super allocWithZone:NULL] init];
    }
    
    [sharedObject initDictionaries];
    
    return sharedObject;
}

-(void)initDictionaries{
    [self initSongNamesDict];
    [self initSongNotesDict];
    [self initSongSpeedsDict];
}

-(void) initSongNamesDict{
    if(_songNamesDict == nil){
        _songNamesDict = [[NSMutableDictionary alloc] init];
        //Christmas
        [_songNamesDict setObject:SILENT_NIGHT_NAME forKey:SILENT_NIGHT_KEY];
        [_songNamesDict setObject:HARK_THE_HERALD_ANGELS_SING_NAME forKey:HARK_THE_HERALD_ANGELS_SING_KEY];
        [_songNamesDict setObject:JOY_TO_THE_WORLD_NAME forKey:JOY_TO_THE_WORLD_KEY];
        [_songNamesDict setObject:JINGLE_BELLS_NAME forKey:JINGLE_BELLS_KEY];
        [_songNamesDict setObject:THE_TWELVE_DAYS_OF_CHRISTMAS_NAME forKey:THE_TWELVE_DAYS_OF_CHRISTMAS_KEY];
        [_songNamesDict setObject:THE_FIRST_NOEL_NAME forKey:THE_FIRST_NOEL_KEY];
        //Old Streets
        [_songNamesDict setObject:BRAHMS_LULLABY_NAME forKey:BRAHMS_LULLABY_KEY];
        [_songNamesDict setObject:THE_FOUR_SEASONS_NAME forKey:THE_FOUR_SEASONS_KEY];
        [_songNamesDict setObject:SWAN_LAKE_NAME forKey:SWAN_LAKE_KEY];
        [_songNamesDict setObject:THE_BLUE_DANUBE_NAME forKey:THE_BLUE_DANUBE_KEY];
        [_songNamesDict setObject:CLAIR_DE_LUNE_NAME forKey:CLAIR_DE_LUNE_KEY];
        [_songNamesDict setObject:AMAZING_GRACE_NAME forKey:AMAZING_GRACE_KEY];
        //Fun
        [_songNamesDict setObject:GOOD_MORNING_TO_ALL_NAME forKey:GOOD_MORNING_TO_ALL_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"BIRTHDAY_SONG_NAME", @"BIRTHDAY_SONG_NAME") forKey:BIRTHDAY_SONG_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"FOR_HE_IS_A_JOLLY_GOOD_FELLOW_NAME", @"FOR_HE_IS_A_JOLLY_GOOD_FELLOW_NAME") forKey:FOR_HE_IS_A_JOLLY_GOOD_FELLOW_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"GRADUATION_MARCH_NAME", @"GRADUATION_MARCH_NAME") forKey:GRADUATION_MARCH_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"KISS_MAMA_KISS_PAPA_NAME", @"KISS_MAMA_KISS_PAPA_NAME") forKey:KISS_MAMA_KISS_PAPA_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"LIFE_LET_US_CHERISH_NAME", @"LIFE_LET_US_CHERISH_NAME") forKey:LIFE_LET_US_CHERISH_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"AULD_LANG_SYNE_NAME", @"AULD_LANG_SYNE_NAME") forKey:AULD_LANG_SYNE_KEY];
        [_songNamesDict setObject:PATHETIQUE_NAME forKey:PATHETIQUE_KEY];
        //Valentine
        [_songNamesDict setObject:NSLocalizedString(@"CANON_IN_D_NAME", @"CANON_IN_D_NAME") forKey:CANON_IN_D_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"BEAUTIFUL_DREAMER_NAME", @"BEAUTIFUL_DREAMER_NAME") forKey:BEAUTIFUL_DREAMER_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"LET_ME_CALL_YOU_SWEETHEART_NAME", @"LET_ME_CALL_YOU_SWEETHEART_NAME") forKey:LET_ME_CALL_YOU_SWEETHEART_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"FUR_ELISE_NAME", @"FUR_ELISE_NAME") forKey:FUR_ELISE_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"NOLA_NAME", @"NOLA_NAME") forKey:NOLA_KEY];
        [_songNamesDict setObject:NSLocalizedString(@"WEDDING_MARCH_NAME", @"WEDDING_MARCH_NAME") forKey:WEDDING_MARCH_KEY];
    }

}

-(void) initSongNotesDict{
    if(_songNotesDict == nil){
        _songNotesDict = [[NSMutableDictionary alloc] init];
        //Christmas
        [_songNotesDict setObject:SILENT_NIGHT_NOTES forKey:SILENT_NIGHT_KEY];
        [_songNotesDict setObject:HARK_THE_HERALD_ANGELS_SING_NOTES forKey:HARK_THE_HERALD_ANGELS_SING_KEY];
        [_songNotesDict setObject:JOY_TO_THE_WORLD_NOTES forKey:JOY_TO_THE_WORLD_KEY];
        [_songNotesDict setObject:JINGLE_BELLS_NOTES forKey:JINGLE_BELLS_KEY];
        [_songNotesDict setObject:THE_TWELVE_DAYS_OF_CHRISTMAS_NOTES forKey:THE_TWELVE_DAYS_OF_CHRISTMAS_KEY];
        [_songNotesDict setObject:THE_FIRST_NOEL_NOTES forKey:THE_FIRST_NOEL_KEY];
        //Old Streets
        [_songNotesDict setObject:BRAHMS_LULLABY_NOTES forKey:BRAHMS_LULLABY_KEY];
        [_songNotesDict setObject:THE_FOUR_SEASONS_NOTES forKey:THE_FOUR_SEASONS_KEY];
        [_songNotesDict setObject:SWAN_LAKE_NOTES forKey:SWAN_LAKE_KEY];
        [_songNotesDict setObject:THE_BLUE_DANUBE_NOTES forKey:THE_BLUE_DANUBE_KEY];
        [_songNotesDict setObject:CLAIR_DE_LUNE_NOTES forKey:CLAIR_DE_LUNE_KEY];
        [_songNotesDict setObject:AMAZING_GRACE_NOTES forKey:AMAZING_GRACE_KEY];
        //Fun
        [_songNotesDict setObject:GOOD_MORNING_TO_ALL_NOTES forKey:GOOD_MORNING_TO_ALL_KEY];
        [_songNotesDict setObject:BIRTHDAY_SONG_NOTES forKey:BIRTHDAY_SONG_KEY];
        [_songNotesDict setObject:FOR_HE_IS_A_JOLLY_GOOD_FELLOW_NOTES forKey:FOR_HE_IS_A_JOLLY_GOOD_FELLOW_KEY];
        [_songNotesDict setObject:GRADUATION_MARCH_NOTES forKey:GRADUATION_MARCH_KEY];
        [_songNotesDict setObject:KISS_MAMA_KISS_PAPA_NOTES forKey:KISS_MAMA_KISS_PAPA_KEY];
        [_songNotesDict setObject:LIFE_LET_US_CHERISH_NOTES forKey:LIFE_LET_US_CHERISH_KEY];
        [_songNotesDict setObject:AULD_LANG_SYNE_NOTES forKey:AULD_LANG_SYNE_KEY];
        [_songNotesDict setObject:PATHETIQUE_NOTES forKey:PATHETIQUE_KEY];
        //Valentine
        [_songNotesDict setObject:CANON_IN_D_NOTES forKey:CANON_IN_D_KEY];
        [_songNotesDict setObject:BEAUTIFUL_DREAMER_NOTES forKey:BEAUTIFUL_DREAMER_KEY];
        [_songNotesDict setObject:LET_ME_CALL_YOU_SWEETHEART_NOTES forKey:LET_ME_CALL_YOU_SWEETHEART_KEY];
        [_songNotesDict setObject:FUR_ELISE_NOTES forKey:FUR_ELISE_KEY];
        [_songNotesDict setObject:NOLA_NOTES forKey:NOLA_KEY];
        [_songNotesDict setObject:WEDDING_MARCH_NOTES forKey:WEDDING_MARCH_KEY];
    }
}
-(void) initSongSpeedsDict{
    if(_songSpeedsDict == nil){
        _songSpeedsDict = [[NSMutableDictionary alloc] init];
        //Christmas
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:SILENT_NIGHT_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:HARK_THE_HERALD_ANGELS_SING_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:JOY_TO_THE_WORLD_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f]  forKey:JINGLE_BELLS_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f]  forKey:THE_TWELVE_DAYS_OF_CHRISTMAS_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f]  forKey:THE_FIRST_NOEL_KEY];
        //Classic
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:BRAHMS_LULLABY_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:THE_FOUR_SEASONS_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:SWAN_LAKE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:THE_BLUE_DANUBE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:CLAIR_DE_LUNE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:AMAZING_GRACE_KEY];
        //Fun
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:GOOD_MORNING_TO_ALL_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:BIRTHDAY_SONG_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:FOR_HE_IS_A_JOLLY_GOOD_FELLOW_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:GRADUATION_MARCH_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:KISS_MAMA_KISS_PAPA_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:LIFE_LET_US_CHERISH_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:AULD_LANG_SYNE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:PATHETIQUE_KEY];
        
         //Valentine
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:CANON_IN_D_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:BEAUTIFUL_DREAMER_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:LET_ME_CALL_YOU_SWEETHEART_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:FUR_ELISE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:NOLA_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:WEDDING_MARCH_KEY];
    }

}

-(NSArray *)getThemeSongKeys:(MusicBoxThemeType)theme{
    if(theme == CLASSIC){
        return [NSArray arrayWithObjects:AMAZING_GRACE_KEY,BRAHMS_LULLABY_KEY, THE_FOUR_SEASONS_KEY, SWAN_LAKE_KEY, THE_BLUE_DANUBE_KEY,CLAIR_DE_LUNE_KEY, nil];
    }else if (theme == CARNIVAL){
       return [NSArray arrayWithObjects:BIRTHDAY_SONG_KEY, FOR_HE_IS_A_JOLLY_GOOD_FELLOW_KEY, GRADUATION_MARCH_KEY, KISS_MAMA_KISS_PAPA_KEY, LIFE_LET_US_CHERISH_KEY, AULD_LANG_SYNE_KEY, nil];
    }else if(theme == CHRISTMAS){
       return [NSArray arrayWithObjects:SILENT_NIGHT_KEY, HARK_THE_HERALD_ANGELS_SING_KEY, JOY_TO_THE_WORLD_KEY, THE_FIRST_NOEL_KEY, JINGLE_BELLS_KEY, THE_TWELVE_DAYS_OF_CHRISTMAS_KEY,nil];
    }else {
      return [NSArray arrayWithObjects:CANON_IN_D_KEY, BEAUTIFUL_DREAMER_KEY,LET_ME_CALL_YOU_SWEETHEART_KEY,  FUR_ELISE_KEY, NOLA_KEY, WEDDING_MARCH_KEY,nil];
    }
}
-(NSString *)getSongNote:(NSString*) key{
    return [_songNotesDict objectForKey:key];
}
-(NSString *)getSongName:(NSString*) key{
    return [_songNamesDict objectForKey:key];

}
-(NSNumber *) getNoteSpeed:(NSString*) key{
    NSNumber* notespeed = [_songSpeedsDict objectForKey:key];
    if(notespeed!=nil){
        return notespeed;
    }else{
        return [NSNumber numberWithFloat:0.3f];
    }
  
}
@end
