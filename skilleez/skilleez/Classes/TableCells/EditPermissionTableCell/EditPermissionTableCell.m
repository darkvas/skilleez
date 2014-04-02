//
//  EditPermissionTableCell.m
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "EditPermissionTableCell.h"
#import "UIFont+DefaultFont.h"
#import "PermissionManagementViewController.h"

@interface EditPermissionTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *editPermissionsBtn;
@property (weak, nonatomic) IBOutlet UIView *permissionView;

- (IBAction)editPermission:(id)sender;

@end

@implementation EditPermissionTableCell

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

- (void)fillCell:(EditPermissionTableCell *)cell withPermission:(AdultPermission *)permission andTag:(NSInteger)tag
{
    [cell.userAvatarImg setImageWithURL:[NSURL URLWithString:permission.ChildAvatarUrl]];
    cell.userAvatarImg.layer.masksToBounds = YES;
    cell.userAvatarImg.layer.cornerRadius = 30.f;
    cell.usernameLbl.text = permission.ChildName;
    cell.usernameLbl.font = [UIFont getDKCrayonFontWithSize:20];
    cell.editPermissionsBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:18];
    cell.permissionView.layer.cornerRadius = 4.f;
    cell.editPermissionsBtn.tag = tag;
}

- (IBAction)editPermission:(id)sender {
    [self.delegate editPermissions:((UIButton *)sender).tag];
}
@end
