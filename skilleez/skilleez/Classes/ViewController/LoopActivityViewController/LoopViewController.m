//
//  LoopViewController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoopViewController.h"

static NSString *cellName = @"SimpleTableCell";

@interface LoopViewController () {
    NSMutableArray *items;
    int count, offset;
    BOOL canLoadOnScroll;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) UILabel *emptyTableLabel;

@end

@implementation LoopViewController

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
    [self loadSkilleeList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadSkilleeInBackground:(count + offset) offset:0];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"dj");
    HomeViewController *home = (HomeViewController *)parent;
    [home.currentViewController.view removeFromSuperview];
    [home.currentViewController removeFromParentViewController];
    home.currentViewController = self;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 417;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:[items objectAtIndex:indexPath.row] andApproveOpportunity:NO];
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(selectProfile:)];
        [cell.avatarImg addGestureRecognizer:tap];
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
        count = NUMBER_OF_ITEMS;
        offset = [items count];
        [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
        [self loadSkilleeList];
        canLoadOnScroll = NO;
    }
}

#pragma mark - SimpleTableCellDelegate

- (void)didProfileSelect:(NSString *)profileId
{
    [[UtilityController sharedInstance] profileSelect:profileId onController:self.parent];
}

- (void)didSkiilleSelect:(SkilleeModel *)skillee
{
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithSkillee:skillee andApproveOpportunity:NO];
    [self.parent.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Class methods

- (void)loadSkilleeList
{
    [[NetworkManager sharedInstance]  getSkilleeList:count offset:offset withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.emptyTableLabel removeFromSuperview];
            NSArray* skilleeList = requestResult.returnArray;
            if (offset > 0) {
                [items addObjectsFromArray:skilleeList];
                [self.tableView reloadData];
            } else if ((![[UtilityController sharedInstance] isArrayEquals:skilleeList toOther:items] && [skilleeList count] > 0) || ([skilleeList count] == 0 && [items count] == 1)) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
            }
            if ([items count] == 0)
                self.emptyTableLabel = [[UtilityController sharedInstance] showEmptyView:self text:@"You have no skilleez. Please add some, to see them here"];
            [self.view addSubview:self.emptyTableLabel];
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

- (void)loadSkilleeInBackground:(int)counts offset:(int)offsets
{
    [[NetworkManager sharedInstance] getSkilleeList:counts offset:offsets withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSArray* skilleeList = requestResult.returnArray;
            if (![[UtilityController sharedInstance] isArrayEquals:items toOther:skilleeList]) {
                items = [NSMutableArray arrayWithArray:skilleeList];
                [self.tableView reloadData];
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
