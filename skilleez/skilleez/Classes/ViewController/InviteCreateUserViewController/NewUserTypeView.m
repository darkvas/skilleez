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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"New User" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
	
    [self customizeElements];
}

-(void) customizeElements
{
    [_btnCreateChild.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [_btnCreateAdult.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    
    [_btnCreateChild.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM]];
    [_btnCreateAdult.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM]];
    [_lblTypeAsk setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) createChildUser:(id)sender
{
    CreateChildViewController *createChildView = [CreateChildViewController new];
    [self.navigationController pushViewController:createChildView animated:YES];
}

-(IBAction) createAdultUser:(id)sender
{
    CreateAdultViewController *createAdultView = [CreateAdultViewController new];
    [self.navigationController pushViewController:createAdultView animated:YES];
}

@end
