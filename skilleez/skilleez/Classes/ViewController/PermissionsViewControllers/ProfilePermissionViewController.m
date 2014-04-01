//
//  ProfilePermissionViewController.m
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfilePermissionViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"
#import "EditPermissionViewController.h"

@interface ProfilePermissionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *skilleezBtn;
@property (weak, nonatomic) IBOutlet UIButton *permitBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)showSkilleez:(id)sender;
- (IBAction)showPermits:(id)sender;
- (IBAction)showProfile:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation ProfilePermissionViewController

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
    [self customize];
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"User" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] class]) isEqualToString:@"SplashViewController"]) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)customize
{
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.permitBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.emailBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.deleteBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.settingsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileBtn.layer.masksToBounds = YES;
    self.profileBtn.layer.cornerRadius = 5.f;
    self.permitBtn.layer.masksToBounds = YES;
    self.permitBtn.layer.cornerRadius = 5.f;
    self.emailBtn.layer.masksToBounds = YES;
    self.emailBtn.layer.cornerRadius = 5.f;
    self.skilleezBtn.layer.masksToBounds = YES;
    self.skilleezBtn.layer.cornerRadius = 5.f;
    self.settingsBtn.layer.masksToBounds = YES;
    self.settingsBtn.layer.cornerRadius = 5.f;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 5.f;
    self.deleteBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.deleteBtn.layer.borderWidth = 3.f;
}

- (IBAction)showSkilleez:(id)sender {
}

- (IBAction)showPermits:(id)sender {
    EditPermissionViewController *editPermission = [[EditPermissionViewController alloc] init];
    [self.navigationController pushViewController:editPermission animated:YES];
}

- (IBAction)showProfile:(id)sender {
}

- (IBAction)showSettings:(id)sender {
}

- (IBAction)sendEmail:(id)sender {
}

- (IBAction)delete:(id)sender {
}
@end
