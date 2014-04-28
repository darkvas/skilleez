//
//  AdultApprovalViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultApprovalViewController.h"

static NSString *skilleeCellName = @"AdultApprovalTableCell";
static NSString *invitationCellName = @"InviteToLoopApprovalTableCell";

@interface AdultApprovalViewController() {
    NSMutableArray *_items, *_childs;
    BOOL _showView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) UILabel *emptyTableLabel;

@end

@implementation AdultApprovalViewController

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
    [self loadFamilyMembers];
    _showView = YES;
    UINib *nib = [UINib nibWithNibName:skilleeCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:skilleeCellName];
    nib = [UINib nibWithNibName:invitationCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:invitationCellName];
    [self loadWaitingForApprovalList];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_items != nil)
        [self loadWaitingForApprovalList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]])
        return 417;
    else
        return 490;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[_items objectAtIndex:indexPath.row] andApproveOpportunity:YES];
        [self.parent.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]]) {
        SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:skilleeCellName];
        cell.delegate = self;
        [cell setSkilleezData:cell andSkilleez:[_items objectAtIndex:indexPath.row] andTag:indexPath.row];
        return cell;
    } else {
        InviteToLoopApprovalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:invitationCellName];
        cell.delegate = self;
        LoopInvitationModel *invitation = [_items objectAtIndex:indexPath.row];
        [cell fillCell:invitation forAdultOfInvitor:invitation.Invitor.CurrentUserIsApprover andTag:indexPath.row];
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
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:YES];
    [self.parent.navigationController pushViewController:detail animated:YES];
}

#pragma mark - InviteToLoopDelegate

- (void)didViewProfile:(NSInteger)index
{
    LoopInvitationModel *item = [_items objectAtIndex:index];
    NSString *profileId = item.Invitor.CurrentUserIsApprover ? item.Invitee.UserId : item.Invitor.UserId;
    [[UtilityController sharedInstance] profileSelect:profileId onController:self.parent];
}

- (void)didActionSuccess
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [self loadWaitingForApprovalList];
}

#pragma mark - Class methods

- (void)loadWaitingForApprovalList
{
    [[NetworkManager sharedInstance] getWaitingForApprovalList:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.emptyTableLabel removeFromSuperview];
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:_items] && [skilleeList count] > 0) {
                _items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            if ([_items count] == 0)
                self.emptyTableLabel = [[UtilityController sharedInstance] showEmptyView:self text:@"You have no skilleez or invitations in approval."];
            [self.view addSubview:self.emptyTableLabel];
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

- (void)loadFamilyMembers
{
    [[NetworkManager sharedInstance] getFamilyMembers:[UserSettingsManager sharedInstance].userInfo.UserID withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            _childs = [[NSMutableArray alloc]  init];
            for (FamilyMemberModel *member in requestResult.returnArray) {
                if (!member.IsAdult)
                    [_childs addObject:member];
            }
        } else {
            NSLog(@"Get Family Members error: %@", requestResult.error);
        }
    }];
}

- (BOOL)isAdultsChildInvitor:(NSString *)invitorId
{
    NSPredicate *query = [NSPredicate predicateWithFormat:@"Id == %@", invitorId];
    return [[_childs filteredArrayUsingPredicate:query] count] != 0;
}

@end
