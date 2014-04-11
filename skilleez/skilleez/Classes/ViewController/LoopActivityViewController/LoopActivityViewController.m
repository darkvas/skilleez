//
//  LoopActivityViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoopActivityViewController.h"
#import "SimpleTableCell.h"
#import "ChildApprovalTableCell.h"
#import "NetworkManager.h"
#import "SkilleeDetailViewController.h"
#import "UITableViewCell+SkilleeTableCell.h"
#import "CreateChildSkilleeViewController.h"
#import "UserSettingsManager.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "AdultProfileViewController.h"
#import "UINavigationController+Push.h"
#import "EditProfileViewController.h"
#import "ChildProfileViewController.h"
#import "ActivityIndicatorController.h"

#define LOOP 0
#define APPROVES 1
#define FAVORITES 2
#define NUMBER_OF_ITEMS 5

@interface LoopActivityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *topSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *approvalSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *createSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) CreateChildSkilleeViewController *createViewCtrl;
@property (strong, nonatomic) MenuViewController *menuCtrl;
@property (strong, nonatomic) UIButton *transparentBtn;
@property (strong, nonatomic) UILabel *badge;

- (IBAction)showMenu:(id)sender;

@end

@implementation LoopActivityViewController
{
    NSMutableArray *loopData, *favoritesData, *approvalData;
    BOOL isChildApproval, canLoadOnScroll, toTop;
    NSMutableString *className;
    int count, offset, skillleType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        loopData = [NSMutableArray new];
        approvalData = [NSMutableArray new];
        favoritesData = [NSMutableArray new];
        className = [NSMutableString stringWithString:@"SimpleTableCell"];
        isChildApproval = NO;
        canLoadOnScroll = YES;
        skillleType = LOOP;
        offset = 0;
        count = NUMBER_OF_ITEMS;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createViewCtrl = [[CreateChildSkilleeViewController alloc] initWithNibName:@"CreateChildSkilleeViewController" bundle:nil];
    self.menuCtrl = [[MenuViewController alloc] initWithLoopController:self];
    self.menuCtrl.view.hidden = YES;
    self.menuCtrl.view.frame = CGRectMake(-320, 0, 320, 568);
    self.transparentBtn = [[UIButton alloc] initWithFrame:CGRectMake(256, 20, 64, 548)];
    [self.transparentBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.transparentBtn.hidden = YES;
    [self.view addSubview:self.transparentBtn];
    [self.view addSubview:self.menuCtrl.view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createBadge];
    [self setBadgeValue:0];
    [self loadSkilleeList];
    [self loadWaitingForApprovalCount];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadWaitingForApprovalCount
{
    [[NetworkManager sharedInstance] getWaitingForApprovalCountSuccess:^(int approvalCount) {
        NSLog(@"Waiting from approval count %i", approvalCount);
        [self setBadgeValue:approvalCount];
    } failure:^(NSError *error) {
        NSLog(@"Waiting from approval error: %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([loopData count] > 0) {
        switch (skillleType) {
            case APPROVES:
                isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
                className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
                [self loadWaitingForApprovalInBackground:(count + offset) offset:0];
                break;
            case FAVORITES:
                isChildApproval = NO;
                className = [NSMutableString stringWithString:@"FavoriteTableCell"];
                [self loadFavoriteInBackground:(count + offset) offset:0];
                break;
            default:
                isChildApproval = NO;
                className = [NSMutableString stringWithString:@"SimpleTableCell"];
                [self loadSkilleeInBackground:(count + offset) offset:0];
                break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isChildApproval) {
        return 462;
    } else {
        return 417;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkilleeModel *skillee = [self getElementAt:indexPath.row];
    if ([className isEqualToString:@"SimpleTableCell"]) {
        BOOL canApprove = ![[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:skillee.UserId] && [UserSettingsManager sharedInstance].IsAdult;
        //self.view.userInteractionEnabled = NO;
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:canApprove];
        [self.navigationController pushViewControllerCustom:detail];
        //[self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"AdultApprovalTableCell"]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:YES];
        [self.navigationController pushViewController:detail animated:YES];
    } else if([className isEqualToString:@"ChildApprovalTableCell"]) {
        
    } else {
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(selectProfile:)];
        [cell.avatarImg addGestureRecognizer:tap];
    }
    [cell setSkilleezCell:cell andSkilleez:[self getElementAt:indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getSize];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height - self.tableView.contentOffset.y == 504 && canLoadOnScroll) {
        count = NUMBER_OF_ITEMS;
        switch (skillleType) {
            case APPROVES:
                offset = [approvalData count];
                isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
                className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
                [self loadWaitingForApprovalList];
                break;
            case FAVORITES:
                isChildApproval = NO;
                offset = [favoritesData count];
                className = [NSMutableString stringWithString:@"FavoriteTableCell"];
                [self loadFavoriteList];
                break;
            default:
                isChildApproval = NO;
                offset = [loopData count];
                className = [NSMutableString stringWithString:@"SimpleTableCell"];
                [self loadSkilleeList];
                break;
        }
    }
}

#pragma mark - SimpleCellDelegate

- (void)didSkiilleSelect:(SkilleeModel*) skillee
{
    if ([className isEqualToString:@"SimpleTableCell"]) {
        BOOL canApprove = ![[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:skillee.UserId] && [UserSettingsManager sharedInstance].IsAdult;
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:canApprove];
        [self.navigationController pushViewControllerCustom:detail];
        //[self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"FavoriteTableCell"]) {
        offset = 0;
        count = NUMBER_OF_ITEMS;
        canLoadOnScroll = NO;
        [self loadFavoriteList];
    } else if ([className isEqualToString:@"AdultApprovalTableCell"]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:YES];
        [self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"ChildApprovalTableCell"]) {
        offset = 0;
        count = NUMBER_OF_ITEMS;
        canLoadOnScroll = NO;
        [self loadWaitingForApprovalList];
    }
}

- (void)didProfileSelect:(NSString*) profileId
{
    FamilyMemberModel *familyMember = [self findInFriends:profileId];
    if (familyMember)
        [self showProfileFamilyMember:familyMember];
    else
        [self showProfileNotFamilyMember:profileId];
}

-(FamilyMemberModel*) findInFriends: (NSString*) profileId
{
    for (FamilyMemberModel *member in [UserSettingsManager sharedInstance].friendsAndFamily) {
        if([member.Id isEqualToString:profileId])
            return member;
    }
    return nil;
}

- (void) showProfileFamilyMember: (FamilyMemberModel*) familyMember
{
    if (familyMember.IsAdult) {
        AdultProfileViewController *profilePermissionView = [AdultProfileViewController new];
        profilePermissionView.familyMember = familyMember;
        [self.navigationController pushViewController:profilePermissionView animated:YES];
    } else {
        ChildProfileViewController *childProfileView = [ChildProfileViewController new];
        childProfileView.showFriendsFamily = YES;
        childProfileView.familyMember = familyMember;
        [self.navigationController pushViewController:childProfileView animated:YES];
    }
}

- (void) showProfileNotFamilyMember: (NSString*) profileId
{
    if ([profileId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID]) {
        EditProfileViewController *editProfileView = [EditProfileViewController new];
        [self.navigationController pushViewController:editProfileView animated:YES];
    } else {
        ChildProfileViewController *defaultChildProfileView = [ChildProfileViewController new];
        defaultChildProfileView.showFriendsFamily = YES;
        [self.navigationController pushViewController:defaultChildProfileView animated:YES];
    }
}

#pragma mark - Data loading methods

- (IBAction)loadItems:(id)sender {
    [self.createViewCtrl resignAll];
    [self hideCreateView:YES];
    toTop = YES;
    offset = 0;
    count = NUMBER_OF_ITEMS;
    canLoadOnScroll = NO;
    switch (((UIButton *)sender).tag) {
        case 11:
            isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
            className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
            [self loadWaitingForApprovalList];
            break;
        case 12:
            isChildApproval = NO;
            className = [NSMutableString stringWithString:@"FavoriteTableCell"];
            [self loadFavoriteList];
            break;
        default:
            isChildApproval = NO;
            className = [NSMutableString stringWithString:@"SimpleTableCell"];
            [self loadSkilleeList];
            break;
    }
}

- (void)loadSkilleeList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getSkilleeList:count offset:offset success:^(NSArray *skilleeList) {
        if (offset > 0) {
            [loopData addObjectsFromArray:skilleeList];
            [self.tableView reloadData];
        } else if (![self isArrayEquals:loopData toOther:skilleeList] && [skilleeList count] > 0) {
            loopData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
        if (toTop) {
            self.tableView.contentOffset = CGPointMake(0, 0);
            toTop = NO;
        }
        if (skillleType != LOOP) {
            skillleType = LOOP;
            [self.tableView reloadData];
        }
        skilleeList = nil;
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
    } failure:^(NSError *error) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self showFailureAlert:error withCaption:@"Load Skilleez failed"];
    }];
}

- (void)loadFavoriteList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getFavoriteList:count offset:offset success:^(NSArray *skilleeList) {
        if (offset > 0) {
            [favoritesData addObjectsFromArray:skilleeList];
            [self.tableView reloadData];
        } else if (![self isArrayEquals:favoritesData toOther:skilleeList] && [skilleeList count] > 0) {
            favoritesData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
        if (skillleType != FAVORITES) {
            skillleType = FAVORITES;
            [self.tableView reloadData];
        }
        if (toTop) {
            self.tableView.contentOffset = CGPointMake(0, 0);
            toTop = NO;
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        canLoadOnScroll = YES;
        [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
    } failure:^(NSError *error) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self showFailureAlert:error withCaption:@"Load Favorites failed"];
    }];
}

