//
//  FamilyMemberCell.m
//  skilleez
//
//  Created by Vasya on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FamilyMemberCell.h"
#import "UIFont+DefaultFont.h"

@interface FamilyMemberCell()
{
    FamilyMemberModel* _familyMember;
}

@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UIImageView *memberAvatar;

@end

@implementation FamilyMemberCell

@synthesize memberName = _memberName;
@synthesize memberAvatar = _memberAvatar;

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
    _memberAvatar.layer.cornerRadius = 23.0;
    _memberAvatar.layer.masksToBounds = YES;
    _memberAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _memberAvatar.layer.borderWidth = BORDER_WIDTH_MEDIUM;
    [_memberName setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMemberData:(FamilyMemberModel *)familyMember andTag:(int)rowTag
{
    _familyMember = familyMember;
    [_memberAvatar setImageWithURL: _familyMember.AvatarUrl];
    _memberName.text = _familyMember.FullName;
}

@end
