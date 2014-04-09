//
//  ColorViewController.h
//  skilleez
//
//  Created by Roma on 4/9/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"

@protocol ColorViewControllerObserver <NSObject>

- (void)colorSelected:(UIColor *)color;

@end

@interface ColorViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

- (id)initWithProfile:(ProfileInfo *)profile;

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) ProfileInfo *profile;
@property (weak, nonatomic) id<ColorViewControllerObserver> delegate;
@end
