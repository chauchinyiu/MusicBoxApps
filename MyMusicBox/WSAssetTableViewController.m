//
//  WSAssetTableViewController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSAssetTableViewController.h"
#import "WSAssetPickerState.h"
#import "WSAssetsTableViewCell.h"
#import "WSAssetWrapper.h"
#import "AppDelegate.h"

#define ASSET_WIDTH_WITH_PADDING 79.0f

@interface WSAssetTableViewController () <WSAssetsTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *fetchedAssets;
@property (nonatomic, readonly) NSInteger assetsPerRow;
@end


@implementation WSAssetTableViewController

@synthesize assetPickerState = _assetPickerState;
@synthesize assetsGroup = _assetsGroup;
@synthesize fetchedAssets = _fetchedAssets;
@synthesize assetsPerRow =_assetsPerRow;


#pragma mark - View Lifecycle

#define TABLEVIEW_INSETS UIEdgeInsetsMake(2, 0, 2, 0);


UIView *righttoolbar;
UIView *lefttoolbar;
UIButton *clearBtn;
UIButton *doneBtn;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    
    // Setup the toolbar if there are items in the navigationController's toolbarItems.
    if (self.navigationController.toolbarItems.count > 0) {
        self.toolbarItems = self.navigationController.toolbarItems;
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    self.assetPickerState.state = WSAssetPickerStatePickingAssets;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Hide the toolbar in the event it's being displayed.
    if (self.navigationController.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    if ([MusicBoxAppDelegate isIOS7]) {
        
        self.navigationItem.title = @"Loading";
        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130 , 33)];
        lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 , 33)];
        
        if(NSLocalizedString(@"CLEAR_BTN", @"CLEAR_BTN").length > 8){
            clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 120,26)];
            [clearBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        }
        else{
            clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60,26)];
            [clearBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
        }
        [self setButtonStyle:clearBtn];
        [clearBtn setTitle:NSLocalizedString(@"CLEAR_BTN", @"CLEAR_BTN") forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [lefttoolbar addSubview:clearBtn];
        
        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 120,26)];
        [self setButtonStyle:doneBtn];
        [doneBtn setTitle:NSLocalizedString(@"DONE_BTN", @"DONE_BTN") forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [righttoolbar addSubview:doneBtn];
    }
    else{
        self.navigationItem.title = @"Loading";
        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130 , 44)];
        lefttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 , 44)];
        
        if(NSLocalizedString(@"CLEAR_BTN", @"CLEAR_BTN").length > 8){
            clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 120,35)];
            [clearBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        }
        else{
            clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 60,35)];
            [clearBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
        }
        [self setButtonStyle:clearBtn];
        [clearBtn setTitle:NSLocalizedString(@"CLEAR_BTN", @"CLEAR_BTN") forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [lefttoolbar addSubview:clearBtn];
        
        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 120,35)];
        [self setButtonStyle:doneBtn];
        [doneBtn setTitle:NSLocalizedString(@"DONE_BTN", @"DONE_BTN") forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [righttoolbar addSubview:doneBtn];
    }

    UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
    self.navigationItem.rightBarButtonItem =  rightBtn;
    UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:lefttoolbar];
    self.navigationItem.leftBarButtonItem =  leftBtn;
    
    // TableView configuration.
    self.tableView.contentInset = TABLEVIEW_INSETS;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    
    
    // Fetch the assets.
    [self fetchAssets];
    [self refreshButtonCaption];
}

- (void)setButtonStyle:(UIButton*) b{
    b.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(17.0)];
    [b setTitleColor: [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0] forState:UIControlStateNormal];
    b.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    b.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
}


- (void)refreshButtonCaption{

    NSString *s = NSLocalizedString(@"DONE_BTN", @"DONE_BTN");
    s = [s stringByAppendingString:[NSString stringWithFormat:@" (%d", self.assetPickerState.selectedCount]];
    s = [s stringByAppendingString:@"/"];
    s = [s stringByAppendingString:[NSString stringWithFormat:@"%d", self.assetPickerState.selectionLimit]];
    s = [s stringByAppendingString:@")"];

    [doneBtn setTitle:s forState:UIControlStateNormal];
}

#pragma mark - Getters

- (NSMutableArray *)fetchedAssets
{
    if (!_fetchedAssets) {
        _fetchedAssets = [NSMutableArray array];
    }
    return _fetchedAssets;
}

