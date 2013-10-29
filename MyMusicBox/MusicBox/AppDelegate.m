//
//  AppDelegate.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 10/26/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "AppDelegate.h"

#import "MusicBoxViewController.h"
#import "MusicBoxNavController.h"
#import "AppFlood.h"

@interface AppDelegate()
- (void) drawNavigationBar;
@end
@implementation AppDelegate

bool isIOS7Flag;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        isIOS7Flag = false;
    }
    else{
        isIOS7Flag = true;
    }
    
    self.window =  [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MusicBoxViewController alloc] initWithNibName:@"MusicBoxViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[MusicBoxViewController alloc] initWithNibName:@"MusicBoxViewController_iPad" bundle:nil];
    }

    self.navigationController =   [[MusicBoxNavController alloc] initWithRootViewController:self.viewController];
   
    [[self window] setRootViewController:self.navigationController];
    [self drawNavigationBar];
    [self.window makeKeyAndVisible];
   // [[SKPaymentQueue defaultQueue] addTransactionObserver:[ThemeIAPHelper sharedHelper]];
    
    // Initialize Everyplay SDK with our client id and secret.
    // These can be created at https://developers.everyplay.com
    [Everyplay setClientId:@"9ede82acdbfc1e5d4b96662b0eb3eef7ed3d2a99" clientSecret:@"a83e862f7324ca7a3949dece1c3a74450958474b" redirectURI:@"https://m.everyplay.com/auth"];

    // Tell Everyplay to use our rootViewController for presenting views and for delegate calls.
    [Everyplay initWithDelegate:self.viewController andParentViewController:self.window.rootViewController];
    
    [AppFlood initializeWithId:@"UGy4gSYxkwoih4it" key:@"pCY5kRWM1267L51ece3ff" adType: APPFLOOD_AD_ALL];
    return NO;
}

-(float) initialOffset{
    if(IS_IPHONE_5){
        return 26.0f;
    }else{
        return 0;
    }
}

-(NSString *) fileExtension{
    if(IS_IPHONE_5){
        return @"-568h";
    }else{
        return @"";
    }
}

-(bool) isIOS7{
    return isIOS7Flag;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     [self.viewController drawNavigationBar];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) drawNavigationBar{
    UIImage *navigationLandscapeBackground;
    CGRect frame ;
    if (isIOS7Flag) {
        if(IS_IPHONE_5){
            navigationLandscapeBackground  = [UIImage imageNamed:@"navigationBarIOS7-568h.png"];
            frame = CGRectMake(0, 0, 568, 32);
        }else{
            navigationLandscapeBackground  = [UIImage imageNamed:@"navigationBarIOS7"];
            frame = CGRectMake(0, 0, 480, 32);
        }
    }
    else{
        if(IS_IPHONE_5){
            navigationLandscapeBackground  = [UIImage imageNamed:@"navigationBar-568h.png"];
            frame = CGRectMake(0, 0, 568, 44);
        }else{
            navigationLandscapeBackground  = [UIImage imageNamed:@"navigationBar"];
            frame = CGRectMake(0, 0, 480, 44);
        }
    }
    
    [[UINavigationBar appearance] setBackgroundImage:navigationLandscapeBackground
                                       forBarMetrics:UIBarMetricsLandscapePhone];
     [[UINavigationBar appearance] setBackgroundImage:navigationLandscapeBackground                                        forBarMetrics:UIBarMetricsDefault];
    
  //  [self.navigationController.navigationBar drawRect:frame];
}

@end
