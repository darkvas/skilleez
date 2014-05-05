//
//  UtilityController.h
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettingsManager.h"
#import "AdultProfileViewController.h"
#import "ChildProfileViewController.h"
#import "EditProfileViewController.h"
#import "FamilyMemberModel.h"
#import "UINavigationController+Push.h"
#import "HomeViewController.h"

@interface UtilityController : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isArrayEquals:(NSArray *)ar1 toOther:(NSArray *)ar2;
- (void)profileSelect:(NSString *)profileId onController:(UIViewController *)controller;
- (void)showFailureAlert:(NSError *)error withCaption:(NSString *)caption withIndicator:(UIActivityIndicatorView *) activityIndicator;
- (void)showFailureAlert:(NSError *)error withCaption:(NSString *)caption;
- (void)setBadgeValue:(int)value forController:(UIViewController *)homeController;
- (void)showAnotherViewController:(UIViewController *)child;
- (NSString *)getErrorMessage:(NSError *)error;
- (UILabel *)showEmptyView:(UIViewController *)viewController text:(NSString *)text;
- (NSString *)getStringFromColor:(UIColor *)color;
- (BOOL)validateEmailWithString:(NSString *)email;
@end
