//
//  CollectionDelegate.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 12/2/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CollectionProtocol <NSObject>
-(void) changeThemeTo:(MusicBoxThemeType) theme;
@end
