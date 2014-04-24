//
//  PendingInvitationsViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "PendingInvitationsViewController.h"
#import "NavigationBarView.h"
#import "NetworkManager.h"
#import "PendingInvitationCell.h"
#import "AcceptInvitationViewController.h"
#import "LoopInvitationModel.h"

@interface PendingInvitationsViewController ()
{
    NSArray *_pendingInvitations;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PendingInvitationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Pending Invitations" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadPendingInvitations];
}

- (void) loadPendingInvitations
{
    [[NetworkManager sharedInstance] getPendingInvitations:20 offset:0 withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            _pendingInvitations = requestResult.returnArray;
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated
{    
    [self loadPendingInvitations];
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
    return _pendingInvitations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PendingInvitationCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingInvitationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell fillCell:cell withInvitation:_pendingInvitations[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoopInvitationModel* invitation = _pendingInvitations[indexPath.row];
    AcceptInvitationViewController *acceptInviteView = [[AcceptInvitationViewController alloc] initWithInvitation:invitation];
    [self.navigationController pushViewController:acceptInviteView animated:YES];
}

@end
