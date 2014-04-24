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
{
    FamilyMemberModel* _familyMember;
}

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

- (id)initWithFamilyMember:(FamilyMemberModel *)familyMember
{
    if (self = [super init]) {
        _familyMember = familyMember;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customize];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:_familyMember.FullName leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self.userAvatarImg setImageWithURL: _familyMember.AvatarUrl];
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
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:_familyMember.Id andTitle:_familyMember.FullName];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (IBAction)showPermits:(id)sender
{
    EditPermissionViewController *editPermission = [[EditPermissionViewController alloc] initWithMemberInfo: _familyMember];
    [self.navigationController pushViewController:editPermission animated:YES];
}

- (IBAction)showProfile:(id)sender
{
    [[NetworkManager sharedInstance] getProfileInfoByUserId:_familyMember.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            ProfileInfo* profileInfo = (ProfileInfo*) requestResult.firstObject;
            ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:profileInfo editMode:[profileInfo.UserId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID]];
            [self.navigationController pushViewController:profileView animated:YES];
        } else {
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Problem with loading user data. Try again!" delegate:nil];
            [alert show];
        }
    }];
}

- (IBAction)showSettings:(id)sender
{
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithUserId: _familyMember.Id];
    [self.navigationController pushViewController:settingsView animated:YES];
}

- (IBAction)sendEmail:(id)sender
{
    SendMessageViewController *sendMessageView = [[SendMessageViewController alloc] init];
    [self.navigationController pushViewController:sendMessageView animated:YES];
}

- (IBAction)delete:(id)sender
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initDefaultYesCancelWithText:@"Are you sure you want to remove this user from your loop?" delegate:nil];   
    [alertView show];
}

- (void)dismissAlert:(CustomAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    //TODO:remove logic here
    [alertView close];
}
      
@end
