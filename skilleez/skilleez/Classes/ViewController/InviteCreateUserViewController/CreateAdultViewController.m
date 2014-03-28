//
//  CreateAdultViewController.m
//  skilleez
//
//  Created by Vasya on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateAdultViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"

#define kOFFSET_FOR_KEYBOARD 200.0

@interface CreateAdultViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteUser;
@property (weak, nonatomic) IBOutlet UILabel *lblInviteDetails;

-(IBAction)inviteUserPressed:(id)sender;

@end

@implementation CreateAdultViewController

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
    
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"New Adult" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    
    [self customizeElements];
}

-(void) customizeElements
{
    [_tfUserEmail.layer setCornerRadius:5.0f];
    [_btnInviteUser.layer setCornerRadius:5.0f];
    
    [_tfUserEmail setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_btnInviteUser.titleLabel setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [_lblInviteDetails setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    
    [self setLeftMargin:10 forTextField:self.tfUserEmail];
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

-(IBAction)inviteUserPressed:(id)sender
{
    
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
