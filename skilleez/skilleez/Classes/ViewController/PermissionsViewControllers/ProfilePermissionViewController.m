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
#import "NavigationBarView.h"
#import "ProfileViewController.h"
#import "NetworkManager.h"
#import "ProfileInfo.h"

#define CORNER_RADIUS 5.f
#define FONT_SIZE 22

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:self.familyMember.FullName leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self.userAvatarImg setImageWithURL: self.familyMember.AvatarUrl];
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
}

- (void)done
{
    
}

- (void)customize
{
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.permitBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.emailBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.deleteBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.settingsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = CORNER_RADIUS;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileBtn.layer.masksToBounds = YES;
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS;
    self.permitBtn.layer.masksToBounds = YES;
    self.permitBtn.layer.cornerRadius = CORNER_RADIUS;
    self.emailBtn.layer.masksToBounds = YES;
    self.emailBtn.layer.cornerRadius = CORNER_RADIUS;
    self.skilleezBtn.layer.masksToBounds = YES;
    self.skilleezBtn.layer.cornerRadius = CORNER_RADIUS;
    self.settingsBtn.layer.masksToBounds = YES;
    self.settingsBtn.layer.cornerRadius = CORNER_RADIUS;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = CORNER_RADIUS;
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
    [[NetworkManager sharedInstance] getProfileInfo:self.familyMember.Id success:^(ProfileInfo *profileInfo) {
        ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:profileInfo editMode:YES];
        [self.navigationController pushViewController:profileView animated:YES];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Problem with loading user data. Try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
    }

- (IBAction)showSettings:(id)sender {
}

- (IBAction)sendEmail:(id)sender {
}

- (IBAction)delete:(id)sender {
}
@end
