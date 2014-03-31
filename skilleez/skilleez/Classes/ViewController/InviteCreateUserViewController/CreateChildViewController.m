//
//  CreateChildViewController.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateChildViewController.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "UIFont+DefaultFont.h"

#define kOFFSET_FOR_KEYBOARD 200.0

@interface CreateChildViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccountId;
@property (weak, nonatomic) IBOutlet UITextField *tfAccoundPass;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateUser;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountDetails;

-(IBAction)createUserPressed:(id)sender;

@end

@implementation CreateChildViewController

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
    
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"New Child" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [_tfAccountId.layer setCornerRadius:5.0f];
    //_tfAccountId.layer set
    [_tfAccoundPass.layer setCornerRadius:5.0f];
    [_btnCreateUser.layer setCornerRadius:5.0f];
    
    [_tfAccountId setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_tfAccoundPass setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnCreateUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_lblAccountDetails setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    
    [self setLeftMargin:10 forTextField:self.tfAccountId];
    [self setLeftMargin:10 forTextField:self.tfAccoundPass];
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
}

-(IBAction)createUserPressed:(id)sender
{
    NSString* childName = _tfAccountId.text;
    NSString* childPass = _tfAccoundPass.text;
    
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    [[NetworkManager sharedInstance] postAddChildToFamily:childName withPass:childPass success:^{
        [activityIndicator stopAnimating];
        NSString* message = [NSString stringWithFormat:@"Child username: %@ and password: %@", childName, childPass];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create Child success" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } failure:^(NSError *error) {
        [activityIndicator stopAnimating];
        NSString* message = error.userInfo[NSLocalizedDescriptionKey];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create Child failed" message: message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
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
