//
//  FriendsFamilyViewController.m
//  skilleez
//
//  Created by Vasya on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FriendsFamilyViewController.h"
#import "NavigationBarView.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "FamilyMemberCell.h"
#import "UIFont+DefaultFont.h"
#import "UserSettingsManager.h"
#import "AdultProfileViewController.h"
#import "NewUserTypeView.h"
#import "InviteToLoopViewController.h"
#import "PendingInvitationsViewController.h"
#import "ChildProfileViewController.h"

@interface FriendsFamilyViewController ()
{
    NSArray* _adultMembers;
    NSArray* _childrenMembers;
} 

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteToLoop;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateUser;
@property (weak, nonatomic) IBOutlet UIButton *btnPendingInvites;

-(IBAction) createNewUser:(id)sender;
-(IBAction) inviteToLoop:(id)sender;
-(IBAction) showPendingInvitations:(id)sender;

@end

@implementation FriendsFamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Friends & Family" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self customizeElements];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadFamilyData:[UserSettingsManager sharedInstance].userInfo.UserID];
}

-(void) customizeElements
{
    [_btnCreateUser.layer setCornerRadius:5.0f];
    [_btnInviteToLoop.layer setCornerRadius:5.0f];
    
    [_btnCreateUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnInviteToLoop.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnPendingInvites.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    
    if (![UserSettingsManager sharedInstance].IsAdult)
    {
        _btnCreateUser.hidden = YES;
        _btnInviteToLoop.center = CGPointMake(self.view.center.x, _btnInviteToLoop.center.y);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [_adultMembers count];
    else
        return [_childrenMembers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* className = @"FamilyMemberCell";
    
    FamilyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    
    if(indexPath.section == 0)
        [cell setMemberData:[_adultMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    else
        [cell setMemberData:[_childrenMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Adults";
    else
        return @"Children";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lblSectionHeader = [[UILabel alloc] init];
    lblSectionHeader.frame = CGRectMake(20, 22, 320, 20);
    lblSectionHeader.font = [UIFont getDKCrayonFontWithSize:21];
    lblSectionHeader.text = [self tableView:tableView titleForHeaderInSection:section];
    lblSectionHeader.textColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    [headerView addSubview:lblSectionHeader];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AdultProfileViewController *profilePermissionView = [AdultProfileViewController new];
        profilePermissionView.familyMember = _adultMembers[indexPath.row];
        [self.navigationController pushViewController:profilePermissionView animated:YES];
    } else {
        ChildProfileViewController *childProfileView = [ChildProfileViewController new];
        childProfileView.familyMember = _childrenMembers[indexPath.row];
        childProfileView.showFriendsFamily = NO;
        [self.navigationController pushViewController:childProfileView animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadFamilyData: (NSString*) userId
{
    [[NetworkManager sharedInstance] getFriendsAnsFamily:userId success:^(NSArray *friends) {
        NSMutableArray* adultArray = [NSMutableArray new];
        NSMutableArray* childrenArray = [NSMutableArray new];
        for (FamilyMemberModel* member in friends) {
            if(member.IsAdult)
                [adultArray addObject:member];
            else
                [childrenArray addObject:member];
        }
        _adultMembers = [NSArray arrayWithArray:adultArray];
        _childrenMembers = [NSArray arrayWithArray:childrenArray];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Get Friends and family error: %@", error);
    }];
}

-(IBAction) createNewUser:(id)sender
{
    NewUserTypeView *newUserTypeView = [[NewUserTypeView alloc] initWithNibName:@"NewUserTypeView" bundle:nil];
    [self.navigationController pushViewController:newUserTypeView animated:YES];
}

-(IBAction) inviteToLoop:(id)sender
{
    InviteToLoopViewController *inviteToLoopView = [[InviteToLoopViewController alloc] initWithNibName:@"InviteToLoopViewController" bundle:nil];
    [self.navigationController pushViewController:inviteToLoopView animated:YES];
}

-(IBAction) showPendingInvitations:(id)sender
{
    PendingInvitationsViewController *pendingInvitesView = [[PendingInvitationsViewController alloc] initWithNibName:@"PendingInvitationsViewController" bundle:nil];
    [self.navigationController pushViewController:pendingInvitesView animated:YES];
}

@end
