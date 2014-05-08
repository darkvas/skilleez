//
//  LoginViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "CustomAlertView.h"
#import "UtilityController.h"
#import "ActivityIndicatorController.h"
#import "TextValidator.h"

static NSString *REGISTER_URL = @"http://skilleezv3.elasticbeanstalk.com/Account/Register";
static NSString *FORGOT_RASSWORD_URL = @"http://skilleezv3.elasticbeanstalk.com/Account/ForgotPassword";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldUserPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeBtn;
@property (weak, nonatomic) IBOutlet UILabel *separateLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

-(IBAction) loginPressed:(UIButton*) sender;
-(IBAction) rememberMePressed:(UIButton*)sender;
-(IBAction) forgotPasswordPressed:(UIButton*)sender;
-(IBAction) registerPressed:(UIButton*)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomFonts];
    self.txtFieldUserName.delegate = self;
    self.txtFieldUserPassword.delegate = self;
    [self loadSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadSettings
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    [userSettings loadSettings];
    if (userSettings.remember) {
        self.rememberMeBtn.selected = userSettings.remember;
        self.txtFieldUserName.text = userSettings.username;
        self.txtFieldUserPassword.text = userSettings.password;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtFieldUserName) {
        [self.txtFieldUserPassword becomeFirstResponder];
    } else if (textField == self.txtFieldUserPassword) {
        [self loginWithUsername:self.txtFieldUserName.text andPassword:self.txtFieldUserPassword.text];
    }
    return YES;
}

- (void)setCustomFonts
{
    [self.txtFieldUserName setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_BIG]];
    [self.txtFieldUserName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtFieldUserPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtFieldUserPassword setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_BIG]];
    [self.loginBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:36.0]];
    [self.rememberMeBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:LABEL_SMALL]];
    [self.registerBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:LABEL_SMALL]];
    [self.forgotPasswordBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:LABEL_SMALL]];
}

#pragma mark login functions

- (IBAction)loginPressed:(UIButton *)sender
{
    [self closeKeyboard];
    [self loginWithUsername:self.txtFieldUserName.text andPassword:self.txtFieldUserPassword.text];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] tryLogin:username password:password withLoginCallBack:^(RequestResult *requestReturn) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (requestReturn.isSuccess) {
            if([UserSettingsManager sharedInstance].remember)
                [self saveLoginAndPassword];
            [self getAccountInformation];
            [UserSettingsManager sharedInstance].username = self.txtFieldUserName.text;
            [UserSettingsManager sharedInstance].password = self.txtFieldUserPassword.text;
        } else {
            NSString* loginErrorMessage = [self getLoginErrorMessage: requestReturn.error];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:loginErrorMessage delegate:nil];
            [alert show];
        }
    }];
}

- (NSString*)getLoginErrorMessage:(NSError*) anError
{
    NSString *errorMessage = [[UtilityController sharedInstance] getErrorMessage:anError];
    if([errorMessage isEqualToString:@"Expected status code in (200-299), got 401"])
        return @"Incorrect login or password";
    return errorMessage;
}

- (void)getAccountInformation
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getUserInfo:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (requestResult.isSuccess){
            UserInfo* userInfo = (UserInfo*)requestResult.firstObject;
            
            [UserSettingsManager sharedInstance].IsAdmin = userInfo.IsAdmin;
            [UserSettingsManager sharedInstance].IsAdult = userInfo.IsAdult;
            [UserSettingsManager sharedInstance].IsVerified = userInfo.IsVerified;
            [UserSettingsManager sharedInstance].userInfo = userInfo;
            [self getAccountFriendList:userInfo.UserID];
            [self getAccountPermissions:userInfo.UserID];
            HomeViewController *loop = [HomeViewController new];
            [self.navigationController pushViewController:loop animated:YES];
        } else {
            NSLog(@"Error on GetUserInfo: %@", requestResult.error);
            NSString* loginErrorMessage = [self getLoginErrorMessage: requestResult.error];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:loginErrorMessage delegate:nil];
            [alert show];
        }
    }];
}

- (void)getAccountFriendList:(NSString *)userId
{
    [[NetworkManager sharedInstance] getFriendsAnsFamily :userId withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            [UserSettingsManager sharedInstance].friendsAndFamily = requestResult.returnArray;
        } else {
            NSLog(@"Error on GetFriendsAnsFamily: %@", requestResult.error);
        }
    }];
}

- (void)getAccountPermissions:(NSString *)userId
{
    [[NetworkManager sharedInstance] getAdultPermissionsforAdultId:userId withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            for (AdultPermission *permission in requestResult.returnArray) {
                NSLog(@"Permission adult: %@ for child: %@", permission.AdultId, permission.ChildId);
            }
        } else {
            NSLog(@"Error on GetAccountPermissions: %@", requestResult.error);
        }
    }];
}

- (void)saveLoginAndPassword
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    userSettings.username = self.txtFieldUserName.text;
    userSettings.password = self.txtFieldUserPassword.text;
    
    [userSettings saveSettings];
}

#pragma mark button pressed methods

- (IBAction)rememberMePressed:(UIButton *)sender
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    
    userSettings.remember = !userSettings.remember;
    [sender setSelected:userSettings.remember];
}

- (IBAction)forgotPasswordPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FORGOT_RASSWORD_URL]];
}

- (IBAction)registerPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REGISTER_URL]];
}

#pragma mark validation input methods

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtFieldUserName) {
        return [TextValidator allowInputCharForAccount:string withRangeLength:range.length withOldLength:textField.text.length];
    } else if(textField == self.txtFieldUserPassword){
        return YES;
    }
    return YES;
}

#pragma mark Keyboard moving

float keyboardHeight;
const float kMaxAvailableKeyboardHeight = 120.f;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow: (NSNotification*) notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardHeight = keyboardFrameBeginRect.size.height > kMaxAvailableKeyboardHeight ? kMaxAvailableKeyboardHeight : keyboardFrameBeginRect.size.height;
    
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide
{
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        rect.origin.y -= keyboardHeight;
        rect.size.height += keyboardHeight;
    } else {
        rect.origin.y += keyboardHeight;
        rect.size.height -= keyboardHeight;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void) closeKeyboard
{
    [self.view endEditing:YES];
}

@end
