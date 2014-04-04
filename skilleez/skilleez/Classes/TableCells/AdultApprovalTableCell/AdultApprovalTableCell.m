//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultApprovalTableCell.h"
#import "UIFont+DefaultFont.h"

@interface AdultApprovalTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

- (IBAction)showSkillee:(id)sender;

@end

@implementation AdultApprovalTableCell

- (void)setSkilleezCell:(AdultApprovalTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    [cell setCellFonts];
    cell.usernameLbl.text = element.UserName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    cell.dateLbl.text =[format stringFromDate:element.PostedDate];
    [cell.avatarImg setImageWithURL:element.UserAvatarUrl];
    cell.avatarImg.layer.cornerRadius = 23.0;
    cell.avatarImg.layer.masksToBounds = YES;
    cell.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.avatarImg.layer.borderWidth = 3.0;
    if ([[element.MediaThumbnailUrl absoluteString] isEqualToString:@""]) {
        [cell.attachmentImg setImageWithURL:element.MediaUrl];
    } else {
        [cell.attachmentImg setImageWithURL:element.MediaThumbnailUrl];
    }
    cell.skilleezTitleLbl.text = element.Title;
    cell.skilleezCommentLbl.text = element.Comment;
    cell.detailBtn.tag = tag;
    cell.contentView.backgroundColor = element.Color;
}

- (void)setCellFonts
{
    [self.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.dateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [self.skilleezTitleLbl setFont:[UIFont getDKCrayonFontWithSize:35]];
    [self.skilleezCommentLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
}

- (IBAction)showSkillee:(id)sender {
    [self.delegate didSkiilleSelect:((UIButton *)sender).tag];
}
@end
