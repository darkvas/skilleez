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

#define CORNER_RADIUS 5.f
#define FONT_SIZE 22

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
    NavigationBarView *nav = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Child name" leftImage:@"Family" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview:nav];
    [self customize];
    // Do any additional setup after loading the view from its nib.
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
    self.skilleezBtn.layer.cornerRadius = CORNER_RADIUS;
    self.skilleezBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS;
    self.profileBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
    self.settingsBtn.layer.cornerRadius = CORNER_RADIUS;
    self.settingsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:FONT_SIZE];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    FriendsFamilyViewController *family = [[FriendsFamilyViewController alloc] initForChild];
    [self.navigationController pushViewController:family animated:YES];
}

- (IBAction)showSkilleez:(id)sender {
}

- (IBAction)showProfile:(id)sender {
}

- (IBAction)showSettings:(id)sender {
}
@end
