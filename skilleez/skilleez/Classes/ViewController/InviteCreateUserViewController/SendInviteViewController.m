//
//  SendInviteViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SendInviteViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "ActivityIndicatorController.h"

@interface SendInviteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInviteDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

-(IBAction)inviteUserPressed:(id)sender;

@end

@implementation SendInviteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Send invitation" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

- (void)customizeElements
{
    [self.tfUserEmail.layer setCornerRadius:5.0f];
    [self.btnInviteUser.layer setCornerRadius:5.0f];
    
    [self.tfUserEmail setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:30.0f]];
    [self.lblInviteDetails setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.lblTip setFont:[UIFont getDKCrayonFontWithSize:18.0f]];
    
    [self setLeftMargin:10 forTextField:self.tfUserEmail];
}

-(void) setLeftMargin: (int) leftMargin forTextField: (UITextField*) textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
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

-(IBAction)inviteUserPressed:(id)sender
{
    NSString* email = self.tfUserEmail.text;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postInviteAdultToFamily: email withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* message = [NSString stringWithFormat:@"Send invite to email: %@", email];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invite Adult success" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invite Adult failed" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

@end
