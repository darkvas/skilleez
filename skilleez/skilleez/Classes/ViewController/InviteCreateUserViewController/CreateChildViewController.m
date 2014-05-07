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
#import "TextValidator.h"

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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tfAccountId) {
        return [TextValidator allowInputCharForAccount:string withRangeLength:range.length withOldLength:textField.text.length];
    } else {
        return [TextValidator allowInputCharForPassword:string withRangeLength:range.length withOldLength:textField.text.length];
    }
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    NSString* actionName = NSStringFromSelector(action);
    if ([actionName isEqualToString:@"paste:"])
        return NO;
    if ([actionName isEqualToString:@"cut:"])
        return NO;
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}


#pragma mark - Class methods

- (void)customizeElements
{
    [self.tfAccountId.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];

    [self.tfAccoundPass.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.btnCreateUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [self.tfAccountId setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.tfAccoundPass setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.btnCreateUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.lblAccountDetails setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    
    [self setLeftMargin:10 forTextField:self.tfAccountId];
    [self setLeftMargin:10 forTextField:self.tfAccoundPass];
    self.tfAccoundPass.delegate = self;
    self.tfAccountId.delegate = self;
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
        NSString *message;
        if (requestResult.isSuccess) {
            message = @"Create Child success";
        } else {
            message = [NSString stringWithFormat:@"Create Child failed\r\n%@", [[UtilityController sharedInstance] getErrorMessage:requestResult.error]];
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:message delegate:nil];
        [alert show];
    }];
}

@end
