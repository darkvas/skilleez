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

NSString *REGISTER_URL = @"http://skilleezv3.elasticbeanstalk.com/Account/Register";

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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtFieldUserName)
    {
        [self.txtFieldUserPassword becomeFirstResponder];
    } else if (textField == self.txtFieldUserPassword)
    {
        [self login];
    }
    return YES;
}

- (void)setCustomFonts
{
    [self.txtFieldUserName setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.txtFieldUserPassword setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.loginBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:36]];
    [self.rememberMeBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
    [self.registerBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
    [self.forgotPasswordBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:18]];
}

-(IBAction) loginPressed:(UIButton*) sender
{
    [self login];
}

- (void)login
{
    [[NetworkManager sharedInstance] tryLogin:self.txtFieldUserName.text password:self.txtFieldUserPassword.text withLoginCallBeck:^(BOOL loginResult) {
        if(loginResult){
            LoopActivityViewController *loop = [[LoopActivityViewController alloc] initWithNibName:@"LoopActivityViewController" bundle:nil];
            [self presentViewController:loop animated:YES completion:nil];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Incorrect login or password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
    
    [[NetworkManager sharedInstance] getUserInfo:^(UserInfo *userInfo) {
        NSLog(@"%@ - %@", userInfo.Email, userInfo.FullName);
        NSLog(@"%@", userInfo);
    } failure:^(NSError *error) {
        NSLog(@"GetUserInfo error: %@", error);
    }];
}

-(IBAction) rememberMePressed:(UIButton*)sender
{
    
}

-(IBAction) forgotPasswordPressed:(UIButton*)sender
{
    
}

-(IBAction) registerPressed:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REGISTER_URL]];
}

@end
