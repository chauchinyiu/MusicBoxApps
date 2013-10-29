//
//  CollectionTableViewCell.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/13/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CollectionTableViewCell : UITableViewCell{
    UILabel *_priceText;
}

@property (nonatomic, strong) UILabel *priceText;
-(void) setPrice:(NSString *) text;
@end
