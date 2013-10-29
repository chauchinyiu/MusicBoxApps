//
//  ThemeManager.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/29/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongManager.h"
#import "ThemeProtocol.h"


@interface ThemeManager : NSObject{
    MusicBoxThemeType _currentType;
    NSMutableArray *observers;
    NSMutableDictionary *_dictThemeKeyAndName;
}

@property (nonatomic,weak) id <ThemeProtocol> delegate;
+(ThemeManager *) sharedInstance ;

-(MusicBoxThemeType) getCurrentTheme;
-(void) changeToTheme:(MusicBoxThemeType) themetype withDelegate:(id) indelgate;
-(NSArray *) getArrayOfThemes;
-(NSString *)getThemeNameBy:(MusicBoxThemeType) key;
@end
