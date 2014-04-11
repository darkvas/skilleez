//
//  SelectFavoriteCollectionViewCell.m
//  skilleez
//
//  Created by Roma on 4/9/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SelectFavoriteCollectionViewCell.h"

@implementation SelectFavoriteCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
