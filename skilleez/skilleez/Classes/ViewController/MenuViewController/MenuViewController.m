//
//  MenuViewController.m
//  skilleez
//
//  Created by Roma on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MenuViewController.h"
#import "LoopActivityViewController.h"
#import "FriendsFamilyViewController.h"
#import "UIFont+DefaultFont.h"
#import "UserSettingsManager.h"
#import "EditProfileViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *myLoopBtn;
@property (weak, nonatomic) IBOutlet UIButton *eventsBtn;
@property (weak, nonatomic) IBOutlet UIButton *finFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *familyBtn;
@property (strong, nonatomic) LoopActivityViewController *loopCtrl;

- (IBAction)showMyLoop:(id)sender;
- (IBAction)showEvents:(id)sender;
- (IBAction)findFriends:(id)sender;
- (IBAction)showFamily:(id)sender;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLoopController:(LoopActivityViewController *)loop
{
    if (self = [super init]) {
        self.loopCtrl = loop;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.userAvatarImg setImageWithURL:[NSURL URLWithString:[UserSettingsManager sharedInstance].userInfo.AvatarUrl]];
    self.usernameLbl.text = [UserSettingsManager sharedInstance].userInfo.FullName;
    [self customize];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customize
{
    [self.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:31]];
    self.myLoopBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.eventsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.finFriendsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.familyBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.userAvatarImg.layer.cornerRadius = 32.f;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = 3.f;
}

- (IBAction)showMyLoop:(id)sender {
    EditProfileViewController *profile = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.loopCtrl.navigationController pushViewController:profile animated:YES];
    //[self.loopCtrl loadTop:sender];
    [self.loopCtrl hideMenu];
}

- (IBAction)showEvents:(id)sender {
}

- (IBAction)findFriends:(id)sender {
}

- (IBAction)showFamily:(id)sender {
    FriendsFamilyViewController *familyCtrl = [[FriendsFamilyViewController alloc] initWithNibName:@"FriendsFamilyViewController" bundle:nil];
    [((UIViewController*)self.view.superview.nextResponder).navigationController pushViewController:familyCtrl animated:YES];
}
@end
