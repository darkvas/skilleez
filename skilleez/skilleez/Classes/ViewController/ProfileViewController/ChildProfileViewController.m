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
#import "UtilityController.h"
#import "CustomAlertView.h"

@interface ChildProfileViewController ()
{
    NSString *_familyMemberId;
    BOOL _showFriendsFamily;
    ProfileInfo *_childProfile;
}

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *skilleezBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) NavigationBarView *navBar;

- (IBAction)showSkilleez:(id)sender;
- (IBAction)showProfile:(id)sender;
- (IBAction)showSettings:(id)sender;

@end

@implementation ChildProfileViewController

- (id)initWithFamilyMemberId:(NSString *)familyMemberId andShowFriends:(BOOL) showFriendsFamily
{
    if (self = [super init]) {
        _familyMemberId = familyMemberId;
        _showFriendsFamily = showFriendsFamily;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar = [[NavigationBarView alloc] initWithViewController:self
                                                                     withTitle:_childProfile.ScreenName
                                                                     leftImage:@"user_unselected"
                                                                   rightButton:YES
                                                                    rightTitle:@"Done"];
    [self.view addSubview:self.navBar];
    [[NetworkManager sharedInstance] getProfileInfoByUserId:_familyMemberId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            _childProfile = (ProfileInfo *)requestResult.firstObject;
            self.navBar.titleLbl.text = _childProfile.ScreenName;
            [self customize];
            [self.userAvatarImg setImageWithURL: _childProfile.AvatarUrl];
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Problem with loading user data. Try again!" delegate:nil];
            [alert show];
        }
    }];
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
    self.userAvatarImg.layer.borderWidth = BORDER_WIDTH_BIG;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.skilleezBtn.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_SMALL];
    self.profileBtn.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_SMALL];
    self.settingsBtn.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.settingsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_SMALL];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    ChildFamilyViewController *childFamily = [[ChildFamilyViewController alloc] initWithChildID:_childProfile.UserId];
    if ([_childProfile.UserId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID])
        [self.navigationController pushViewController:childFamily animated:YES];
    else
        [self.navigationController pushViewControllerCustom:childFamily];
}

- (IBAction)showSkilleez:(id)sender
{
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:_childProfile.UserId andTitle:_childProfile.ScreenName];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (IBAction)showProfile:(id)sender
{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:_childProfile editMode:NO];
    if ([_childProfile.UserId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID])
        [self.navigationController pushViewController:profileView animated:YES];
    else
        [self.navigationController pushViewControllerCustom:profileView];
}

- (IBAction)showSettings:(id)sender
{
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithUserId:_childProfile.UserId];
    [self.navigationController pushViewController:settingsView animated:YES];
}

@end
