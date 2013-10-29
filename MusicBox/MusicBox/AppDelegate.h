//
//  AppDelegate.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 10/26/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class MusicBoxViewController;
@class MusicBoxNavController;
 
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MusicBoxViewController *viewController;
@property (strong, nonatomic) MusicBoxNavController *navigationController;
-(float) initialOffset;
-(NSString *) fileExtension;
- (bool) isIOS7;
@end
