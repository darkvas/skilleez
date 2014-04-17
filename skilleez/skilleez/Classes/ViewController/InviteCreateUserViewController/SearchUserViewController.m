//
//  SearchUserViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SearchUserViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "ActivityIndicatorController.h"
#import "FindUserViewController.h"

@interface SearchUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnFindUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

-(IBAction)findUserPressed:(id)sender;

@end

@implementation SearchUserViewController

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Search" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [self.tfUserName.layer setCornerRadius:5.0f];
    [_btnFindUser.layer setCornerRadius:5.0f];
    
    [self.tfUserName setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.btnFindUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:30.0f]];
    [self.lblInfo setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.lblTip setFont:[UIFont getDKCrayonFontWithSize:18.0f]];
    
    [self setLeftMargin:10 forTextField:self.tfUserName];
}

-(void) setLeftMargin: (int) leftMargin forTextField: (UITextField*) textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
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

-(IBAction)findUserPressed:(id)sender
{
    [self closeKeyboard];
    NSString* userLogin = self.tfUserName.text;
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    
    [[NetworkManager sharedInstance] getProfileInfoByLogin:userLogin withCallBack:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        
        if (requestResult.isSuccess) {
            ProfileInfo* profile = (ProfileInfo*)requestResult.firstObject;
            FindUserViewController *foundUserView = [[FindUserViewController alloc] initWithProfile:profile];
            [self.navigationController pushViewController:foundUserView animated:YES];
        }
        else {
            [self showAlertNotFoundUser];
        }
    }];
}

- (void) showAlertNotFoundUser
{
    CustomAlertView *alert = [CustomAlertView new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Ok" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.27 green:0.53 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
    alert.buttons = @[button];
    [alert setDefaultContainerView:@"Not found such user"];
    alert.alpha = 0.95;
    [alert setDelegate:self];
    [alert setUseMotionEffects:YES];
    [alert show];
}

#pragma mark - CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView close];
}

@end
