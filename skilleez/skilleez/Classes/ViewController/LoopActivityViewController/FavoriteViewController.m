//
//  FavoriteViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FavoriteViewController.h"
#import "SimpleTableCell.h"
#import "ActivityIndicatorController.h"
#import "NetworkManager.h"
#import "HomeViewController.h"
#import "UtilityController.h"

static NSString *cellName = @"FavoriteTableCell";

@interface FavoriteViewController () {
    NSMutableArray *items;
    int count, offset;
    BOOL canLoadOnScroll, showView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) UILabel *emptyTableLabel;

@end

@implementation FavoriteViewController

- (id)initWithParent:(UIViewController *)parentController
{
    if (self = [super init]) {
        self.parent = parentController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    canLoadOnScroll = YES;
    showView = YES;
    count = NUMBER_OF_ITEMS;
    offset = 0;
    [self loadFavoriteList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFavoriteInBackground:(count + offset) offset:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 417;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(selectProfile:)];
        [cell.avatarImg addGestureRecognizer:tap];
    }
    [cell setSkilleezData:cell andSkilleez:[items objectAtIndex:indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height - self.tableView.contentOffset.y == 504 && canLoadOnScroll) {
        [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
        count = NUMBER_OF_ITEMS;
        offset = [items count];
        canLoadOnScroll = NO;
        [self loadFavoriteList];
    }
}

#pragma mark - SimpleTableCellDelegate

- (void)didProfileSelect:(NSString *)profileId
{
    [[UtilityController sharedInstance] profileSelect:profileId onController:self.parent];
}

- (void)didSkiilleSelect:(SkilleeModel *)skillee
{
    offset = 0;
    count = NUMBER_OF_ITEMS;
    canLoadOnScroll = NO;
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [self loadFavoriteList];
}

#pragma mark - Class methods

- (void)loadFavoriteList
{
    [[NetworkManager sharedInstance] getFavoriteList:count offset:offset withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            [self.emptyTableLabel removeFromSuperview];
            NSArray* skilleeList = requestResult.returnArray;
            if (offset > 0) {
                [items addObjectsFromArray:skilleeList];
                [self.tableView reloadData];
                
            } else if ((![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:items] && [skilleeList count] > 0) || ([skilleeList count] == 0 && [items count] == 1)) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            canLoadOnScroll = YES;
            [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
            if ([items count] == 0)
                self.emptyTableLabel = [[UtilityController sharedInstance] showEmptyView:self text:@"You have no skilleez in favorites. Please add some, to see them here"];
            [self.view addSubview:self.emptyTableLabel];
        } else {
            [[UtilityController sharedInstance] showFailureAlert:requestResult.error withCaption:@"Load Favorites failed"];
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (showView) {
            [[UtilityController sharedInstance] showAnotherViewController:self];
            showView = NO;
        }
    }];
}

- (void)loadFavoriteInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getFavoriteList:counts offset:offsets withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:items toOther:skilleeList]) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"loadSkilleeInBackground error: %@", requestResult.error);
        }
    }];
}

- (void)allowLoadOnScroll
{
    canLoadOnScroll = YES;
}

@end
