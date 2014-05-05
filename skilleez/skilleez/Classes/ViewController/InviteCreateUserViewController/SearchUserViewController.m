//
//  SearchUserViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SearchUserViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "ActivityIndicatorController.h"
#import "FindUserViewController.h"

const int kMaxUserNameLength = 50;
static NSString *allowedLoginChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@interface SearchUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnFindUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

-(IBAction)findUserPressed:(id)sender;

@end

@implementation SearchUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Search" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [self.tfUserName.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    self.tfUserName.delegate = self;
    [_btnFindUser.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [self.tfUserName setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.btnFindUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_BIG]];
    [self.lblInfo setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.lblTip setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    
    [self setLeftMargin:10 forTextField:self.tfUserName];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)findUserPressed:(id)sender
{
    [self closeKeyboard];
    NSString* userLogin = self.tfUserName.text;
    if ([userLogin isEqualToString:[UserSettingsManager sharedInstance].userInfo.Login]) {
        CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Hey, buddy, it's yours id:) Try another one" delegate:nil];
        [alert show];
    } else {
        [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
        [[NetworkManager sharedInstance] getProfileInfoByLogin:userLogin withCallBack:^(RequestResult *requestResult) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            
            if (requestResult.isSuccess) {
                ProfileInfo* profile = (ProfileInfo*)requestResult.firstObject;
                FindUserViewController *foundUserView = [[FindUserViewController alloc] initWithProfile:profile];
                [self.navigationController pushViewController:foundUserView animated:YES];
            } else {
                CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:[[UtilityController sharedInstance] getErrorMessage:requestResult.error] delegate:nil];
                [alert show];
            }
        }];
    }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tfUserName) {
        return [self validateTextField:textField withNewString:string withRange:range withAllowedString:allowedLoginChars];
    } else {
        return YES;
    }
}

- (BOOL)validateTextField:(UITextField *) textField withNewString: (NSString *)string withRange:(NSRange)range withAllowedString: (NSString *) allowedChars
{
    //MaxLenght
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    //AllowedCharacters
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:allowedLoginChars] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (newLength <= kMaxUserNameLength || returnKey) && [string isEqualToString:filtered];
}

@end