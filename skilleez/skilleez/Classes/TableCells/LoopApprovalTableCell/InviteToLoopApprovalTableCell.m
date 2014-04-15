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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCell
{
    [self.userAvatarImageView setImageWithURL:[UserSettingsManager sharedInstance].userInfo.AvatarUrl];
    NSString *first = @"Ivan",
            *second = @"Petroooo",
        *fullString = [NSString stringWithFormat: @"%@, wants to invite %@ into her loop", first, second];
    NSMutableAttributedString *attributted = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:24] range:NSMakeRange(0, [first length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length], 17)];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:22] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange([first length] + 18, [second length])];
    [attributted addAttribute:NSFontAttributeName value:[UIFont getDKCrayonFontWithSize:18] range:NSMakeRange([first length] + 18 + [second length], [fullString length])];
}

- (void)customize
{
    self.denyButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.approveButton.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
    self.userAboutLabel.font = [UIFont getDKCrayonFontWithSize:18];
    self.usersLabel.font = [UIFont getDKCrayonFontWithSize:20];
}

- (IBAction)viewProfile:(id)sender {
}

- (IBAction)approve:(id)sender {
}

- (IBAction)deny:(id)sender {
}
@end
