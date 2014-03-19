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
@interface LoopActivityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)loadTop:(id)sender;
- (IBAction)loadApproves:(id)sender;
- (IBAction)loadFavorites:(id)sender;
- (IBAction)createSkillee:(id)sender;

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
    isChildApproval = NO;
    className = [NSMutableString stringWithString:@"SimpleTableCell"];
    [self loadSkilleeList];
    // Do any additional setup after loading the view from its nib.
}

-(void)processCompleted
{
    SkilleeDetailViewController *detail = [[SkilleeDetailViewController alloc] initWithNibName:@"SkilleeDetailViewController" bundle:nil];
    [self presentViewController:detail animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isChildApproval) {
        return 460;
    } else
    {
        return 415;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    [cell setSkilleezCell:cell andSkilleez:[data objectAtIndex:indexPath.row]];
    return cell;
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

- (void)loadSkilleeList
{
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
        [[NetworkManager sharedInstance] getSkilleeList:10 offset:0 success:^(NSArray *skilleeList) {
        NSLog(@"skillees count: %i", skilleeList.count);
        NSLog(@"%@", skilleeList[0]);
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
        NSLog(@"skillees count: %i", skilleeList.count);
        NSLog(@"%@", skilleeList[0]);
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
        NSLog(@"skillees count: %i", skilleeList.count);
        //NSLog(@"%@", skilleeList[0]);
        data = [[NSArray alloc] initWithArray: skilleeList];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"loadWaitingForApprovalList error: %@", error);
    }];
}

- (void)hideCreateView
{
    self.tableView.hidden = NO;
    for (UIView *subView in self.contentView.subviews)
    {
        if (subView.tag == 2)
        {
            [subView removeFromSuperview];
        }
    }
}

- (BOOL)isCreateViewExists
{
    for (UIView *sub in self.contentView.subviews)
    {
        if (sub.tag == 2)
        return YES;
    }
    return NO;
}

- (IBAction)loadTop:(id)sender {
    [self hideCreateView];
    isChildApproval = NO;
    className = [NSMutableString stringWithString:@"SimpleTableCell"];
    [self loadSkilleeList];
}

- (IBAction)loadApproves:(id)sender {
    [self hideCreateView];
    isChildApproval = YES;
    className = [NSMutableString stringWithString:@"ChildApprovalTableCell"];
    [self loadWaitingForApprovalList];
}

- (IBAction)loadFavorites:(id)sender {
    [self hideCreateView];
    isChildApproval = NO;
    className = [NSMutableString stringWithString:@"FavoriteTableCell"];
    [self loadFavoriteList];
}

- (IBAction)createSkillee:(id)sender {
    if (![self isCreateViewExists])
    {
        CreateChildSkilleeViewController *createChild = [[CreateChildSkilleeViewController alloc] initWithNibName:@"CreateChildSkilleeViewController" bundle:nil];
        [self.contentView addSubview:createChild.view];
        [createChild removeFromParentViewController];
        [self addChildViewController:createChild];
    }
}

@end