- (void)loadWaitingForApprovalList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getWaitingForApproval:count offset:offset success:^(NSArray *skilleeList) {
        if (offset > 0) {
            [approvalData addObjectsFromArray:skilleeList];
            [self.tableView reloadData];
        } else if (![self isArrayEquals:approvalData toOther:skilleeList] && [skilleeList count] > 0) {
            approvalData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
        if (skillleType != APPROVES) {
            skillleType = APPROVES;
            [self.tableView reloadData];
        }
        if (toTop) {
            self.tableView.contentOffset = CGPointMake(0, 0);
            toTop = NO;
        }
        //[self setBadgeValue:[approvalData count]];
        [self loadWaitingForApprovalCount];
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
    } failure:^(NSError *error) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self showFailureAlert:error withCaption:@"Load Approvals failed"];
    }];
}

#pragma mark - Arrays methods

- (BOOL)isArrayEquals:(NSArray *)ar1 toOther:(NSArray *)ar2 {
    if ([ar1 count] != [ar2 count]) return NO;
    for (int i = 0; i < [ar1 count]; i++) {
        if (![[ar1 objectAtIndex:i] isEqual:[ar2 objectAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (SkilleeModel *)getElementAt:(int)position
{
    switch (skillleType) {
        case LOOP:
            return [loopData objectAtIndex:position];
        case APPROVES:
            return [approvalData objectAtIndex:position];
        default:
            return [favoritesData objectAtIndex:position];
    }
}

- (NSInteger)getSize
{
    switch (skillleType) {
        case LOOP:
            return [loopData count];
        case APPROVES:
            return [approvalData count];
        default:
            return [favoritesData count];
    }
}

#pragma mark - Loading in background

- (void)loadSkilleeInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getSkilleeList:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self isArrayEquals:loopData toOther:skilleeList]) {
            loopData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

- (void)loadFavoriteInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getFavoriteList:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self isArrayEquals:favoritesData toOther:skilleeList]) {
            favoritesData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

- (void)loadWaitingForApprovalInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getWaitingForApproval:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self isArrayEquals:approvalData toOther:skilleeList]) {
            approvalData = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
            [self setBadgeValue:[approvalData count]];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

#pragma mark - Class UI methods

- (void)showFailureAlert:(NSError *)error withCaption:(NSString *)caption
{
    NSString* message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:caption message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (UIActivityIndicatorView *)getLoaderIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setBackgroundColor:[UIColor whiteColor]];
    [activityIndicator setAlpha:0.7];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    return activityIndicator;
}

- (void)showFailureAlert: (NSError*) error withCaption: (NSString*) caption withIndicator: (UIActivityIndicatorView *) activityIndicator
{
    [activityIndicator stopAnimating];
    NSString* message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:caption message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)allowLoadOnScroll
{
    canLoadOnScroll = YES;
}

- (void)hideCreateView:(BOOL)hide
{
    self.tableView.hidden = !hide;
    for (UIView *subView in self.contentView.subviews)
    {
        if (subView.tag == 2)
        {
            [subView setHidden:hide];
        }
    }
}

- (BOOL)isCreateViewExists
{
    for (UIView *sub in self.contentView.subviews) {
        if (sub.tag == 2)
            return YES;
    }
    return NO;
}

- (IBAction)createSkillee:(id)sender {
    if (![self isCreateViewExists]) {
        [self.contentView addSubview:self.createViewCtrl.view];
        [self addChildViewController:self.createViewCtrl];
    } else {
        [self hideCreateView:NO];
    }
}

- (IBAction)showMenu:(id)sender
{
    [self showMenu];
}

- (void)setBadgeValue:(int)value
{
    if (value == 0) {
        self.badge.hidden = YES;
    } else {
        self.badge.hidden = NO;
        self.badge.text = [NSString stringWithFormat:@"%i", value];
    }
}

- (void)createBadge
{
    self.badge = [[UILabel alloc] initWithFrame:CGRectMake(32, 24, 18, 18)];
    self.badge.layer.masksToBounds = YES;
    self.badge.layer.cornerRadius = 9;
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.adjustsFontSizeToFitWidth = YES;
    self.badge.font = [UIFont systemFontOfSize:12];
    self.badge.minimumScaleFactor = 7 / 12;
    self.badge.textColor = [UIColor whiteColor];
    self.badge.backgroundColor = [UIColor colorWithRed:0.96 green:0.47 blue:0.49 alpha:1.0];
    [self.approvalSkilleeBtn addSubview:self.badge];
}

- (void)hideMenu
{
    self.menuCtrl.view.frame = CGRectMake(-320, 0, 320, 568);
    self.transparentBtn.hidden = YES;
}

- (void)showMenu
{
    [self.createViewCtrl resignAll];
    UIView* view = self.menuCtrl.view;
    if (view.frame.origin.x == -64) {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transparentBtn.hidden = YES;
                             CGRect frame = view.frame;
                             frame.origin.y = 0;
                             frame.origin.x = -320;
                             view.frame = frame;
                         }
                         completion:^(BOOL finished) {
             
         }];
    } else {
        view.hidden = NO;
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transparentBtn.hidden = NO;
                             CGRect frame = view.frame;
                             frame.origin.y = 0;
                             frame.origin.x = -64;
                             view.frame = frame;
                         }
                         completion:^(BOOL finished) {
             
         }];
    }
}

@end
