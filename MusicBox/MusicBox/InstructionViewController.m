//
//  InstructionViewController.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 12/10/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "InstructionViewController.h"
#import "AppDelegate.h"
@interface InstructionViewController ()

@end

@implementation InstructionViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeRight)||(interfaceOrientation==UIInterfaceOrientationLandscapeLeft)) {
        
        return YES;
    } else {
        return NO;
    }
    
    
}
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
    // Do any additional setup after loading the view from its nib.
    NSString *imagename = [NSString stringWithFormat:@"instruction%@",[MusicBoxAppDelegate fileExtension]];
    [self.instructionImgView setImage:[UIImage imageNamed:imagename]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction) dismissTap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
