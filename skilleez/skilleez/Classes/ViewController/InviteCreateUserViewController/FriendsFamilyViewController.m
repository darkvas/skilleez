//
//  FriendsFamilyViewController.m
//  skilleez
//
//  Created by Vasya on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FriendsFamilyViewController.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "FamilyMemberCell.h"
#import "UIFont+DefaultFont.h"
#import "NewUserTypeView.h"

@interface FriendsFamilyViewController ()
{
    NSArray* _adultMembers;
    NSArray* _childrenMembers;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *inviteToLoopButton;
@property (weak, nonatomic) IBOutlet UIButton *createUserButton;

-(IBAction) createNewUser:(id)sender;
-(IBAction) inviteToLoop:(id)sender;

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
    
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"Friends & Family" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self loadFamilyData];
    
	// Do any additional setup after loading the view.
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
    return  60.0f;
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
    lblSectionHeader.frame = CGRectMake(20, 26, 320, 20);
    lblSectionHeader.font = [UIFont getDKCrayonFontWithSize:21];
    lblSectionHeader.text = [self tableView:tableView titleForHeaderInSection:section];
    lblSectionHeader.textColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    [headerView addSubview:lblSectionHeader];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (void) cancel
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadFamilyData
{
    [[NetworkManager sharedInstance] getFriendsAnsFamily:[UserSettingsManager sharedInstance].userInfo.UserID success:^(NSArray *friends) {
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
    
}

@end