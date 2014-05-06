//
//  SkilleezListViewController.m
//  skilleez
//
//  Created by Vasya on 4/9/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleezListViewController.h"
#import "SimpleTableCell.h"
#import "NavigationBarView.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "SkilleeDetailViewController.h"
#import "ActivityIndicatorController.h"
#import "UtilityController.h"
#import "CustomAlertView.h"

const int NUMBER_OF_ITEMS_SL = 5;

@interface SkilleezListViewController ()
{
    NSMutableArray* skilleez;
    NSString* _userId;
    NSString* _title;
    
    BOOL canLoadOnScroll;
    BOOL toTop;
    int offset;
    int count;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *emptyLabel;
@end

@implementation SkilleezListViewController

- (id)initWithUserId:(NSString *)userId andTitle: (NSString*) title
{
    if (self = [super init]) {
        _userId = userId;
        _title = title;
        canLoadOnScroll = YES;
        offset = 0;
        count = NUMBER_OF_ITEMS_SL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:_title leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadSkilleeList];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    [cell setSkilleezData:cell andSkilleez:skilleez[indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [skilleez count];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 417;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkilleeModel *skillee = skilleez[indexPath.row];
    [self didSkiilleSelect:skillee];
}

#pragma mark SimpleCellDelegate

- (void)didSkiilleSelect:(SkilleeModel*) skillee
{
    BOOL canApprove = ![[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:skillee.UserId] && [UserSettingsManager sharedInstance].IsAdult;
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:canApprove];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didProfileSelect:(NSString*) profileId
{
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height - self.tableView.contentOffset.y == 504 && canLoadOnScroll) {
        count = NUMBER_OF_ITEMS_SL;
        offset = [skilleez count];
        [self loadSkilleeList];
        canLoadOnScroll = NO;
    }
}

- (void)loadSkilleeList
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getSkilleeListForUser:_userId count: count offset:offset withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (offset > 0) {
                [skilleez addObjectsFromArray:skilleeList];
                [self.tableView reloadData];
            } else if (![self isArrayEquals:skilleez toOther:skilleeList] && [skilleeList count] > 0) {
                skilleez = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            if (toTop) {
                self.tableView.contentOffset = CGPointMake(0, 0);
                toTop = NO;
            }
            skilleeList = nil;
            [self performSelector:@selector(allowLoadOnScroll) withObject:nil afterDelay:0.3];
            if ([skilleez count] == 0) {
                NSString *message = [_userId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID] ? @"You have no skilleez. Please add some, to see them here" : @"This user has no skilleez";
                self.emptyLabel = [[UtilityController sharedInstance] showEmptyView:self text:message];
            }
            [self.view addSubview:self.emptyLabel];
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Load Skilleez failed" delegate:nil];
            [alert show];
        }
    }];
}

- (BOOL)isArrayEquals:(NSArray *)ar1 toOther:(NSArray *)ar2 {
    if ([ar1 count] != [ar2 count])
        return NO;
    for (int i = 0; i < [ar1 count]; i++) {
        if (![[ar1 objectAtIndex:i] isEqual:[ar2 objectAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (void)allowLoadOnScroll
{
    canLoadOnScroll = YES;
}

@end
