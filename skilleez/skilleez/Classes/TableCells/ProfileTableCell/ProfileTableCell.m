//
//  ProfileTableCell.m
//  skilleez
//
//  Created by Roma on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileTableCell.h"
#import "UIFont+DefaultFont.h"
#import "ColorManager.h"

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

- (void)awakeFromNib
{
    self.questionText.font = [UIFont getDKCrayonFontWithSize:22.f];
    self.questionImage.layer.masksToBounds = YES;
    self.questionImage.layer.cornerRadius = 7.f;
    self.questionImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.questionImage.layer.borderWidth = 3.f;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [ColorManager colorForDarkBackground];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCell:(ProfileTableCell *)cell question:(NSString *)question image:(UIImage *)image
{
    cell.questionImage.image = image;
    cell.questionText.text = question;
}

@end
