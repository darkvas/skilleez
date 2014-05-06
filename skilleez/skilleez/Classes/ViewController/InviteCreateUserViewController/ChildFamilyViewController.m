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

@interface ChildFamilyViewController ()
{
    NSMutableArray *_childrenMembers;
    NSString *childId;
    int _count, _offset;
    BOOL _canLoadOnScroll;
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
    _canLoadOnScroll = YES;
    _count = NUMBER_OF_FRIENDS;
    _offset = 0;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height - self.tableView.contentOffset.y == 504 && _canLoadOnScroll) {
        _count = NUMBER_OF_FRIENDS;
        _offset = [_childrenMembers count];
        [self loadFamilyData:childId];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* className = @"FamilyMemberCell";
    
    FamilyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
    }
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
    return [_childrenMembers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
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
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getLoopById:userId count:_count offset:_offset
                                    withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            NSMutableArray *childrenArray = [NSMutableArray new];
            for (ProfileInfo *member in requestResult.returnArray) {
                    [childrenArray addObject:member];
            }
            if (_offset > 0) {
                [_childrenMembers addObjectsFromArray:childrenArray];
                
            } else if (![[UtilityController sharedInstance] isArrayEquals:_childrenMembers toOther:childrenArray] && [childrenArray count] > 0) {
                _childrenMembers = [NSMutableArray arrayWithArray:childrenArray];
            }
            [self.tableView reloadData];
            _canLoadOnScroll = YES;
            [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
        } else {
            NSLog(@"Get Friends and family error: %@", requestResult.error);
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
    }];
}

- (void)allowLoadOnScroll
{
    _canLoadOnScroll = YES;
}

@end