- (NSInteger)assetsPerRow
{
    return MAX(1, (NSInteger)floorf(self.tableView.contentSize.width / ASSET_WIDTH_WITH_PADDING));
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeRight)||(interfaceOrientation==UIInterfaceOrientationLandscapeLeft)) {
        
        return YES;
    } else {
        return NO;
    }
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
}


#pragma mark - Fetching Code

- (void)fetchAssets
{
    // TODO: Listen to ALAssetsLibrary changes in order to update the library if it changes. 
    // (e.g. if user closes, opens Photos and deletes/takes a photo, we'll get out of range/other error when they come back.
    // IDEA: Perhaps the best solution, since this is a modal controller, is to close the modal controller.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (!result || index == NSNotFound) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.navigationItem.title = @"";
                });
                
                return;
            }
            
            WSAssetWrapper *assetWrapper = [[WSAssetWrapper alloc] initWithAsset:result];
            NSString* test1 = [result.defaultRepresentation.url absoluteString];
            for (int i = 0; i < [self.assetPickerState.preSelectedPhotos count]; i++) {
                if ([test1 isEqualToString: (NSString*)[self.assetPickerState.preSelectedPhotos objectAtIndex:i]]) {
                    assetWrapper.selected = true;
                    [self.assetPickerState changeSelectionState:true forAsset:assetWrapper.asset];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.fetchedAssets addObject:assetWrapper];
                
            });
            
        }];
    });

    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - Actions

- (void)doneButtonAction:(id)sender
{     
    self.assetPickerState.state = WSAssetPickerStatePickingDone;
    
}

- (void)clearButtonAction:(id)sender
{
    for (int i = 0; i < self.fetchedAssets.count; i++) {
        WSAssetWrapper *assetWrapper = [self.fetchedAssets objectAtIndex:i];
        assetWrapper.selected = false;
        [self.assetPickerState changeSelectionState:false forAsset:assetWrapper.asset];
    }
    for (int i = 0; i < [self.tableView visibleCells].count; i++) {
        [((WSAssetsTableViewCell*)[[self.tableView visibleCells] objectAtIndex:i])clearSelection];
    }    
    [self refreshButtonCaption];
    
}


#pragma mark - WSAssetsTableViewCellDelegate Methods

- (BOOL)assetsTableViewCell:(WSAssetsTableViewCell *)cell shouldSelectAssetAtColumn:(NSUInteger)column
{
    BOOL shouldSelectAsset = (self.assetPickerState.selectionLimit == 0 ||
                              (self.assetPickerState.selectedCount < self.assetPickerState.selectionLimit));
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    
    if(self.fetchedAssets.count > assetIndex){
        WSAssetWrapper *assetWrapper = [self.fetchedAssets objectAtIndex:assetIndex];
    
        if ((shouldSelectAsset == NO) && (assetWrapper.isSelected == NO))
            self.assetPickerState.state = WSAssetPickerStateSelectionLimitReached;
        else
            self.assetPickerState.state = WSAssetPickerStatePickingAssets;
    }
    return shouldSelectAsset;
}

- (void)assetsTableViewCell:(WSAssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Calculate the index of the corresponding asset.
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    
    if(self.fetchedAssets.count > assetIndex){
        WSAssetWrapper *assetWrapper = [self.fetchedAssets objectAtIndex:assetIndex];
        assetWrapper.selected = selected;
    
        // Update the state object's selectedAssets.
        [self.assetPickerState changeSelectionState:selected forAsset:assetWrapper.asset];
    }
    [self refreshButtonCaption];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.fetchedAssets.count + self.assetsPerRow - 1) / self.assetsPerRow;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{    
    NSRange assetRange;
    assetRange.location = indexPath.row * self.assetsPerRow;
    assetRange.length = self.assetsPerRow;
    
    // Prevent the range from exceeding the array length.
    if (assetRange.location >= self.fetchedAssets.count) {
        assetRange.location = self.fetchedAssets.count - 1;
        assetRange.length = 0;
    }
    else if (assetRange.length > self.fetchedAssets.count - assetRange.location) {
        assetRange.length = self.fetchedAssets.count - assetRange.location;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    
    // Return the range of assets from fetchedAssets.
    return [self.fetchedAssets objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"WSAssetCell";
    WSAssetsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[WSAssetsTableViewCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:AssetCellIdentifier];        
    } else {
        
        cell.cellAssetViews = [self assetsForIndexPath:indexPath];
    }
    cell.delegate = self;
    [self refreshButtonCaption];
    
    return cell;
}


#pragma mark - Table view delegate

#define ROW_HEIGHT 79.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	return ROW_HEIGHT;
}

@end
