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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    [self.btnSaveMessage.layer setCornerRadius:5.0f];
    [self.btnSaveMessage.titleLabel setFont:[UIFont getDKCrayonFontWithSize:30.0f]];
    
    self.senderAvatar.layer.cornerRadius = 83.0f;
    self.senderAvatar.layer.masksToBounds = YES;
    self.senderAvatar.layer.borderColor = _profile.Color.CGColor;
    self.senderAvatar.layer.borderWidth = 3.0;
    [self.senderAvatar setImageWithURL: _profile.AvatarUrl];
    
    [self.textMessage setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
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
