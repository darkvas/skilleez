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
#import "UtilityController.h"
#import "CustomAlertView.h"
#import "ColorManager.h"

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
- (IBAction)approve:(id)sender;
- (IBAction)disapprove:(id)sender;

@end

@implementation InviteToLoopApprovalTableCell

- (void)awakeFromNib
{
    self.denyButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_SMALL];
    self.approveButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_SMALL];
    self.userAboutLabel.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
    self.usersLabel.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
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
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:LABEL_BIG] range:NSMakeRange(0, [first length] + 1)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:LABEL_SMALL] range:NSMakeRange([first length] + 1, 17)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:LABEL_SMALL] range:NSMakeRange([first length] + 18 + [second length], [fullString length] - ([first length] + 18 + [second length]))];
    if (isInvitor) {
        [self.userAvatarImageView setImageWithURL:invitation.Invitee.AvatarUrl];
        [self setAboutLabel:invitation.Invitee.AboutMe];
        [attributted addAttribute:NSForegroundColorAttributeName value:[ColorManager defaultTintColor] range:NSMakeRange([first length] + 18, [second length])];
    } else {
        [self.userAvatarImageView setImageWithURL:invitation.Invitor.AvatarUrl];
        [self setAboutLabel:invitation.Invitor.AboutMe];
        [attributted addAttribute:NSForegroundColorAttributeName value:[ColorManager defaultTintColor] range:NSMakeRange(0, [first length] + 1)];
    }
    self.usersLabel.attributedText = attributted;
}

- (void)setAboutLabel:(NSString*)aboutText
{
    if (!aboutText && [aboutText isEqualToString:@""])
        self.userAboutLabel.text = aboutText;
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
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:[[UtilityController sharedInstance] getErrorMessage:requestResult.error] delegate:nil];
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
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:[[UtilityController sharedInstance] getErrorMessage:requestResult.error] delegate:nil];
            [alert show];
        }
    }];
}

@end
