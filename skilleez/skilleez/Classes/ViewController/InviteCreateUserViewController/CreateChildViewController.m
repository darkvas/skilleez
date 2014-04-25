//
//  CreateChildViewController.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateChildViewController.h"
#import "NavigationBarView.h"
#import "NetworkManager.h"
#import "UIFont+DefaultFont.h"
#import "CustomAlertView.h"
#import "UtilityController.h"
#import "ActivityIndicatorController.h"

@interface CreateChildViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccountId;
@property (weak, nonatomic) IBOutlet UITextField *tfAccoundPass;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateUser;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountDetails;

-(IBAction)createUserPressed:(id)sender;

@end

@implementation CreateChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"New Child" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

#pragma mark - UIAlerViewDelegate

- (void)dismissAlert:(CustomAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.tfAccoundPass.text = @"";
        self.tfAccountId.text = @"";
        [self.tfAccountId resignFirstResponder];
        [self.tfAccoundPass resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Class methods

- (void)customizeElements
{
    [_tfAccountId.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    //_tfAccountId.layer set
    [_tfAccoundPass.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [_btnCreateUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [_tfAccountId setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [_tfAccoundPass setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [_btnCreateUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [_lblAccountDetails setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    
    [self setLeftMargin:10 forTextField:self.tfAccountId];
    [self setLeftMargin:10 forTextField:self.tfAccoundPass];
    _tfAccoundPass.delegate = self;
    _tfAccountId.delegate = self;
}

- (void)setLeftMargin:(int)leftMargin forTextField:(UITextField *)textField
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

- (IBAction)createUserPressed:(id)sender
{
    [self closeKeyboard];
    NSString* childName = _tfAccountId.text;
    NSString* childPass = _tfAccoundPass.text;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postAddChildToFamily:childName withPass:childPass withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Create Child success" delegate:self];
            [alert show];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Create Child failed" delegate:nil];
            [alert show];
        }
    }];
}

@end
