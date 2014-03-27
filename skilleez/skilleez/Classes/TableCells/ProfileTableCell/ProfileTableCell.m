//
//  ProfileTableCell.m
//  skilleez
//
//  Created by Roma on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileTableCell.h"
#import "UIFont+DefaultFont.h"

@interface ProfileTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *questionImage;
@property (weak, nonatomic) IBOutlet UILabel *questionText;

@end

@implementation ProfileTableCell

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

- (void)fillCell:(ProfileTableCell *)cell question:(NSString *)question image:(UIImage *)image
{
    //cell.questionImage.image = image;
    cell.questionText.font = [UIFont getDKCrayonFontWithSize:22.f];
    cell.questionText.text = question;
    cell.questionImage.layer.masksToBounds = YES;
    cell.questionImage.layer.cornerRadius = 7.f;
    cell.questionImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.questionImage.layer.borderWidth = 3.f;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
    [cell setSelectedBackgroundView:bgColorView];
}

@end