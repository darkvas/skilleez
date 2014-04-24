//
//  ChildApprovalViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildApprovalViewController.h"

static NSString *skilleeCellName = @"ChildApprovalTableCell";
static NSString *invitationCellName = @"InviteToLoopApprovalTableCell";

@interface ChildApprovalViewController () {
    NSMutableArray *_items;
    BOOL _showView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;


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
    nib = [UINib nibWithNibName:invitationCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:invitationCellName];
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
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[_items objectAtIndex:indexPath.row] andApproveOpportunity:YES];
    [self.parent.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]]) {
        SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:skilleeCellName];
        cell.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(selectProfile:)];
        [cell.avatarImg addGestureRecognizer:tap];
        [cell setSkilleezData:cell andSkilleez:[_items objectAtIndex:indexPath.row] andTag:indexPath.row];
        return cell;
    } else {
        InviteToLoopApprovalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:invitationCellName];
        cell.delegate = self;
        LoopInvitationModel *invitation = [_items objectAtIndex:indexPath.row];
        [cell fillCellForInviteeChild:invitation andTag:indexPath.row];
        return cell;
    }
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
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:_items] && [skilleeList count] > 0) {
                _items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
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
