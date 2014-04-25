//
//  SkilleeDetailViewController.h
//  skilleez
//
//  Created by Roma on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkilleeModel.h"
#import "CustomAlertView.h"

@interface SkilleeDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL controllsHidden;

- (id)initWithSkillee:(SkilleeModel *)skillee andApproveOpportunity:(BOOL)enabled;

@end
