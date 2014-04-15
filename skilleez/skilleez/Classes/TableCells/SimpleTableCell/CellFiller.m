//
//  CellFiller.m
//  skilleez
//
//  Created by Roma on 4/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CellFiller.h"
#import "UIFont+DefaultFont.h"

@implementation CellFiller

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setSkilleezData:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    cell.usernameLbl.text = element.UserName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    cell.dateLbl.text =[format stringFromDate:element.PostedDate];
    [cell.avatarImg setImageWithURL:element.UserAvatarUrl];

    if ([[element.MediaThumbnailUrl absoluteString] isEqualToString:@""]) {
        [cell.attachmentImg setImageWithURL:element.MediaUrl];
    } else {
        [cell.attachmentImg setImageWithURL:element.MediaThumbnailUrl];
    }
    cell.skilleezTitleLbl.text = element.Title;
    cell.skilleezCommentLbl.text = element.Comment;
    cell.avatarImg.tag = tag;
    cell.contentView.backgroundColor = element.Color;
}

- (void)setSkilleezCell:(SimpleTableCell *)cell
{
    cell.avatarImg.layer.cornerRadius = 23.0;
    cell.avatarImg.layer.masksToBounds = YES;
    cell.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.avatarImg.layer.borderWidth = 3.0;
    [cell.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [cell.dateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [cell.skilleezTitleLbl setFont:[UIFont getDKCrayonFontWithSize:35]];
    [cell.skilleezCommentLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
}

@end
