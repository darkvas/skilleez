//
//  UINavigationController+Push.h
//  skilleez
//
//  Created by Roma on 4/1/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Push)

- (void)pushViewControllerFromLeft:(UIViewController *)viewController;
- (void)popViewControllerFromLeft:(UIViewController *)viewController;
- (void)pushViewControllerCustom:(UIViewController *)viewController;
- (void)popViewControllerCustom;
@end
