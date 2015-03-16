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
//@synthesize songText1 = _songText1;
//@synthesize songText2 = _songText2;
//@synthesize songText3 = _songText3;
//@synthesize songText4 = _songText4;
//@synthesize songText5 = _songText5;
//@synthesize songText6 = _songText6;
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
    _priceText = [[UILabel alloc] initWithFrame:CGRectMake(25+offset, 20, 85, 20)];
    _priceText.text = text;
     _priceText.textColor = [UIColor blackColor];
    _priceText.backgroundColor = [UIColor clearColor];
    _priceText.textAlignment = NSTextAlignmentCenter;
    _priceText.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(16.0)];
    [self addSubview:_priceText];
}


-(void) setSong:(NSString *) text forIndex:(int)i{
    if(text == nil){
        text=@"";
    }
    float offset = 0.0f;
    if(IS_IPHONE_5){
        offset = 44.0f;
    }
    
    UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(240+offset, 50 + i * 18, 180, 20)];
    tmpLabel.text = [NSString stringWithFormat:@"%d. %@", i + 1, text];
    tmpLabel.textColor = [UIColor colorWithRed:59.0f/256.0f
                                         green:34.0f/256.0f
                                          blue:1.0f/256.0f
                                         alpha:1.0f];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    tmpLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(12.0)];
    tmpLabel.numberOfLines = 1;
    tmpLabel.minimumFontSize = 6.;
    tmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:tmpLabel];

}

-(void) setTheme:(MusicBoxThemeType)theme{
    NSArray* names = [[SongManager sharedInstance]getThemeSongKeys:theme];
    for (int i = 0; i < names.count; i++) {
        [self setSong:[[SongManager sharedInstance] getSongName:[names objectAtIndex:i]] forIndex:i];
    }
}



@end
