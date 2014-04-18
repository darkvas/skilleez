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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
    [_tfAccountId.layer setCornerRadius:5.0f];
    //_tfAccountId.layer set
    [_tfAccoundPass.layer setCornerRadius:5.0f];
    [_btnCreateUser.layer setCornerRadius:5.0f];
    
    [_tfAccountId setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_tfAccoundPass setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnCreateUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_lblAccountDetails setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    
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
    NSString* childName = _tfAccountId.text;
    NSString* childPass = _tfAccoundPass.text;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postAddChildToFamily:childName withPass:childPass withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* message = [NSString stringWithFormat:@"Child username: %@ and password: %@", childName, childPass];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create Child success" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create Child failed" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

@end
