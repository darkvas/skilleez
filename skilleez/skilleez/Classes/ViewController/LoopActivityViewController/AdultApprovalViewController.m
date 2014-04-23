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
    NSMutableArray *items, *_childs;
    int count, offset;
    BOOL canLoadOnScroll;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;

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
    canLoadOnScroll = YES;
    offset = 0;
    count = NUMBER_OF_ITEMS;
    UINib *nib = [UINib nibWithNibName:skilleeCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:skilleeCellName];
    nib = [UINib nibWithNibName:invitationCellName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:invitationCellName];
    [self loadWaitingForApprovalList];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (items != nil)
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
    if ([[items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]])
        return 417;
    else
        return 490;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[items objectAtIndex:indexPath.row] andApproveOpportunity:YES];
        [self.parent.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [items objectAtIndex:indexPath.row]);
    if ([[items objectAtIndex:indexPath.row] isKindOfClass:[SkilleeModel class]]) {
        SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:skilleeCellName];
        cell.delegate = self;
        [cell setSkilleezData:cell andSkilleez:[items objectAtIndex:indexPath.row] andTag:indexPath.row];
        return cell;
    } else {
        InviteToLoopApprovalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:invitationCellName];
        cell.delegate = self;
        LoopInvitationModel *invitation = [items objectAtIndex:indexPath.row];
        [cell fillCell:invitation forAdultOfInvitor:[self isAdultsChildInvitor:invitation.Invitor.UserId] andTag:indexPath.row];
        return cell;
    }
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
        [self loadWaitingForApprovalList];
    }
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
    LoopInvitationModel *item = [items objectAtIndex:index];
    NSString *profileId = [self isAdultsChildInvitor:item.Invitor.UserId] ? item.Invitee.UserId : item.Invitor.UserId;
    [[UtilityController sharedInstance] profileSelect:profileId onController:self.parent];
}

#pragma mark - Class methods

- (void)loadWaitingForApprovalList
{
    [[NetworkManager sharedInstance] getWaitingForApprovalList:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:items] && [skilleeList count] > 0) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            canLoadOnScroll = YES;
            [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
        } else {
            [[UtilityController sharedInstance] showFailureAlert:requestResult.error withCaption:@"Load loop failed"];
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (offset == 0)
            [[UtilityController sharedInstance] showAnotherViewController:self];
        offset = 1;
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

- (void)allowLoadOnScroll
{
    canLoadOnScroll = YES;
}

- (BOOL)isAdultsChildInvitor:(NSString *)invitorId
{
    NSPredicate *query = [NSPredicate predicateWithFormat:@"Id == %@", invitorId];
    return [[_childs filteredArrayUsingPredicate:query] count] != 0;
}

@end
