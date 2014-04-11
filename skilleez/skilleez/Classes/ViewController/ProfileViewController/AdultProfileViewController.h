//
//  ProfilePermissionViewController.h
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"
#import "CustomAlertView.h"

@interface AdultProfileViewController : UIViewController<CustomIOS7AlertViewDelegate>

@property (strong, nonatomic) FamilyMemberModel* familyMember;

@end
