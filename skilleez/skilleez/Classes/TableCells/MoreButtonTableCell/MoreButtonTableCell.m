//
//  MoreButtonTableCell.m
//  skilleez
//
//  Created by Hedgehog on 18.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MoreButtonTableCell.h"

const float BUTTON_BORDER_WIDTH_SD = 1.0;

@interface MoreButtonTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MoreButtonTableCell

- (void)awakeFromNib
{
    self.nameLabel.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
}

- (void)fillCell:(MoreButtonTableCell *)cell withItem:(TableItem *)item
{
    cell.nameLabel.text = item.name;
    cell.iconView.image = item.image;
}

@end
