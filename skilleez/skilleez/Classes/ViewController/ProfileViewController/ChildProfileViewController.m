//
//  ChildProfileViewController.m
//  skilleez
//
//  Created by Roma on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildProfileViewController.h"
#import "UIFont+DefaultFont.h"
#import "NavigationBarView.h"
#import "FriendsFamilyViewController.h"
#import "NetworkManager.h"
#import "ProfileInfo.h"
#import "ProfileViewController.h"
#import "ChildFamilyViewController.h"
#import "SkilleezListViewController.h"
#import "SettingsViewController.h"
#import "UserSettingsManager.h"
#include "UINavigationController+Push.h"

const float CORNER_RADIUS_CP = 5.f;
const int FONT_SIZE_CP = 22;

@interface ChildProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *skilleezBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;

- (IBAction)showSkilleez:(id)sender;
- (IBAction)showProfile:(id)sender;
- (IBAction)showSettings:(id)sender;

@end

@implementation ChildProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *nav = [[NavigationBarView alloc] initWithViewController:self
                                                                     withTitle:self.familyMember.FullName
                                                                     leftImage:@"user_unselected"
                                                                   rightButton:YES
                                                                    rightTitle:@"Done"];
    [self.view addSubview:nav];
    [self customize];
    
    [self.userAvatarImg setImageWithURL: self.familyMember.AvatarUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods

- (void)customize
{
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.skilleezBtn.layer.cornerRadius = CORNER_RADIUS_CP;
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_CP];
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS_CP;
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_CP];
    self.settingsBtn.layer.cornerRadius = CORNER_RADIUS_CP;
    self.settingsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE_CP];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    ChildFamilyViewController *childFamily = [[ChildFamilyViewController alloc] initWithChildID:self.familyMember.Id];
    if ([self.familyMember.Id isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID])
        [self.navigationController pushViewController:childFamily animated:YES];
    else
        [self.navigationController pushViewControllerCustom:childFamily];
}

- (IBAction)showSkilleez:(id)sender
{
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:self.familyMember.Id andTitle:self.familyMember.FullName];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (IBAction)showProfile:(id)sender
{
    [[NetworkManager sharedInstance] getProfileInfo:self.familyMember.Id withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            ProfileInfo *profileInfo = (ProfileInfo*) requestResult.firstObject;
            ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:profileInfo editMode:NO];
            if ([self.familyMember.Id isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID])
                [self.navigationController pushViewController:profileView animated:YES];
            else
                [self.navigationController pushViewControllerCustom:profileView];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Problem with loading user data. Try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)showSettings:(id)sender
{
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithUserId:self.familyMember.Id];
    [self.navigationController pushViewController:settingsView animated:YES];
}

@end
