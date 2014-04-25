//
//  MessageViewController.m
//  skilleez
//
//  Created by Vasya on 4/10/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MessageViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ProfileInfo.h"

@interface MessageViewController ()
{
    ProfileInfo *_profile;
}

@property (weak, nonatomic) IBOutlet UIImageView *senderAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveMessage;
@property (weak, nonatomic) IBOutlet UITextView *textMessage;

-(IBAction)saveMessagePressed:(id)sender;

@end

@implementation MessageViewController

- (id)initWithMessage:(ProfileInfo *)profileInfo
{
    if (self = [super init]) {
        _profile = profileInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Message" leftTitle:@"Back" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

- (void)customizeElements
{
    [self.btnSaveMessage.layer setCornerRadius:BUTTON_CORNER_RADIUS_MEDIUM];
    [self.btnSaveMessage.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_BIG]];
    
    self.senderAvatar.layer.cornerRadius = 83.0f;
    self.senderAvatar.layer.masksToBounds = YES;
    self.senderAvatar.layer.borderColor = _profile.Color.CGColor;
    self.senderAvatar.layer.borderWidth = BORDER_WIDTH_MEDIUM;
    [self.senderAvatar setImageWithURL: _profile.AvatarUrl];
    
    [self.textMessage setFont:[UIFont getDKCrayonFontWithSize:TEXTVIEW_MEDIUM]];
    self.textMessage.text = _profile.AboutMe ? _profile.AboutMe : (_profile.ScreenName ? _profile.ScreenName : _profile.Login);
    
    self.textMessage.editable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
}

-(IBAction)saveMessagePressed:(id)sender
{
    
}

@end
