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

#define CORNER_RADIUS 3.f
#define BOTTOM_LABEL_FONT_SIZE 24
#define TOP_LABEL_FONT_SIZE 21

@interface PermissionManagementViewController () {
    BOOL changesState, loopState, profileState;
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
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Child name" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self customize];
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
    self.changesBtn.layer.cornerRadius = CORNER_RADIUS;
    self.loopBtn.layer.cornerRadius = CORNER_RADIUS;
    self.profileBtn.layer.cornerRadius = CORNER_RADIUS;
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showState:(BOOL)state forButton:(UIButton *)button
{
    button.backgroundColor = state ? [UIColor colorWithRed:0.96 green:0.77 blue:0.18 alpha:1.0] : [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0];
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
