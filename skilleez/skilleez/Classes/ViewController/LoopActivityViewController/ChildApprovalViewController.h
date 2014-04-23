//
//  ChildApprovalViewController.h
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorController.h"
#import "NetworkManager.h"
#import "HomeViewController.h"
#import "SkilleeDetailViewController.h"
#import "UtilityController.h"
#import "SimpleTableCell.h"
#import "InviteToLoopApprovalTableCell.h"

@interface ChildApprovalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SimpleCellDelegate>

- (id)initWithParent:(UIViewController *)parentController;


@end
