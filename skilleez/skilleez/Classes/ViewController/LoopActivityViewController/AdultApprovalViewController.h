//
//  AdultApprovalViewController.h
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"
#import "ActivityIndicatorController.h"
#import "NetworkManager.h"
#import "HomeViewController.h"
#import "SkilleeDetailViewController.h"
#import "UtilityController.h"
#import "AdultApprovalTableCell.h"
#import "InviteToLoopApprovalTableCell.h"

@interface AdultApprovalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SimpleCellDelegate, InviteToLoopDelegate>

- (id)initWithParent:(UIViewController *)parentController;

@end
