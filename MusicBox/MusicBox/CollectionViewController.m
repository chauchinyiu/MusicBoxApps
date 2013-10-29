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
    
    _arrayThemes = [[ThemeManager sharedInstance] getArrayOfThemes];
    
    _skuproducts = [ThemeIAPHelper sharedHelper].products;
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
    _skuproducts = [ThemeIAPHelper sharedHelper].products;
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
        if ([ThemeIAPHelper isInAppPurchaseProduct:key]) {
            BOOL isPurchased = NO;
            for(int i=0; i<[_skuproducts count]; i++){
                SKProduct *product = [_skuproducts objectAtIndex:i];
                NSLog(@"%@ , key:: %@",[ThemeIAPHelper sharedHelper].purchasedProducts,product.productIdentifier);
                if([[ThemeIAPHelper sharedHelper].purchasedProducts containsObject:product.productIdentifier]){
                    isPurchased = YES;
                    break;
                }
            }
            if(isPurchased){
                cell.backgroundView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
            }else{
                SKProduct *product  = [[ThemeIAPHelper sharedHelper] getSKProductByThemeType:key];
                
                NSString *imageglassname = [NSString stringWithFormat:@"%@_box_paper_glass%@",themeName,[MusicBoxAppDelegate fileExtension]];
                cell.backgroundView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:imageglassname]];
                [cell setPrice: [self formatedPrice:product]] ;
            }
        }else{
            cell.backgroundView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
        }
        
        
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
        self.tableViewCell = nil;
    }
    
    
    return cell;
}

-(NSString *) formatedPrice:(SKProduct*) product{
    if(product==nil){
        return @"$ 0.99";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    NSLog(@"price :: %@",formattedString);
    return formattedString;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isBuying = NO;
    
    MusicBoxThemeType key =[[_arrayThemes objectAtIndex:indexPath.row] intValue];
    
    MusicBoxThemeType selectedTheme = key;
    if([ThemeIAPHelper isInAppPurchaseProduct:key]){
        if(key==CLASSIC){
            isBuying =![[NSUserDefaults standardUserDefaults] boolForKey:PRODUCT_IDENTIFIER_CLASSIC];
        }else if(key==CARNIVAL){
            isBuying =![[NSUserDefaults standardUserDefaults] boolForKey:PRODUCT_IDENTIFIER_CARNIVAL];
        }
        
        
    }
    
    
    if( [ThemeIAPHelper isInAppPurchaseProduct:key] && isBuying ){
        
        SKProduct *product = [[ThemeIAPHelper sharedHelper] getSKProductByThemeType:key];
        if(product!=nil){
            [[ThemeIAPHelper sharedHelper] buyProduct:product];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Buying Theme...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
        }else{
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"No Internet Connection! Please Try Later"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil] ;
            
            [alert show];
        }
        
    }else{
        [self.delegate changeThemeTo:selectedTheme];
        [self goBackToMusicBox];
    }
    
    
    
    
}

//- (void)setNavigationItems{
//
//    UIView *lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 80, 35)];
//    [backBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"back_button_press"] forState:UIControlStateHighlighted];
//    [backBtn addTarget:self action:@selector(goBackToMusicBox) forControlEvents:UIControlEventTouchUpInside];
//    [lefttoolbar addSubview:backBtn];
//
//    UIView *righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160 , 44)];
//    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 12, 100,35)];
//    [moreBtn setImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
//    [moreBtn setImage:[UIImage imageNamed:@"more_button_press"] forState:UIControlStateHighlighted];
//    [moreBtn addTarget:self action:@selector(onClickMore) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [righttoolbar addSubview:moreBtn];
//
//    UIButton *everyplayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100,35)];
//    [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button"] forState:UIControlStateNormal];
//    [everyplayBtn setImage:[UIImage imageNamed:@"everyplay_button_press"] forState:UIControlStateHighlighted];
//    [everyplayBtn addTarget:self action:@selector(everyplayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [righttoolbar addSubview:everyplayBtn];
//
//
//    UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
//    UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:lefttoolbar];
//    self.navigationItem.leftBarButtonItem =  leftBtn;
//    self.navigationItem.rightBarButtonItem = rightBtn;
//
//}

- (void)setNavigationItems{
    
    if([MusicBoxAppDelegate isIOS7]){
        UIView *lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 33)];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 70, 26)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:backBtn];
        [backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackToMusicBox) forControlEvents:UIControlEventTouchUpInside];
        
        [lefttoolbar addSubview:backBtn];
        
        UIView *righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 33)];
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 60, 26)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:moreBtn];
        [moreBtn setTitle:@"More" forState:UIControlStateNormal];
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
        [backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackToMusicBox) forControlEvents:UIControlEventTouchUpInside];
        
        [lefttoolbar addSubview:backBtn];
        
        UIView *righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160 , 44)];
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 12, 60,35)];
        [[MusicBoxViewController sharedInstance] setButtonStyle:moreBtn];
        [moreBtn setTitle:@"More" forState:UIControlStateNormal];
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
    [[ThemeIAPHelper sharedHelper] restoreCompletedTransactions];
}
-(void) goBackToMusicBox{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onClickMore{
    
    CGPoint point = CGPointMake(480, 7);
    [PopoverView showMusicBoxSongListPopoverAtPoint:point inView:self.view withTitle:@"More" withStringArray:[[NSArray alloc] initWithObjects:@"Rate/Comments the App",@"Share the App", nil] withSelectedIndex:0 delegate:self];
    
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    int previous_index = 0;
    //Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.80f];
    [popoverView moveRedPinAnimationfromIndex:previous_index toIndex:index];
    
    if(index == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/musicboxtheatre"]];
        
    }else if(index ==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Facebook", @"Twitter", @"Weibo", nil];
        [alert show];
        
        
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
        [shareController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@/app/musicbox-theatre-christmas/id586031969?mt=8",countryCode]]];
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
- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] ;
        
        [alert show];
    }
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:@"No Internet Connection!"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] ;
        
        [alert show];
        
        
    } else {
        
        if ([ThemeIAPHelper sharedHelper].products == nil) {
            self.tableView.hidden = true;
            [[ThemeIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading ";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }
    }
    
    [super viewWillAppear:animated];
}

- (IBAction)everyplayButtonPressed:(id)sender {
    [[Everyplay sharedInstance] showEveryplay];
}

@end
