//
//  FindUserViewController.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FindUserViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "ActivityIndicatorController.h"
#import "CustomAlertView.h"

const float CORNER_RADIUS = 5.f;
const float BORDER_WIDTH = 3.f;
const int FONT_SIZE = 24;

@interface FindUserViewController ()
{
    ProfileInfo *_profileInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgUserAvatar;
@property (weak, nonatomic) IBOutlet UIView *viewAvatarBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

- (IBAction)buttonYesPressed:(id)sender;
- (IBAction)buttonNoPressed:(id)sender;

@end

@implementation FindUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithProfile:(ProfileInfo *) profileInfo
{
    if (self = [super init]) {
        _profileInfo = profileInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"find user" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self customize];
    
    [self.imgUserAvatar setImageWithURL:_profileInfo.AvatarUrl];
    self.lblUserName.text = _profileInfo.Login;
    self.viewAvatarBackground.backgroundColor = _profileInfo.Color;
}

- (void) customize
{
    self.btnYes.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.btnYes.layer.cornerRadius = CORNER_RADIUS;
    self.btnNo.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.btnNo.layer.cornerRadius = CORNER_RADIUS;
    self.lblUserName.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.lblQuestion.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    
    self.imgUserAvatar.layer.masksToBounds = YES;
    self.imgUserAvatar.layer.borderWidth = BORDER_WIDTH;
    self.imgUserAvatar.layer.cornerRadius = 103.f;
    self.imgUserAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonYesPressed:(id)sender
{
    [self askToInvite];
}

- (void) askToInvite
{
    CustomAlertView *alert = [CustomAlertView new];
    [alert setDefaultContainerView:@"Would you like to invite this user to your loop?"];
    alert.alpha = 0.95;
    [alert setDelegate:self];
    [alert setUseMotionEffects:YES];
    [alert show];
}

#pragma mark - CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView close];
    
    if (!alertView.buttons) {
        [self sendInviteRequest];
    }
}
    
- (void)sendInviteRequest
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postInviteToLoopByUserId:_profileInfo.UserId withCallBack:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if (requestResult.isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            if([message isEqualToString:@"Expected status code in (200-299), got 500"])
                message = @"May be you send invite before";
            [self showAlertWithMessage: message];
        }
    }];
}

- (void) showAlertWithMessage:(NSString*) message
{
    CustomAlertView *alert = [CustomAlertView new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Ok" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.27 green:0.53 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
    alert.buttons = @[button];
    [alert setDefaultContainerView:message];
    alert.alpha = 0.95;
    [alert setDelegate:self];
    [alert setUseMotionEffects:YES];
    [alert show];
}

- (IBAction)buttonNoPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
