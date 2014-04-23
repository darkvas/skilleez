//
//  InviteToLoopApprovalTableCell.m
//  skilleez
//
//  Created by Roma on 4/12/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "InviteToLoopApprovalTableCell.h"
#import "UIFont+DefaultFont.h"
#import "UserSettingsManager.h"

@interface InviteToLoopApprovalTableCell() {
    LoopInvitationModel *_invitation;
}

@property (weak, nonatomic) IBOutlet UILabel *usersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *viewProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *userAboutLabel;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;

- (IBAction)viewProfile:(id)sender;

@end

@implementation InviteToLoopApprovalTableCell

- (void)awakeFromNib
{
    self.denyButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.approveButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.userAboutLabel.font = [UIFont getDKCrayonFontWithSize:18];
    self.usersLabel.font = [UIFont getDKCrayonFontWithSize:20];
}

- (void)fillCell:(LoopInvitationModel *)invitation forAdultOfInvitor:(BOOL)isInvitor andTag:(NSInteger)tag
{
    _invitation = invitation;
    self.viewProfileButton.tag = tag;
    //TODO:change on screen names
    NSString *first = invitation.Invitor.Login,
    *second = invitation.Invitee.Login,
    *fullString = [NSString stringWithFormat: @"%@, wants to invite %@ into loop", first, second];
    NSMutableAttributedString *attributted = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:32] range:NSMakeRange(0, [first length] + 1)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 1, 17)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:22] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 18 + [second length], [fullString length] - ([first length] + 18 + [second length]))];
    if (isInvitor) {
        [self.userAvatarImageView setImageWithURL:invitation.Invitee.AvatarUrl];
        self.userAboutLabel.text = invitation.Invitee.AboutMe;
        [attributted addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] range:NSMakeRange([first length] + 18, [second length])];
    } else {
        [self.userAvatarImageView setImageWithURL:invitation.Invitor.AvatarUrl];
        self.userAboutLabel.text = invitation.Invitor.AboutMe;
        [attributted addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] range:NSMakeRange(0, [first length] + 1)];
    }
    self.usersLabel.attributedText = attributted;
    [self setButtonsMethods];
}

- (void)fillCellForInviteeChild:(LoopInvitationModel *)invitation andTag:(NSInteger)tag
{
    _invitation = invitation;
    self.viewProfileButton.tag = tag;
    //TODO:change on screen names
    NSString *first = invitation.Invitor.Login,
    *second = invitation.Invitee.Login,
    *fullString = [NSString stringWithFormat: @"%@, wants to invite you %@ into loop", first, second];
    NSMutableAttributedString *attributted = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:32] range:NSMakeRange(0, [first length] + 1)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 1, 17)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:22] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 18 + [second length], [fullString length] - ([first length] + 18 + [second length]))];
    [self.userAvatarImageView setImageWithURL:invitation.Invitor.AvatarUrl];
    self.userAboutLabel.text = invitation.Invitor.AboutMe;
    [attributted addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] range:NSMakeRange(0, [first length] + 1)];
    self.usersLabel.attributedText = attributted;
    [self setButtonsMethods];
}

- (IBAction)viewProfile:(id)sender
{
    [self.delegate didViewProfile:((UIButton *)sender).tag];
}

- (IBAction)approve:(id)sender
{
    [[NetworkManager sharedInstance] postApproveInvitationToLoop:_invitation.InvitationId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.delegate didActionSuccess];
        } else {
            NSLog(@"Fail post approve invitation to loop");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error has occured" message:@"Houston we had a problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (IBAction)disapprove:(id)sender
{
    [[NetworkManager sharedInstance] postApproveInvitationToLoop:_invitation.InvitationId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.delegate didActionSuccess];
        } else {
            NSLog(@"Fail post disapprove invitation to loop");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error has occured" message:@"Houston we had a problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (IBAction)accept:(id)sender
{
    [[NetworkManager sharedInstance] postApproveInvitationToLoop:_invitation.InvitationId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.delegate didActionSuccess];
        } else {
            NSLog(@"Fail post accept invitation to loop");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error has occured" message:@"Houston we had a problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (IBAction)decline:(id)sender
{
    [[NetworkManager sharedInstance] postApproveInvitationToLoop:_invitation.InvitationId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.delegate didActionSuccess];
        } else {
            NSLog(@"Fail post decline invitation to loop");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error has occured" message:@"Houston we had a problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)setButtonsMethods
{
    if ([[UserSettingsManager sharedInstance].userInfo.UserID isEqualToString:_invitation.Invitee.UserId]) {
        [self.approveButton addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
        [self.denyButton addTarget:self action:@selector(decline:) forControlEvents:UIControlEventTouchUpInside];
        self.approveButton.titleLabel.text = @"Accept";
        self.denyButton.titleLabel.text = @"Decline";
    } else {
        [self.approveButton addTarget:self action:@selector(approve:) forControlEvents:UIControlEventTouchUpInside];
        [self.denyButton addTarget:self action:@selector(disapprove:) forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
