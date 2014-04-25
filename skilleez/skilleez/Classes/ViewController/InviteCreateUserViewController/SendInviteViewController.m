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
    [self.tfUserEmail.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.btnInviteUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [self.tfUserEmail setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_BIG]];
    [self.lblInviteDetails setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.lblTip setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    
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
    [self closeKeyboard];
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postInviteToLoopByEmail:email withCallBack:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if(requestResult.isSuccess) {
            NSString* message = [NSString stringWithFormat:@"Invite Adult success\r\nSend invite to email: %@", email];
            [self showAlertWithMessage:message];
            self.tfUserEmail.text = @"";
        } else {
            NSString* message = [NSString stringWithFormat:@"Invite Adult failed\r\n%@", requestResult.error.userInfo[NSLocalizedDescriptionKey]];
            [self showAlertWithMessage:message];
        }
    }];
}

- (void) showAlertWithMessage:(NSString*) message
{
    CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:message delegate:nil];
    [alert show];
}

@end
