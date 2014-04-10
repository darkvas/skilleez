//
//  ChildFamilyViewController.m
//  skilleez
//
//  Created by Roma on 4/8/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildFamilyViewController.h"
#import "NavigationBarView.h"
#import "UserSettingsManager.h"
#import "FamilyMemberCell.h"
#import "ChildProfileViewController.h"
#import "AdultProfileViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"

@interface ChildFamilyViewController ()
{
    NSArray* _adultMembers;
    NSArray* _childrenMembers;
    NSString *childId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChildFamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithChildID:(NSString *)childID
{
    if (self = [super init]) {
        childId = childID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Friends & Family" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //[self loadFamilyData:childId];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFamilyData:childId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
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

#pragma mark - UITableViewDataSource

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [_adultMembers count];
    else
        return [_childrenMembers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Adults";
    else
        return @"Children";
}

#pragma mark - Class methods

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadFamilyData:(NSString *)userId
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

@end
