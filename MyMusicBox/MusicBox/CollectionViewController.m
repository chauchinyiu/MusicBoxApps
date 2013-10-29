//
//  CollectionViewController.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 11/10/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "CollectionViewController.h"
#import "PopoverView.h"
#import <Social/Social.h>
#import "iRate.h"
#import <Everyplay/Everyplay.h>
#import "MusicBoxViewController.h"
#import "AppDelegate.h"

@interface CollectionViewController ()
- (void)setNavigationItems;
-(void) goBackToMusicBox;
@end

@implementation CollectionViewController
//static int VALENTINE_CONSTANT_ROW = 0;
//static int CHRISTIMAS_CONSTANT_ROW = 1;
//static int CLASSICS_CONSTANT_ROW = 3;
//static int CARNIVAL_CONSTANT_ROW = 2;
@synthesize hud = _hud;
@synthesize tableView=_tableView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize tableViewCell = _tableViewCell;


ADBannerView * adView;
bool hasAd;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id) inDelegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = inDelegate;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeRight)||(interfaceOrientation==UIInterfaceOrientationLandscapeLeft)) {
        
        return YES;
    } else {
        return NO;
    }
    
    
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

     NSString *bgstring = [NSString stringWithFormat:@"background%@",[MusicBoxAppDelegate fileExtension]];
    [self.backgroundImageView setImage:[UIImage imageNamed:bgstring]];
    [self setNavigationItems];
    [self addAdBannerView];
    
    _arrayThemes = [[ThemeManager sharedInstance] getArrayOfThemes];

    //_skuproducts = [ThemeIAPHelper sharedHelper].products;
    // Do any additional setup after loading the view from its nib.
    //[self restoreAllTransactions];

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([MusicBoxAppDelegate isIOS7]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;        
    }
    #endif
}


- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.tableView.hidden = FALSE;
   // _skuproducts = [ThemeIAPHelper sharedHelper].products;
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ThemeManager sharedInstance] getArrayOfThemes] count] ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CollectionTableViewCell";
    
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        // don't know if it is useful
        [[NSBundle mainBundle] loadNibNamed:@"CollectionTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        
        // new change
        MusicBoxThemeType key =[[_arrayThemes objectAtIndex:indexPath.row] intValue];
        NSString *themeName = [[ThemeManager sharedInstance] getThemeNameBy:key];
        NSString *imagename = [NSString stringWithFormat:@"%@_box_paper%@",themeName,[MusicBoxAppDelegate fileExtension]];

            cell.backgroundView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
   
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
        
        [cell setTheme:key];
        
        
        self.tableViewCell = nil;
    }
    
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BOOL isBuying = NO;
    
    MusicBoxThemeType key =[[_arrayThemes objectAtIndex:indexPath.row] intValue];
    
    MusicBoxThemeType selectedTheme = key;

        [self.delegate changeThemeTo:selectedTheme];
        [self goBackToMusicBox];
 
    
}

