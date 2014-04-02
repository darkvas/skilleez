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
#import "ChildProfileViewController.h"
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

- (IBAction)loadApproves:(id)sender;
- (IBAction)loadFavorites:(id)sender;
- (IBAction)showMenu:(id)sender;

@end

@implementation LoopActivityViewController
{
    NSArray *data;
    BOOL isChildApproval;
    NSMutableString *className;
}

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
    self.createViewCtrl = [[CreateChildSkilleeViewController alloc] initWithNibName:@"CreateChildSkilleeViewController" bundle:nil];
    self.menuCtrl = [[MenuViewController alloc] initWithLoopController:self];
    self.menuCtrl.view.hidden = YES;
    self.menuCtrl.view.frame = CGRectMake(-320, 0, 320, 568);
    self.transparentBtn = [[UIButton alloc] initWithFrame:CGRectMake(256, 20, 64, 548)];
    [self.transparentBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.transparentBtn.hidden = YES;
    [self.view addSubview:self.transparentBtn];
    [self.view addSubview:self.menuCtrl.view];
    isChildApproval = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    className = [NSMutableString stringWithString:@"SimpleTableCell"];
    [self loadSkilleeList];
    // Do any additional setup after loading the view from its nib.
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
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:indexPath.row] andApproveOpportunity:[UserSettingsManager sharedInstance].IsAdult];
        [self.navigationController pushViewControllerFromLeft:detail];
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

#pragma mark - SimpleCellDelegate

- (void)didSkiilleSelect:(NSInteger)tag
{
    if ([className isEqualToString:@"SimpleTableCell"]) {
        SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[data objectAtIndex:tag] andApproveOpportunity:[UserSettingsManager sharedInstance].IsAdult];
        detail.view.frame = CGRectMake(-320, 0, 320, 568);
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.navigationController pushViewController:detail animated:NO];
            
        } completion:^(BOOL finished) {
            
        }];
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

- (void)didProfileSelect:(NSInteger)tag
{
    if ([UserSettingsManager sharedInstance].IsAdmin) {
        ProfilePermissionViewController *profile = [ProfilePermissionViewController new];
        [self.navigationController pushViewController:profile animated:YES];
    } else {
        ChildProfileViewController *childProfile = [ChildProfileViewController new];
        [self.navigationController pushViewController:childProfile animated:YES];
    }
}

#pragma mark - Class methods

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

- (void)loadSkilleeList
{
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    [[NetworkManager sharedInstance] getSkilleeList:10 offset:0 success:^(NSArray *skilleeList) {
        data = [[NSArray alloc] initWithArray: skilleeList];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"loadSkilleeList error: %@", error);
    }];
}

- (void)loadFavoriteList
{
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    [[NetworkManager sharedInstance] getFavoriteList:10 offset:0 success:^(NSArray *skilleeList) {
        data = [[NSArray alloc] initWithArray: skilleeList];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"loadFavoriteList error: %@", error);
    }];
}

- (void)loadWaitingForApprovalList
{
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    [[NetworkManager sharedInstance] getWaitingForApproval:10 offset:0 success:^(NSArray *skilleeList) {
        data = [[NSArray alloc] initWithArray: skilleeList];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"loadWaitingForApprovalList error: %@", error);
    }];
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

- (IBAction)loadTop:(id)sender {
    [self.createViewCtrl resignAll];
    [self hideCreateView:YES];
    isChildApproval = NO;
    className = [NSMutableString stringWithString:@"SimpleTableCell"];
    [self loadSkilleeList];
}

- (IBAction)loadApproves:(id)sender {
    [self.createViewCtrl resignAll];
    [self hideCreateView:YES];
    isChildApproval = ![UserSettingsManager sharedInstance].IsAdult;
    className = isChildApproval ? [NSMutableString stringWithString:@"ChildApprovalTableCell"] : [NSMutableString stringWithString:@"AdultApprovalTableCell"];
    [self loadWaitingForApprovalList];
}

- (IBAction)loadFavorites:(id)sender {
    [self.createViewCtrl resignAll];
    [self hideCreateView:YES];
    isChildApproval = NO;
    className = [NSMutableString stringWithString:@"FavoriteTableCell"];
    [self loadFavoriteList];
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
                         completion:^(BOOL finished)
         {
             
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
                         completion:^(BOOL finished)
         {
             
         }];
    }
}

@end
