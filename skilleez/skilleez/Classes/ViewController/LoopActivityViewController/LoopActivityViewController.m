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
#import "ProfilePermissionViewController.h"
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

- (IBAction)showMenu:(id)sender;

@end

@implementation LoopActivityViewController
{
    NSMutableArray *data;
    BOOL isChildApproval, canLoadOnScroll, toTop;
    NSMutableString *className;
    int count, offset, skillleType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        data = [NSMutableArray new];
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

    [self loadSkilleeList];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([data count] > 0) {
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
    NSLog(@"DIDDDDDDDD");
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
    if ([className isEqualToString:@"SimpleTableCell"]) {
        BOOL canApprove = ![[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:((SkilleeModel *)[data objectAtIndex:indexPath.row]).UserId] && [UserSettingsManager sharedInstance].IsAdult;
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:indexPath.row] andApproveOpportunity:canApprove];
        [self.navigationController pushViewControllerCustom:detail];
        //[self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"AdultApprovalTableCell"]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:indexPath.row] andApproveOpportunity:YES];
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
    }
    [cell setSkilleezCell:cell andSkilleez:[data objectAtIndex:indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height - self.tableView.contentOffset.y == 504 && canLoadOnScroll) {
        NSLog(@"%f %f", self.tableView.contentOffset.y, self.tableView.contentSize.height);
        offset = [data count];
        count = NUMBER_OF_ITEMS;
        switch (skillleType) {
            case APPROVES:
                isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
                className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
                [self loadWaitingForApprovalList];
                break;
            case FAVORITES:
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
}

#pragma mark - SimpleCellDelegate

- (void)didSkiilleSelect:(NSInteger)tag
{
    if ([className isEqualToString:@"SimpleTableCell"]) {
        BOOL canApprove = ![[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:((SkilleeModel *)[data objectAtIndex:tag]).UserId] && [UserSettingsManager sharedInstance].IsAdult;
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:tag] andApproveOpportunity:canApprove];
        [self.navigationController pushViewControllerCustom:detail];
        //[self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"FavoriteTableCell"]) {
        [self loadFavoriteList];
    } else if ([className isEqualToString:@"AdultApprovalTableCell"]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:tag] andApproveOpportunity:YES];
        [self.navigationController pushViewController:detail animated:YES];
    } else if ([className isEqualToString:@"ChildApprovalTableCell"]) {
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
        ProfilePermissionViewController *profilePermissionView = [ProfilePermissionViewController new];
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
    if (offset > 0) {
        count += offset;
        offset = 0;
    }
    canLoadOnScroll = NO;
    [data removeAllObjects];
    switch (((UIButton *)sender).tag) {
        case 11:
            isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
            className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
            if (skillleType != APPROVES) {
                toTop = YES;
                offset = 0;
                count = NUMBER_OF_ITEMS;
            }
            skillleType = APPROVES;
            [self loadWaitingForApprovalList];
            break;
        case 12:
            isChildApproval = NO;
            className = [NSMutableString stringWithString:@"FavoriteTableCell"];
            if (skillleType != FAVORITES) {
                toTop = YES;
                offset = 0;
                count = NUMBER_OF_ITEMS;
            }
            skillleType = FAVORITES;
            [self loadFavoriteList];
            break;
        default:
            isChildApproval = NO;
            className = [NSMutableString stringWithString:@"SimpleTableCell"];
            if (skillleType != LOOP) {
                toTop = YES;
                offset = 0;
                count = NUMBER_OF_ITEMS;
            }
            skillleType = LOOP;
            [self loadSkilleeList];
            break;
    }
}

- (void)loadSkilleeList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getSkilleeList:count offset:offset success:^(NSArray *skilleeList) {
        [data addObjectsFromArray:skilleeList];
        [self.tableView reloadData];
        if (toTop) {
            self.tableView.contentOffset = CGPointMake(0, 0);
            toTop = NO;
        }
        
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
    } failure:^(NSError *error) {
        
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self showFailureAlert:error withCaption:@"Load Skilleez failed"];
    }];
}

-(void) showFailureAlert: (NSError*) error withCaption: (NSString*) caption
{
    NSString* message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:caption message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)loadFavoriteList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getFavoriteList:count offset:offset success:^(NSArray *skilleeList) {
        [data addObjectsFromArray:skilleeList];
        [self.tableView reloadData];
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
        [data addObjectsFromArray:skilleeList];
        [self.tableView reloadData];
        if (toTop) {
            self.tableView.contentOffset = CGPointMake(0, 0);
            toTop = NO;
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
    } failure:^(NSError *error) {
        [self showFailureAlert:error withCaption:@"Load Approvals failed"];
    }];
}

#pragma mark - Loading in background

- (void)loadSkilleeInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getSkilleeList:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self compareArrayIgnoreIndexes:skilleeList toArray:data]) {
            data = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

- (void)loadFavoriteInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getFavoriteList:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self compareArrayIgnoreIndexes:skilleeList toArray:data]) {
            data = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

- (void)loadWaitingForApprovalInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getWaitingForApproval:counts offset:offsets success:^(NSArray *skilleeList) {
        if (![self compareArrayIgnoreIndexes:skilleeList toArray:data]) {
            data = [NSMutableArray arrayWithArray:skilleeList];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeInBackground error: %@", error);
    }];
}

-(BOOL)compareArrayIgnoreIndexes:(NSArray*)arrayOne toArray:(NSArray*)arrayTwo{
    NSSet *setOne=[[NSSet alloc]initWithArray:arrayOne];
    NSSet *setTwo=[[NSSet alloc]initWithArray:arrayTwo];
    return [setOne isEqualToSet:setTwo];
}

#pragma mark - Class UI methods

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
