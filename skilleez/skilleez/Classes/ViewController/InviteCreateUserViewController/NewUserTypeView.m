//
//  NewUserTypeView.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NewUserTypeView.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "CreateAdultViewController.h"
#import "CreateChildViewController.h"

@interface NewUserTypeView ()

@property (weak, nonatomic) IBOutlet UIButton *btnCreateChild;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateAdult;
@property (weak, nonatomic) IBOutlet UILabel *lblTypeAsk;

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"New User" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
	
    [self customizeElements];
}

-(void) customizeElements
{
    [_btnCreateChild.layer setCornerRadius:5.0f];
    [_btnCreateAdult.layer setCornerRadius:5.0f];
    
    [_btnCreateChild.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnCreateAdult.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_lblTypeAsk setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
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
