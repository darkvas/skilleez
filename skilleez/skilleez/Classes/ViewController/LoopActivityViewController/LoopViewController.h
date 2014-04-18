//
//  LoopViewController.h
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
#import "UtilityController.h"
#import "SkilleeDetailViewController.h"

@interface LoopViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SimpleCellDelegate>

- (id)initWithParent:(UIViewController *)parentController;

@end
