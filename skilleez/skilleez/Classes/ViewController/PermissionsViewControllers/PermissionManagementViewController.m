//
//  PermissionManagementViewController.m
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "PermissionManagementViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "ActivityIndicatorController.h"
#import "CustomAlertView.h"
#import "UserSettingsManager.h"
#import "ColorManager.h"

const float CORNER_RADIUS_PM = 3.f;
const int BOTTOM_LABEL_FONT_SIZE = 24;
const int TOP_LABEL_FONT_SIZE = 21;

const NSString* DEFAULT_PERMISSION_ID = @"0";

@interface PermissionManagementViewController () {
    BOOL changesState, loopState, profileState;
    FamilyMemberModel* _adult;
    FamilyMemberModel* _child;
    AdultPermission* _permission;
}

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *approvalLbl;
@property (weak, nonatomic) IBOutlet UILabel *userCanApproveLbl;
@property (weak, nonatomic) IBOutlet UILabel *changesLbl;
@property (weak, nonatomic) IBOutlet UILabel *loopLbl;
@property (weak, nonatomic) IBOutlet UILabel *profileLbl;
@property (weak, nonatomic) IBOutlet UIButton *changesBtn;
@property (weak, nonatomic) IBOutlet UIButton *loopBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *canApproveLbl;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;

- (IBAction)changeChanges:(id)sender;
- (IBAction)changeLoop:(id)sender;
- (IBAction)changeProfile:(id)sender;

@end

@implementation PermissionManagementViewController

- (id) initWithAdult: (FamilyMemberModel*) adult withChild: (FamilyMemberModel*) child andPermission: (AdultPermission*) permission
{
    if (self = [super init]) {
        _adult = adult;
        _child = child;
        _permission = permission;
        changesState = permission.ChangesApproval;
        loopState = permission.LoopApproval;
        profileState = permission.ProfileApproval;
    }
    return self;
}

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:_child.FullName leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    [self customize];
    
    [self.userAvatarImg setImageWithURL: _child.AvatarUrl];
    self.usernameLbl.text = _adult.FullName;
    [self showState:changesState forButton:self.changesBtn];
    [self showState:loopState forButton:self.loopBtn];
    [self showState:profileState forButton:self.profileBtn];
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
    self.approvalLbl.font = [UIFont getDKCrayonFontWithSize:31];
    self.userCanApproveLbl.font = [UIFont getDKCrayonFontWithSize:TOP_LABEL_FONT_SIZE];
    self.canApproveLbl.font = [UIFont getDKCrayonFontWithSize:TOP_LABEL_FONT_SIZE];
    self.usernameLbl.font = [UIFont getDKCrayonFontWithSize:TOP_LABEL_FONT_SIZE];
    self.changesLbl.font = [UIFont getDKCrayonFontWithSize:BOTTOM_LABEL_FONT_SIZE];
    self.loopLbl.font = [UIFont getDKCrayonFontWithSize:BOTTOM_LABEL_FONT_SIZE];
    self.profileLbl.font = [UIFont getDKCrayonFontWithSize:BOTTOM_LABEL_FONT_SIZE];
    self.changesBtn.layer.cornerRadius = CORNER_RADIUS_PM;
    self.loopBtn.layer.cornerRadius = CORNER_RADIUS_PM;
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS_PM;
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
    [self preparePermission];
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postSetAdultPermissions:_permission withCallBack:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (requestResult.isSuccess){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Set Permission error: %@", requestResult.error.userInfo[NSLocalizedDescriptionKey]]];
        }
    }];
}

- (void) preparePermission
{
    _permission.Id = _permission.Id ? _permission.Id : DEFAULT_PERMISSION_ID;
    _permission.MainFamilyUserId = [UserSettingsManager sharedInstance].userInfo.UserID;
    _permission.AdultId = _adult.Id;
    _permission.ChildId = _child.Id;
    _permission.ChildAvatarUrl = _child.AvatarUrl;
    _permission.ChildName = _child.FullName;
    
    _permission.ChangesApproval = changesState;
    _permission.LoopApproval = loopState;
    _permission.ProfileApproval = profileState;
}

- (void) showAlertWithMessage:(NSString*) message
{
    CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:message delegate:nil];
    [alert show];
}

- (void)showState:(BOOL)state forButton:(UIButton *)button
{
    button.backgroundColor = state ? [ColorManager colorForSelectedPermission] : [ColorManager colorForUnselectedPermission];
}

- (IBAction)changeChanges:(id)sender {
    changesState = !changesState;
    [self showState:changesState forButton:sender];
}

- (IBAction)changeLoop:(id)sender {
    loopState = !loopState;
    [self showState:loopState forButton:sender];
}

- (IBAction)changeProfile:(id)sender {
    profileState = !profileState;
    [self showState:profileState forButton:sender];
}
@end
