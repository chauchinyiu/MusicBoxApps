//
//  CollectionViewController.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/10/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionTableViewCell.h"
#import "CollectionProtocol.h"
#import "SongManager.h"
#import "ThemeIAPHelper.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "PopoverView.h"
@interface CollectionViewController  : UIViewController <UITableViewDelegate,UITableViewDataSource,PopoverViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    UIImageView *_backgroundImageView;
    MBProgressHUD *_hud;
    NSArray *_arrayThemes;
    NSArray *_skuproducts;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet  UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet CollectionTableViewCell *tableViewCell;
@property (weak) id <CollectionProtocol> delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id) inDelegate;
@property (nonatomic,strong) MBProgressHUD *hud;
@end
