//
//  CollectionTableViewCell.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/13/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MusicBoxConstants.h"
#import "SongManager.h"

@interface CollectionTableViewCell : UITableViewCell{
    UILabel *_priceText;
//    UILabel *_songText1;
//    UILabel *_songText2;
//    UILabel *_songText3;
//    UILabel *_songText4;
//    UILabel *_songText5;
//    UILabel *_songText6;
}

@property (nonatomic, strong) UILabel *priceText;
//@property (nonatomic, strong) UILabel *songText1;
//@property (nonatomic, strong) UILabel *songText2;
//@property (nonatomic, strong) UILabel *songText3;
//@property (nonatomic, strong) UILabel *songText4;
//@property (nonatomic, strong) UILabel *songText5;
//@property (nonatomic, strong) UILabel *songText6;

-(void) setPrice:(NSString *) text;
-(void) setTheme:(MusicBoxThemeType)theme;
@end
