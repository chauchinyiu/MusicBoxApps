//
//  MusicBoxNavController.m
//  MusicBox
//
//  Created by Ming Kei Wong on 13年5月16日.
//  Copyright (c) 2013年 Chau Chin Yiu. All rights reserved.
//

#import "MusicBoxNavController.h"

@interface MusicBoxNavController ()

@end

@implementation MusicBoxNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate{
    return YES;
}



@end
