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

@interface InviteToLoopApprovalTableCell()

@property (weak, nonatomic) IBOutlet UILabel *usersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *viewProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *userAboutLabel;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;

- (IBAction)viewProfile:(id)sender;
- (IBAction)approve:(id)sender;
- (IBAction)deny:(id)sender;

@end

@implementation InviteToLoopApprovalTableCell

- (void)awakeFromNib
{
    self.denyButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.approveButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.userAboutLabel.font = [UIFont getDKCrayonFontWithSize:18];
    self.usersLabel.font = [UIFont getDKCrayonFontWithSize:20];
}

- (void)fillCell:(LoopInvitationModel *)invitation andTag:(NSInteger)tag
{
    self.viewProfileButton.tag = tag;
    [self.userAvatarImageView setImageWithURL:invitation.Invitor.AvatarUrl];
    //TODO:change on scrren names
    NSString *first = invitation.Invitor.Login,
            *second = invitation.Invitee.Login,
        *fullString = [NSString stringWithFormat: @"%@, wants to invite %@ into loop", first, second];
    NSMutableAttributedString *attributted = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:28] range:NSMakeRange(0, [first length] + 1)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 1, 17)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:22] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 18 + [second length], [fullString length] - ([first length] + 18 + [second length]))];
    self.usersLabel.attributedText = attributted;
    //self.userAboutLabel.text = invitation.Invitee.AboutMe;
}

- (IBAction)viewProfile:(id)sender
{
    [self.delegate didViewProfile:((UIButton *)sender).tag];
}

- (IBAction)approve:(id)sender
{
}

- (IBAction)deny:(id)sender
{
}
@end
