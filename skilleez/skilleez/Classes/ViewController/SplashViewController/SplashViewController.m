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
        [login loginWithUsername:userSettings.username andPassword:userSettings.password];
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
