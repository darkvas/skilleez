//
//  ChildApprovalViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildApprovalViewController.h"

static NSString *skilleeCellName = @"ChildApprovalTableCell";

@interface ChildApprovalViewController () {
    NSMutableArray *_items;
    BOOL _showView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) UILabel *emptyTableLabel;

@end

@implementation ChildApprovalViewController

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
    _showView = YES;
    UINib *nib = [UINib nibWithNibName:skilleeCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:skilleeCellName];
    [self loadWaitingForApprovalList];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self loadWaitingForApprovalInBackground:(count + offset) offset:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 462;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[_items objectAtIndex:indexPath.row] andApproveOpportunity:NO];
    [self.parent.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:skilleeCellName];
    cell.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(selectProfile:)];
    [cell.avatarImg addGestureRecognizer:tap];
    [cell setSkilleezData:cell andSkilleez:[_items objectAtIndex:indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

#pragma mark - SimpleTableCellDelegate

- (void)didProfileSelect:(NSString *)profileId
{
    [[UtilityController sharedInstance] profileSelect:profileId onController:self.parent];
}

- (void)didSkiilleSelect:(SkilleeModel *)skillee
{
    [self loadWaitingForApprovalList];
}

#pragma mark - Class methods

- (void)loadWaitingForApprovalList
{
    [[NetworkManager sharedInstance] getWaitingForApprovalList:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.emptyTableLabel removeFromSuperview];
            NSArray* skilleeList = requestResult.returnArray;
            if ((![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:_items] && [skilleeList count] > 0) || ([skilleeList count] == 0 && [_items count] == 1)) {
                _items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            if ([_items count] == 0)
                self.emptyTableLabel = [[UtilityController sharedInstance] showEmptyView:self text:@"You have no skilleez waiting for approval"];
            [self.view addSubview: self.emptyTableLabel];
        } else {
            [[UtilityController sharedInstance] showFailureAlert:requestResult.error withCaption:@"Load loop failed"];
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (_showView) {
            [[UtilityController sharedInstance] showAnotherViewController:self];
            _showView = NO;
        }
    }];
}

- (void)loadWaitingForApprovalInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getWaitingForApprovalSkilleez:counts offset:offsets withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:_items toOther:skilleeList]) {
                _items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
                [[UtilityController sharedInstance] setBadgeValue:[_items count] forController:self.parent];
            }
        } else {
            NSLog(@"loadSkilleeInBackground error: %@", requestResult.error);
        }
    }];
}

@end
