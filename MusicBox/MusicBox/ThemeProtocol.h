//
//  DecorationProtocol.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/30/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThemeProtocol <NSObject>
-(void) updateSongKeys:(NSArray *)keys andSongNames:(NSArray *)names andSongNotes:(NSArray *) notes withNoteSpeeds:(NSArray *) notespeeds;

@end
