//
//  ChildProfileViewController.h
//  skilleez
//
//  Created by Roma on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"

@interface ChildProfileViewController : UIViewController

@property (strong, nonatomic) FamilyMemberModel* familyMember;
@property (nonatomic) BOOL showFriendsFamily;

@end
