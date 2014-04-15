//
//  ChildProfileViewController.h
//  skilleez
//
//  Created by Roma on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"

extern const float CORNER_RADIUS_CP;
extern const int FONT_SIZE_CP;

@interface ChildProfileViewController : UIViewController

@property (strong, nonatomic) FamilyMemberModel* familyMember;
@property (nonatomic) BOOL showFriendsFamily;

@end
