//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleezTableCell.h"
#import "UIFont+DefaultFont.h"

@interface SkilleezTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;

@end

@implementation SkilleezTableCell

- (void)setSkilleezCell:(SkilleezTableCell *)cell andSkilleez:(Skilleez *)element
{
    [cell setCellFonts:cell];
    cell.usernameLbl.text = element.userName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    cell.dateLbl.text = [format stringFromDate:element.date];
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:element.userAvatar]];
    cell.avatarImg.layer.cornerRadius = 20.0;
    cell.avatarImg.layer.masksToBounds = YES;
    cell.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.avatarImg.layer.borderWidth = 3.0;
    [cell.attachmentImg setImageWithURL:[NSURL URLWithString:element.attachment]];
    cell.skilleezTitleLbl.text = element.skilleezTitle;
    cell.skilleezCommentLbl.text = element.skilleezComment;
    
}

- (void)setCellFonts:(SkilleezTableCell *)cell
{
    [cell.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:24]];
    [cell.dateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [cell.skilleezTitleLbl setFont:[UIFont getDKCrayonFontWithSize:36]];
    [cell.skilleezCommentLbl setFont:[UIFont getDKCrayonFontWithSize:18]];
}

@end
