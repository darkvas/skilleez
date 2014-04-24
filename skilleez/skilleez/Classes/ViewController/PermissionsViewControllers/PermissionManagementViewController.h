//
//  PermissionManagementViewController.h
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"
#import "AdultPermission.h"
#import "CustomAlertView.h"

extern const float CORNER_RADIUS_PM;
extern const int BOTTOM_LABEL_FONT_SIZE;
extern const int TOP_LABEL_FONT_SIZE;

@interface PermissionManagementViewController : UIViewController

- (id) initWithAdult: (FamilyMemberModel*) adult withChild: (FamilyMemberModel*) child andPermission: (AdultPermission*) permission;

@end
