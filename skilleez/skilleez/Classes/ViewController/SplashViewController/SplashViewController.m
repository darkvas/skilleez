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
#import "LoopActivityViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSettings];
}

- (void)loadSettings
{
    UserSettingsManager* userSettings = [UserSettingsManager sharedInstance];
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [userSettings loadSettings];
    if (userSettings.remember) {
        [[NetworkManager sharedInstance] tryLogin:userSettings.username password:userSettings.password withLoginCallBeck:^(BOOL isLogined, NSError* error) {
            if (isLogined) {
                [login getAccountInformation];
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
