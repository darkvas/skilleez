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

extern const int BUTTON_FONT_SIZE_SD;
extern const float BUTTON_BORDER_WIDTH_SD;

@interface SkilleeDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL controllsHidden;

- (id)initWithSkillee:(SkilleeModel *)skillee andApproveOpportunity:(BOOL)enabled;

@end
