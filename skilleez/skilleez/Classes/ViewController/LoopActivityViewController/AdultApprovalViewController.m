//
//  AdultApprovalViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultApprovalViewController.h"

static NSString *cellName = @"AdultApprovalTableCell";

@interface AdultApprovalViewController () {
    NSMutableArray *items;
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
    canLoadOnScroll = YES;
    offset = 0;
    count = NUMBER_OF_ITEMS;
    [self loadWaitingForApprovalList];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadWaitingForApprovalInBackground:(count + offset) offset:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 417;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[items objectAtIndex:indexPath.row] andApproveOpportunity:YES];
    [self.parent.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    [cell setSkilleezData:cell andSkilleez:[items objectAtIndex:indexPath.row] andTag:indexPath.row];
    return cell;
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

#pragma mark - Class methods

- (void)loadWaitingForApprovalList
{
    [[NetworkManager sharedInstance]  getWaitingForApprovalSkilleez:count offset:offset withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (offset > 0) {
                [items addObjectsFromArray:skilleeList];
                [self.tableView reloadData];
                
            } else if (![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:items] && [skilleeList count] > 0) {
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
    }];
}

- (void)loadWaitingForApprovalInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getWaitingForApprovalSkilleez:counts offset:offsets withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:items toOther:skilleeList]) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
                [[UtilityController sharedInstance] setBadgeValue:[items count] forController:self.parent];
            }
        } else {
            NSLog(@"loadSkilleeInBackground error: %@", requestResult.error);
        }
    }];
}

- (void)allowLoadOnScroll
{
    canLoadOnScroll = YES;
}

@end
