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
@property (nonatomic) BOOL canClick;

-(IBAction) searchUser:(id)sender;
-(IBAction) inviteToSkilleez:(id)sender;

@end

@implementation InviteToLoopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.canClick = YES;
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Invite to loop" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [self.btnSearchUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.btnInviteUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [self.btnSearchUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM]];
    [self.btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM]];
    self.btnInviteUser.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.lblInfo setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
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

-(IBAction) searchUser:(id)sender
{
    if (self.canClick) {
        self.canClick = NO;
        SearchUserViewController *searchUserView = [SearchUserViewController new];
        [self.navigationController pushViewController:searchUserView animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canClick = YES;
        });
    }
}

-(IBAction) inviteToSkilleez:(id)sender
{
    if (self.canClick) {
        self.canClick = NO;
        SendInviteViewController *sendInviteView = [SendInviteViewController new];
        [self.navigationController pushViewController:sendInviteView animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canClick = YES;
        });
    }
}

@end
