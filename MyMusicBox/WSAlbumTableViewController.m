//
//  WSAlbumTableViewController.m
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

#import "WSAlbumTableViewController.h"
#import "WSAssetPickerState.h"
#import "WSAssetTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"


@interface WSAlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assetGroups; // Model (all groups of assets).
@end


@implementation WSAlbumTableViewController

@synthesize assetPickerState = _assetPickerState;
@synthesize assetsLibrary = _assetsLibrary;
@synthesize assetGroups = _assetGroups;


#pragma mark - Getters 

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)assetGroups
{
    if (!_assetGroups) {
        _assetGroups = [NSMutableArray array];
    }
    
    return _assetGroups;
}

#pragma mark - View Lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    
    self.assetPickerState.state = WSAssetPickerStatePickingAlbum;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Loading…";
    
    UIView *righttoolbar;
    UIButton *cancelBtn;

    if([MusicBoxAppDelegate isIOS7]){
        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 , 33)];
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 95, 26)];
        [self setButtonStyle:cancelBtn];
        [cancelBtn setTitle:NSLocalizedString(@"CANCEL_BTN", @"CANCEL_BTN") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [righttoolbar addSubview:cancelBtn];
    }
    else{
        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 , 44)];
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 95, 35)];
        [self setButtonStyle:cancelBtn];
        [cancelBtn setTitle:NSLocalizedString(@"CANCEL_BTN", @"CANCEL_BTN") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [righttoolbar addSubview:cancelBtn];
    }
    
    UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
    self.navigationItem.rightBarButtonItem =  rightBtn;
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // If group is nil, the end has been reached.
        if (group == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.title = @"";
            });
            return;
        }
        
        // Add the group to the array.
        [self.assetGroups addObject:group];
        
        // Reload the tableview on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failureBlock:^(NSError *error) {
        // TODO: User denied access. Tell them we can't do anything.
    }];
}


- (void)setButtonStyle:(UIButton*) b{
    b.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(17.0)];
    [b setTitleColor: [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0] forState:UIControlStateNormal];
    b.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    b.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
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


#pragma  mark - Actions

- (void)cancelButtonAction:(id)sender 
{    
    self.assetPickerState.state = WSAssetPickerStatePickingCanceled;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WSAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get the group from the datasource.
    if(self.assetGroups.count > indexPath.row){

        ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
        [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
        
        // Setup the cell.
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
        cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.assetGroups.count > indexPath.row){
        ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
        [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
        
        WSAssetTableViewController *assetTableViewController = [[WSAssetTableViewController alloc] initWithStyle:UITableViewStylePlain];
        assetTableViewController.assetPickerState = self.assetPickerState;
        assetTableViewController.assetsGroup = group;
        
        [self.navigationController pushViewController:assetTableViewController animated:YES];
    }
}

#define ROW_HEIGHT 57.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	return ROW_HEIGHT;
}

@end
