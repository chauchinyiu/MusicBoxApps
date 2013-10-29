//
//  InstructionViewController.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 12/10/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionViewController : UIViewController{
    UIImageView* _instructionImgView;
}
@property (nonatomic,strong) IBOutlet  UIImageView* instructionImgView;
-(IBAction) dismissTap:(id)sender ;
@end
