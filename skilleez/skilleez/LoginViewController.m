//
//  LoginViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) loginPressed:(UIButton*) sender
{
    NSString* message = [NSString stringWithFormat:@"Log: %@, pass: %@", tfUsername.text, tfPassword.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
