//
//  LoopActivityViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "SkilleeDetailViewController.h"
#import "CreateSkilleeViewController.h"
#import "UserSettingsManager.h"
#import "MenuViewController.h"
#import "ChildApprovalViewController.h"
#import "AdultApprovalViewController.h"
#import "UINavigationController+Push.h"
#import "LoopViewController.h"
#import "FavoriteViewController.h"

extern const int NUMBER_OF_ITEMS;

@interface HomeViewController : UIViewController

@property (strong, nonatomic) UILabel *badge;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) CreateSkilleeViewController *createViewCtrl;

- (void)hideMenu;
- (void)showMenu;

@end
