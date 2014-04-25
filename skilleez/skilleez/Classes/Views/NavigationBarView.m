//
//  TestViewController.m
//  skilleez
//
//  Created by Roma on 4/1/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ColorManager.h"

@interface NavigationBarView ()

@property (strong, nonatomic) UIViewController *currentCtrl;

@end

@implementation NavigationBarView

- (id)initWithViewController:(UIViewController *)viewCtrl withTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle
{
    if (self = [super init]) {
        [self setDefault:viewCtrl titile:title];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 60, 44)];
        [cancelBtn setImage:[UIImage imageNamed:@"back_BTN.png"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"back_BTN_press.png"] forState:UIControlStateHighlighted];
        [cancelBtn setTitle:leftTitle forState:UIControlStateNormal];
        [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelBtn addTarget:viewCtrl action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [cancelBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:21]];
        [self addSubview:cancelBtn];
        
        if (rightButton) {
            [self addRightButton:rightTitle viewController:viewCtrl];
        }
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)viewCtrl withTitle:(NSString *)title leftImage:(NSString *)leftImage rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle
{
    if (self = [super init]) {
        [self setDefault:viewCtrl titile:title];
        //TODO: change image
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 60, 44)];
        [cancelBtn setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        //[cancelBtn setImage:[UIImage imageNamed:@"back_BTN_press.png"] forState:UIControlStateHighlighted];
        [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelBtn addTarget:viewCtrl action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        if (rightButton) {
            [self addRightButton:rightTitle viewController:viewCtrl];
        }
    }
    return self;
}

- (void)setDefault:(UIViewController *)viewCtrl titile:(NSString *)title
{
    self.frame = CGRectMake(0, 0, 320, 64);
    self.backgroundColor = [ColorManager colorForDarkBackground];
    self.currentCtrl = viewCtrl;
    
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 24, 170, 40)];
    self.titleLbl.text = title;
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont getDKCrayonFontWithSize:24];
    self.titleLbl.textColor = [UIColor orangeColor];
    [self addSubview:self.titleLbl];
}

- (void)addRightButton:(NSString *)rightTitle viewController:(UIViewController *)viewCtrl
{
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, 20, 60, 44)];
    [doneBtn setTitle:rightTitle forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [doneBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:21]];
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn addTarget:viewCtrl action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];
}

- (void)cancel
{
    [self.currentCtrl.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.currentCtrl.navigationController popViewControllerAnimated:YES];
}

@end
