//
//  AppDelegate.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationCtrl;

- (void)cutomizeNavigationBar:(UIViewController *)this withTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle;
@end
