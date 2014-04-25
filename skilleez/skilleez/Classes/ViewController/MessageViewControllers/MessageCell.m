//
//  MessageCell.m
//  skilleez
//
//  Created by Vasya on 4/10/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MessageCell.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "FamilyMemberModel.h"

@interface MessageCell()
{
    ProfileInfo *_profileInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UIImageView *senderAvatar;

@end

@implementation MessageCell

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
    self.senderAvatar.layer.cornerRadius = 46.0f;
    self.senderAvatar.layer.masksToBounds = YES;
    self.senderAvatar.layer.borderWidth = BORDER_WIDTH_MEDIUM;
    [self.messageText setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) setMessageData: (ProfileInfo*) profile andTag:(int) rowTag
{
    _profileInfo = profile;
    self.senderAvatar.layer.borderColor = profile.Color.CGColor;
    [self.senderAvatar setImageWithURL: profile.AvatarUrl];
    self.messageText.text = profile.AboutMe ? profile.AboutMe : (profile.ScreenName ? profile.ScreenName : profile.Login);
}

@end