- (void)setNavigationItems{
    
    if([MusicBoxAppDelegate isIOS7]){
        UIView *lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 33)];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 70, 26)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:backBtn];
        [backBtn setTitle:NSLocalizedString(@"BACK_BTN", @"BACK_BTN") forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackToMusicBox) forControlEvents:UIControlEventTouchUpInside];
        
        [lefttoolbar addSubview:backBtn];
        
        UIView *righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 33)];
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 60, 26)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:moreBtn];
        [moreBtn setTitle:NSLocalizedString(@"MORE_BTN", @"MORE_BTN") forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(onClickMore) forControlEvents:UIControlEventTouchUpInside];
        
        [righttoolbar addSubview:moreBtn];
        
        UIButton *everyplayBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 27,27)];
        [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button"] forState:UIControlStateNormal];
        [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button_press"] forState:UIControlStateHighlighted];
        [everyplayBtn addTarget:self action:@selector(everyplayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [righttoolbar addSubview:everyplayBtn];
        
        UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
        UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:lefttoolbar];
        self.navigationItem.leftBarButtonItem =  leftBtn;
        self.navigationItem.rightBarButtonItem = rightBtn;

    }
    else{
        UIView *lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 70, 35)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:backBtn];
        [backBtn setTitle:NSLocalizedString(@"BACK_BTN", @"BACK_BTN") forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackToMusicBox) forControlEvents:UIControlEventTouchUpInside];
        
        [lefttoolbar addSubview:backBtn];
        
        UIView *righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160 , 44)];
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 12, 60,35)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:moreBtn];
        [moreBtn setTitle:NSLocalizedString(@"MORE_BTN", @"MORE_BTN") forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(onClickMore) forControlEvents:UIControlEventTouchUpInside];
        
        [righttoolbar addSubview:moreBtn];
        
        UIButton *everyplayBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 50,35)];
        [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button"] forState:UIControlStateNormal];
        [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button_press"] forState:UIControlStateHighlighted];
        [everyplayBtn addTarget:self action:@selector(everyplayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [righttoolbar addSubview:everyplayBtn];
        
        UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
        UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:lefttoolbar];
        self.navigationItem.leftBarButtonItem =  leftBtn;
        self.navigationItem.rightBarButtonItem = rightBtn;
        
    }
    
}


//start from page start
- (void)restoreAllTransactions{
//    [[ThemeIAPHelper sharedHelper] restoreCompletedTransactions];
}
-(void) goBackToMusicBox{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onClickMore{
 
        CGPoint point = CGPointMake(480, 7);
        [PopoverView showMusicBoxSongListPopoverAtPoint:point inView:self.view withTitle:NSLocalizedString(@"MORE_BTN", @"MORE_BTN") withStringArray:[[NSArray alloc] initWithObjects:NSLocalizedString(@"RATE_APP", @"RATE_APP"),NSLocalizedString(@"SHARE_APP", @"SHARE_APP"), NSLocalizedString(@"RESET_INSTRUCTION", @"RESET_INSTRUCTION"), nil] withSelectedIndex:0 delegate:self];

}
  
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    int previous_index = 0;
    //Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.80f];
    [popoverView moveRedPinAnimationfromIndex:previous_index toIndex:index];
    
    if(index == 0){
        [[iRate sharedInstance] promptForRating];
    }else if(index ==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Facebook", @"Twitter", @"Weibo", nil];
        [alert show];
        

    }
    else if(index == 2){
        [[MusicBoxViewController sharedInstance] resetInstruction];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"this is the share button %d", buttonIndex);
    SLComposeViewController *shareController;
    if(buttonIndex==1){
       shareController =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    }else if(buttonIndex==2){
       shareController =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }else if(buttonIndex ==3){
        shareController =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    }else{
        return;
    }
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [shareController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        NSLocale *locale = [NSLocale currentLocale];
        NSString *countryCode = [[locale objectForKey: NSLocaleCountryCode] lowercaseString];
        NSLog(@"countryCode:%@", countryCode);
 
       // [fbController addImage:[UIImage imageNamed:@"AppIcon_72"]];
        [shareController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@/app/my-musicbox-theatre/id659893015?ls=1&mt=8",countryCode]]];
        [shareController setCompletionHandler:completionHandler];
        [self presentViewController:shareController animated:YES completion:nil];
    }
    
}
- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    [self.tableView reloadData];
    
}




- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (IBAction)everyplayButtonPressed:(id)sender {
    [[Everyplay sharedInstance] showEveryplay];
}


#pragma mark - iAd methods
- (void)addAdBannerView{
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        adView = [[ADBannerView alloc] init];
    }
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    CGRect newLoc = adView.frame;
    newLoc.origin.y = [UIScreen mainScreen].bounds.size.height - newLoc.size.height;
    adView.frame = newLoc;
    adView.hidden = true;
    adView.delegate = self;
    [self.view addSubview:adView];
    hasAd = false;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    banner.hidden = true;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    hasAd = true;
    adView.hidden = false;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeav{
    return YES;
}


@end
