//
//  InviteToLoopViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "InviteToLoopViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "SendInviteViewController.h"
#import "SearchUserViewController.h"

@interface InviteToLoopViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnSearchUser;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

-(IBAction) searchUser:(id)sender;
-(IBAction) inviteToSkilleez:(id)sender;

@end

@implementation InviteToLoopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Invite to loop" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [self.btnSearchUser.layer setCornerRadius:5.0f];
    [self.btnInviteUser.layer setCornerRadius:5.0f];
    
    [self.btnSearchUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    self.btnInviteUser.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.lblInfo setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
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

-(IBAction) searchUser:(id)sender
{
    SearchUserViewController *searchUserView = [SearchUserViewController new];
    [self.navigationController pushViewController:searchUserView animated:YES];
}

-(IBAction) inviteToSkilleez:(id)sender
{
    SendInviteViewController *sendInviteView = [SendInviteViewController new];
    [self.navigationController pushViewController:sendInviteView animated:YES];
}

@end
