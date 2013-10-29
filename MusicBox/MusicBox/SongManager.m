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
        [_songNamesDict setObject:TURKISH_MARCH_NAME forKey:TURKISH_MARCH_KEY];
        [_songNamesDict setObject:WILLIAM_TELL_NAME forKey:WILLIAM_TELL_KEY];
        [_songNamesDict setObject:EINE_KLEINE_NACHTMUSIK_NAME forKey:EINE_KLEINE_NACHTMUSIK_KEY];
        [_songNamesDict setObject:MAPLE_LEAF_RAG_NAME forKey:MAPLE_LEAF_RAG_KEY];
        [_songNamesDict setObject:THE_ENTERTAINER_NAME forKey:THE_ENTERTAINER_KEY];
        [_songNamesDict setObject:OVERTURE_NAME forKey:OVERTURE_KEY];
        //Valentine
        [_songNamesDict setObject:FUER_ELISE_NAME forKey:FUER_ELISE_KEY];
        [_songNamesDict setObject:CARMEN_HABANERA_NAME forKey:CARMEN_HABANERA_KEY];
        [_songNamesDict setObject:CANON_IN_D_NAME forKey:CANON_IN_D_KEY];
        [_songNamesDict setObject:REVERIE_NAME forKey:REVERIE_KEY];
        [_songNamesDict setObject:NOCTURNE_NAME forKey:NOCTURNE_KEY];
        [_songNamesDict setObject:STAENDCHEN_NAME forKey:STAENDCHEN_KEY];
        
        
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
        [_songNotesDict setObject:TURKISH_MARCH_NOTES forKey:TURKISH_MARCH_KEY];
        [_songNotesDict setObject:WILLIAM_TELL_NOTES forKey:WILLIAM_TELL_KEY];
        [_songNotesDict setObject:EINE_KLEINE_NACHTMUSIK_NOTES forKey:EINE_KLEINE_NACHTMUSIK_KEY];
        [_songNotesDict setObject:MAPLE_LEAF_RAG_NOTES forKey:MAPLE_LEAF_RAG_KEY];
        [_songNotesDict setObject:THE_ENTERTAINER_NOTES forKey:THE_ENTERTAINER_KEY];
        [_songNotesDict setObject:OVERTURE_NOTES forKey:OVERTURE_KEY];
        //Valentine
        [_songNotesDict setObject:FUER_ELISE_NOTES forKey:FUER_ELISE_KEY];
        [_songNotesDict setObject:CARMEN_HABANERA_NOTES forKey:CARMEN_HABANERA_KEY];
        [_songNotesDict setObject:CANON_IN_D_NOTES forKey:CANON_IN_D_KEY];
        [_songNotesDict setObject:REVERIE_NOTES forKey:REVERIE_KEY];
        [_songNotesDict setObject:NOCTURNE_NOTES forKey:NOCTURNE_KEY];
        [_songNotesDict setObject:STAENDCHEN_NOTES forKey:STAENDCHEN_KEY];
        
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
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:TURKISH_MARCH_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:WILLIAM_TELL_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.15f] forKey:EINE_KLEINE_NACHTMUSIK_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:MAPLE_LEAF_RAG_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:THE_ENTERTAINER_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:OVERTURE_KEY];
        
         //Valentine
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:FUER_ELISE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:CARMEN_HABANERA_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:CANON_IN_D_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.30f] forKey:REVERIE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:NOCTURNE_KEY];
        [_songSpeedsDict setObject:[NSNumber numberWithFloat:0.20f] forKey:STAENDCHEN_KEY];
    }

}

-(NSArray *)getThemeSongKeys:(MusicBoxThemeType)theme{
    if(theme == CLASSIC){
        return [NSArray arrayWithObjects:AMAZING_GRACE_KEY,BRAHMS_LULLABY_KEY, THE_FOUR_SEASONS_KEY, SWAN_LAKE_KEY, THE_BLUE_DANUBE_KEY,CLAIR_DE_LUNE_KEY, nil];
    }else if (theme == CARNIVAL){
       return [NSArray arrayWithObjects:TURKISH_MARCH_KEY ,WILLIAM_TELL_KEY, THE_ENTERTAINER_KEY, EINE_KLEINE_NACHTMUSIK_KEY,MAPLE_LEAF_RAG_KEY, OVERTURE_KEY, nil];
    }else if(theme == CHRISTMAS){
       return [NSArray arrayWithObjects:SILENT_NIGHT_KEY, HARK_THE_HERALD_ANGELS_SING_KEY, JOY_TO_THE_WORLD_KEY, THE_FIRST_NOEL_KEY, JINGLE_BELLS_KEY, THE_TWELVE_DAYS_OF_CHRISTMAS_KEY,nil];
    }else {
      return [NSArray arrayWithObjects:CANON_IN_D_KEY, CARMEN_HABANERA_KEY,FUER_ELISE_KEY,  REVERIE_KEY, NOCTURNE_KEY, STAENDCHEN_KEY,nil];
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
