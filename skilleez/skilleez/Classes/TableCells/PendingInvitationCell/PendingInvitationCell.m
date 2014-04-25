//
//  PendingInvitationCell.m
//  skilleez
//
//  Created by Vasya on 4/23/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "PendingInvitationCell.h"
#import "UIFont+DefaultFont.h"

@interface PendingInvitationCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation PendingInvitationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.labelName.font = [UIFont getDKCrayonFontWithSize:22.f];
    self.imageAvatar.layer.masksToBounds = YES;
    self.imageAvatar.layer.cornerRadius = 34.f;
    self.imageAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageAvatar.layer.borderWidth = 3.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCell:(PendingInvitationCell*) aCell withInvitation:(LoopInvitationModel*) anInvitation
{
    _invitation = anInvitation;
    [aCell.imageAvatar setImageWithURL:anInvitation.Invitor.AvatarUrl];
    [aCell.labelName setText:anInvitation.Invitor.Login];
}

@end
