//
//  AcceptInvitationViewController.m
//  skilleez
//
//  Created by Vasya on 4/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AcceptInvitationViewController.h"
#import "UIFont+DefaultFont.h"
#import "NavigationBarView.h"

@interface AcceptInvitationViewController ()
{
    LoopInvitationModel *_invitation;
}

@property (weak, nonatomic) IBOutlet UILabel *labelUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserAvatar;
@property (weak, nonatomic) IBOutlet UIButton *buttonViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelUserAbout;
@property (weak, nonatomic) IBOutlet UIButton *buttonAccept;
@property (weak, nonatomic) IBOutlet UIButton *buttonDecline;

- (IBAction)viewProfile:(id)sender;
- (IBAction)acceptInvitation:(id)sender;
- (IBAction)declineInvitation:(id)sender;

@end

@implementation AcceptInvitationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithInvitation:(LoopInvitationModel *) anInvitation
{
    if (self = [super init]) {
        _invitation = anInvitation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Search" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    [self customizeElements];
    [self prepareData];
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) customizeElements
{
    self.buttonDecline.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.buttonAccept.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.labelUserAbout.font = [UIFont getDKCrayonFontWithSize:18];
    self.labelUser.font = [UIFont getDKCrayonFontWithSize:20];
}

- (void) prepareData
{
    [self.imageUserAvatar setImageWithURL:_invitation.Invitor.AvatarUrl];
    [self.labelUser setText:[NSString stringWithFormat: @"%@, wants to invite you into loop", _invitation.Invitor.Login]];
}

- (IBAction)viewProfile:(id)sender
{
    
}

- (IBAction)acceptInvitation:(id)sender
{
    
}

- (IBAction)declineInvitation:(id)sender
{
    
}

@end
