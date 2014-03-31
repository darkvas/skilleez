//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildApprovalTableCell.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"

@interface ChildApprovalTableCell()
{
    SkilleeModel * skilleeModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UILabel *waitingForApprovalLbl;

-(IBAction) deleteSkillee:(id)sender;

@end

@implementation ChildApprovalTableCell

- (void)setSkilleezCell:(ChildApprovalTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    [cell setCellFonts];
    cell.usernameLbl.text = element.UserName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    cell.dateLbl.text =[format stringFromDate:element.PostedDate];
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:element.UserAvatarUrl]];
    cell.avatarImg.layer.cornerRadius = 23.0;
    cell.avatarImg.layer.masksToBounds = YES;
    cell.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.avatarImg.layer.borderWidth = 3.0;
    if ([element.MediaThumbnailUrl isEqualToString:@""]) {
        [cell.attachmentImg setImageWithURL:[NSURL URLWithString:element.MediaUrl]];
    } else {
        [cell.attachmentImg setImageWithURL:[NSURL URLWithString:element.MediaThumbnailUrl]];
    }
    cell.skilleezTitleLbl.text = element.Title;
    cell.skilleezCommentLbl.text = element.Comment;
    cell.contentView.backgroundColor = element.Color;
    skilleeModel = element;
}

- (void)setCellFonts
{
    [self.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.dateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [self.skilleezTitleLbl setFont:[UIFont getDKCrayonFontWithSize:35]];
    [self.skilleezCommentLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.waitingForApprovalLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
}

-(IBAction) deleteSkillee:(id)sender
{
    [[NetworkManager sharedInstance] postRemoveSkillee:skilleeModel.Id success:^{
        [self.delegate didSkiilleSelect:((UIButton *)sender).tag];
    } failure:^(NSError *error) {
        
    }];
}

@end
