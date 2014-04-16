//
//  ProfilePermissionViewController.m
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultProfileViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"
#import "EditPermissionViewController.h"
#import "NavigationBarView.h"
#import "ProfileViewController.h"
#import "NetworkManager.h"
#import "ProfileInfo.h"
#import "UserSettingsManager.h"
#import "SendMessageViewController.h"
#import "SkilleezListViewController.h"
#import "SettingsViewController.h"

const float CORNER_RADIUS_AP = 5.f;
const int FONT_SIZE_AP = 22;

@interface AdultProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *skilleezBtn;
@property (weak, nonatomic) IBOutlet UIButton *permitBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)showSkilleez:(id)sender;
- (IBAction)showPermits:(id)sender;
- (IBAction)showProfile:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation AdultProfileViewController

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

#pragma mark - CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %ld is clicked on alertView %ld.", (long)buttonIndex, (long)[alertView tag]);
    [alertView close];
}

- (UIView *)createAlertView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 110)];
    titleLabel.text = @"Are you sure you want to remove this user from your loop?";
    titleLabel.numberOfLines = 3;
    titleLabel.font = [UIFont getDKCrayonFontWithSize:26];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0];
    [demoView addSubview:titleLabel];
    return demoView;
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
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_AP];
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_AP];
    self.permitBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_AP];
    self.emailBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_AP];
    self.deleteBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_AP];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = CORNER_RADIUS_AP;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileBtn.layer.masksToBounds = YES;
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS_AP;
    self.permitBtn.layer.masksToBounds = YES;
    self.permitBtn.layer.cornerRadius = CORNER_RADIUS_AP;
    self.emailBtn.layer.masksToBounds = YES;
    self.emailBtn.layer.cornerRadius = CORNER_RADIUS_AP;
    self.skilleezBtn.layer.masksToBounds = YES;
    self.skilleezBtn.layer.cornerRadius = CORNER_RADIUS_AP;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = CORNER_RADIUS_AP;
    self.deleteBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.deleteBtn.layer.borderWidth = 3.f;
}

- (IBAction)showSkilleez:(id)sender
{
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:self.familyMember.Id andTitle:self.familyMember.FullName];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (IBAction)showPermits:(id)sender
{
    EditPermissionViewController *editPermission = [[EditPermissionViewController alloc] init];
    [self.navigationController pushViewController:editPermission animated:YES];
}

- (IBAction)showProfile:(id)sender
{
    [[NetworkManager sharedInstance] getProfileInfo:self.familyMember.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            ProfileInfo* profileInfo = (ProfileInfo*) requestResult.firstObject;
            ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:profileInfo editMode:[profileInfo.UserId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID]];
            [self.navigationController pushViewController:profileView animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Problem with loading user data. Try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)showSettings:(id)sender
{
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithUserId: self.familyMember.Id];
    [self.navigationController pushViewController:settingsView animated:YES];
}

- (IBAction)sendEmail:(id)sender
{
    SendMessageViewController *sendMessageView = [[SendMessageViewController alloc] init];
    [self.navigationController pushViewController:sendMessageView animated:YES];
}

- (IBAction)delete:(id)sender
{
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    [alertView setContainerView:[self createAlertView]];
    alertView.alpha = 0.95;
    [alertView setDelegate:self];
    [alertView setUseMotionEffects:YES];
    [alertView show];
}
      
@end
