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
#import "ColorManager.h"

int const DEFAULT_FRIENDS_COUNT = 100;
int const DEFAULT_FRIENDS_OFFSET = 0;

@interface ChildFamilyViewController ()
{
    //NSArray* _adultMembers;
    NSArray* _childrenMembers;
    NSString *childId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChildFamilyViewController

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
    self.tableView.allowsSelection = NO;
    
    [self loadFamilyData:childId];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self loadFamilyData:childId];
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
    lblSectionHeader.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    lblSectionHeader.text = [self tableView:tableView titleForHeaderInSection:section];
    lblSectionHeader.textColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [ColorManager colorForFriendsCellHeader];
    [headerView addSubview:lblSectionHeader];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (indexPath.section == 0) {
        if([UserSettingsManager sharedInstance].IsAdmin) {
            AdultProfileViewController *adultProfileView = [[AdultProfileViewController alloc] initWithFamilyMember:_adultMembers[indexPath.row]];
            [self.navigationController pushViewController:adultProfileView animated:YES];
        } else {
            ChildProfileViewController *profileView = [[ChildProfileViewController alloc] initWithFamilyMember:_adultMembers[indexPath.row]
                                                                                                andShowFriends:NO];
            [self.navigationController pushViewController:profileView animated:YES];
        }
    } else {
        ChildProfileViewController *childProfileView = [[ChildProfileViewController alloc] initWithFamilyMember:_childrenMembers[indexPath.row]
                                                                                                 andShowFriends:NO];
        [self.navigationController pushViewController:childProfileView animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];*/
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
    
    /*if(indexPath.section == 0)
        [cell setMemberData:[_adultMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    else*/
        [cell setProfileData:[_childrenMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [ColorManager colorForDarkBackground];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*if(section == 0)
        return [_adultMembers count];
    else*/
        return [_childrenMembers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    /*if(section == 0)
        return @"Adults";
    else*/
        return @"Friends in Loop";
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
    [[NetworkManager sharedInstance] getLoopById:userId count:DEFAULT_FRIENDS_COUNT offset:DEFAULT_FRIENDS_OFFSET
                                    withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            //NSMutableArray* adultArray = [NSMutableArray new];
            NSMutableArray* childrenArray = [NSMutableArray new];
            for (ProfileInfo* member in requestResult.returnArray) {
                /*if(member.)
                    [adultArray addObject:member];
                else*/
                    [childrenArray addObject:member];
            }
            //_adultMembers = [NSArray arrayWithArray:adultArray];
            _childrenMembers = [NSArray arrayWithArray:childrenArray];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"Get Friends and family error: %@", requestResult.error);
        }
    }];
}

@end
