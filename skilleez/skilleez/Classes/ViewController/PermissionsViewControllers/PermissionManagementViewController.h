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

@interface PermissionManagementViewController : UIViewController

- (id) initWithAdult: (FamilyMemberModel*) adult withPermission: (AdultPermission*) permission;

@end
