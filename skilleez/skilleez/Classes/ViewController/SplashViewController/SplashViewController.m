//
//  SplashViewController.m
//  skilleez
//
//  Created by Roma on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SplashViewController.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSettings];
}

- (void)loadSettings
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    LoginViewController *login = [LoginViewController new];
    [userSettings loadSettings];
    if (userSettings.remember) {
        [[NetworkManager sharedInstance] tryLogin:userSettings.username password:userSettings.password withLoginCallBack:^(RequestResult *requestResult) {
            if (requestResult.isSuccess) {
                [login getAccountInformation];
                HomeViewController *loop = [HomeViewController new];
                [self.navigationController pushViewController:loop animated:YES];
            } else {
                NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
                if([message isEqualToString:@"Expected status code in (200-299), got 401"])
                    message = @"Incorrect login or password";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }];
    } else {
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
