//
//  CreateAdultViewController.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateAdultViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "UtilityController.h"
#import "CustomAlertView.h"
#import "ActivityIndicatorController.h"

@interface CreateAdultViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInviteDetails;

-(IBAction)inviteUserPressed:(id)sender;

@end

@implementation CreateAdultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"New Adult" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    self.tfUserEmail.delegate = self;
    [self customizeElements];
}

#pragma mark - UIAlerViewDelegate

- (void)dismissAlert:(CustomAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.tfUserEmail.text = @"";
        [self.tfUserEmail resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Class methods

-(void) customizeElements
{
    [_tfUserEmail.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [_btnInviteUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [_tfUserEmail setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [_btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [_lblInviteDetails setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    
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
    [self closeKeyboard];
    NSString* email = self.tfUserEmail.text;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postInviteToLoopByEmail: email withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Invite Adult success" delegate:nil];
            [alert show];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Invite Adult failed" delegate:nil];
            [alert show];
        }
    }];
}

@end
