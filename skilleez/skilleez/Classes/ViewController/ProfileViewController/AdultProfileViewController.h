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

extern const float CORNER_RADIUS_AP;
extern const int FONT_SIZE_AP;

@interface AdultProfileViewController : UIViewController<CustomIOS7AlertViewDelegate>

- (id)initWithFamilyMember:(FamilyMemberModel *)familyMember;

@end
