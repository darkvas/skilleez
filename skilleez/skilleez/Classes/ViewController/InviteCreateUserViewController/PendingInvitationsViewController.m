//
//  PendingInvitationsViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "PendingInvitationsViewController.h"
#import "NavigationBarView.h"

@interface PendingInvitationsViewController ()
{
    NSArray *tableData;
}

@end

@implementation PendingInvitationsViewController

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Pending Invitations" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString* className = @"FamilyMemberCell";
    
    /*FamilyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    
    if(indexPath.section == 0)
        [cell setMemberData:[_adultMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    else
        [cell setMemberData:[_childrenMembers objectAtIndex:indexPath.row] andTag:indexPath.row];
    */
    return [UITableViewCell new];
}

@end
