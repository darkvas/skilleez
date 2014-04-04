//
//  LoginViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoginViewController.h"
#import "LoopActivityViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"

#define REGISTER_URL @"http://skilleezv3.elasticbeanstalk.com/Account/Register"
#define FORGOT_RASSWORD_URL @"http://skilleezv3.elasticbeanstalk.com/Account/ForgotPassword"


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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomFonts];
    self.txtFieldUserName.delegate = self;
    self.txtFieldUserPassword.delegate = self;
    [self loadSettings];
}

- (void)loadSettings
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    [userSettings loadSettings];
    if (userSettings.remember) {
        self.rememberMeBtn.selected = userSettings.remember;
        [self loginWithUsername:userSettings.username andPassword:userSettings.password];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.txtFieldUserName setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.txtFieldUserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtFieldUserPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtFieldUserPassword setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.loginBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.rememberMeBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
    [self.registerBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
    [self.forgotPasswordBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
}

- (IBAction)loginPressed:(UIButton *)sender
{
    [self loginWithUsername:self.txtFieldUserName.text andPassword:self.txtFieldUserPassword.text];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [[NetworkManager sharedInstance] tryLogin:username password:password withLoginCallBeck:^(BOOL isLogined, NSError* error) {
        if (isLogined) {
            [self getAccountInformation];
            LoopActivityViewController *loop = [[LoopActivityViewController alloc] initWithNibName:@"LoopActivityViewController" bundle:nil];
            [self.navigationController pushViewController:loop animated:YES];
        } else {
            NSString* message = error.userInfo[NSLocalizedDescriptionKey];
            if([message isEqualToString:@"Expected status code in (200-299), got 401"])
                message = @"Incorrect login or password";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (void) getAccountInformation
{
    [[NetworkManager sharedInstance] getUserInfo:^(UserInfo *userInfo) {
        [UserSettingsManager sharedInstance].IsAdmin = userInfo.IsAdmin;
        [UserSettingsManager sharedInstance].IsAdult = userInfo.IsAdult;
        [UserSettingsManager sharedInstance].IsVerified = userInfo.IsVerified;
        [UserSettingsManager sharedInstance].userInfo = userInfo;
        [self getAccountFriendList:userInfo.UserID];
    } failure:^(NSError *error) {
        NSLog(@"Error on GetUserInfo: %@", error);
    }];
}

- (void) getAccountFriendList: (NSString*) userId
{
    [[NetworkManager sharedInstance] getFriendsAnsFamily:userId success:^(NSArray *friends) {
        [UserSettingsManager sharedInstance].friendsAndFamily = friends;
    } failure:^(NSError *error) {
        NSLog(@"Error on GetFriendsAnsFamily: %@", error);
    }];
}

- (IBAction)rememberMePressed:(UIButton *)sender
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    
    userSettings.remember = !userSettings.remember;
    [sender setSelected:userSettings.remember];
    userSettings.username = self.txtFieldUserName.text;
    userSettings.password = self.txtFieldUserPassword.text;
    
    [userSettings saveSettings];
}

- (IBAction)forgotPasswordPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FORGOT_RASSWORD_URL]];
}

- (IBAction)registerPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REGISTER_URL]];
}

@end
