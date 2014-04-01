//
//  SearchUserViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SearchUserViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"

#define kOFFSET_FOR_KEYBOARD 200.0

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
    
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"Search" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    
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
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)findUserPressed:(id)sender
{
    NSString* userId = self.tfUserName.text;
    
    //UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    
}

- (UIActivityIndicatorView *)getLoaderIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setBackgroundColor:[UIColor whiteColor]];
    [activityIndicator setAlpha:0.7];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    return activityIndicator;
}

#pragma mark Keyboard show/hide

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)keyboardWillShow
{
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide
{
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    } else {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
