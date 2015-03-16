//
//  CollectionTableViewCell.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/13/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell
@synthesize priceText = _priceText;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 

-(void) setPrice:(NSString *) text{
    if(text == nil){
        text=@"US $0.99/Euro 0,89€";
    }
    float offset = 0.0f;
    if(IS_IPHONE_5){
        offset = 44.0f;
    }
    _priceText = [[UILabel alloc] initWithFrame:CGRectMake(25+offset, 30, 85, 20)];
    _priceText.text = text;
     _priceText.textColor = [UIColor blackColor];
    _priceText.backgroundColor = [UIColor clearColor];
    _priceText.textAlignment = NSTextAlignmentCenter;
    _priceText.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(16.0)];
    [self addSubview:_priceText];
}


@end
