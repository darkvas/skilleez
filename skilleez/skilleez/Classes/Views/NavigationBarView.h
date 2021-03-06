//
//  TestViewController.h
//  skilleez
//
//  Created by Roma on 4/1/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIControl

@property (strong, nonatomic) UILabel *titleLbl;

- (id)initWithViewController:(UIViewController *)viewCtrl withTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle;
- (id)initWithViewController:(UIViewController *)viewCtrl withTitle:(NSString *)title leftImage:(NSString *)leftTitle rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle;

@end
