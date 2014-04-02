//
//  ColorViewController.h
//  skilleez
//
//  Created by Roma on 3/28/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewControllerObserver <NSObject>

-(void)colorSelected:(UIColor*) color;

@end

@interface ColorViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIColor* selectedColor;
@property (weak, nonatomic) id<ColorViewControllerObserver> delegate;

@end
