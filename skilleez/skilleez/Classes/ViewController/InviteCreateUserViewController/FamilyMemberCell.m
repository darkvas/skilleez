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
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

- (IBAction)showMember:(id)sender;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMemberData: (FamilyMemberModel*) familyMember andTag:(int) rowTag
{
    _familyMember = familyMember;
    
    _memberAvatar.layer.cornerRadius = 23.0;
    _memberAvatar.layer.masksToBounds = YES;
    _memberAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _memberAvatar.layer.borderWidth = 3.0;
    [_memberAvatar setImageWithURL: [NSURL URLWithString:_familyMember.AvatarUrl]];
    
    [_memberName setFont:[UIFont getDKCrayonFontWithSize:21]];
    _memberName.text = _familyMember.FullName;
}

- (IBAction)showMember:(id)sender
{
    
}

@end
