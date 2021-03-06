//
//  SettingsViewController.m
//  skilleez
//
//  Created by Vasya on 4/10/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ProfileInfo.h"
#import "NetworkManager.h"

@interface SettingsViewController ()
{
    NSString *_userId;
    ProfileInfo *_profileInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *tfUserId;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeSettings;
@property (weak, nonatomic) IBOutlet UILabel *lblUserIdTip;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordTip;

-(IBAction)changeSettingsPressed:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Settings" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
    [self loadProfileData];
}

- (void)customizeElements
{
    [self.tfUserId.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.tfPassword.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.btnChangeSettings.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [self.tfUserId setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.tfPassword setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    [self.btnChangeSettings.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_BIG]];
    [self.lblUserIdTip setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.lblPasswordTip setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    
    [self setLeftMargin:10 forTextField:self.tfUserId];
    [self setLeftMargin:10 forTextField:self.tfPassword];
}

-(void) setLeftMargin: (int) leftMargin forTextField: (UITextField*) textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void) loadProfileData
{
    [[NetworkManager sharedInstance] getProfileInfoByUserId:_userId withCallBack:^(RequestResult *requestResult) {
       if(requestResult.isSuccess)  {
           ProfileInfo *profileInfo = (ProfileInfo*)requestResult.firstObject;
        _profileInfo = profileInfo;
        self.tfUserId.text = profileInfo.Login;
        self.tfPassword.text = profileInfo.Password;
    }
    }];
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


-(IBAction)changeSettingsPressed:(id)sender
{
    
}

@end
