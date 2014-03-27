//
//  NewUserTypeView.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NewUserTypeView.h"
#import "AppDelegate.h"
#import "CreateAdultViewController.h"
#import "CreateChildViewController.h"

@interface NewUserTypeView ()

-(IBAction) createChildUser:(id)sender;
-(IBAction) createAdultUser:(id)sender;

@end

@implementation NewUserTypeView

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
    
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"New User" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) createChildUser:(id)sender
{
    CreateChildViewController *createChildView = [[CreateChildViewController alloc] initWithNibName:@"CreateChildViewController" bundle:nil];
    [self.navigationController pushViewController:createChildView animated:YES];
}

-(IBAction) createAdultUser:(id)sender
{
    CreateAdultViewController *createAdultView = [[CreateAdultViewController alloc] initWithNibName:@"CreateAdultViewController" bundle:nil];
    [self.navigationController pushViewController:createAdultView animated:YES];
}

@end
