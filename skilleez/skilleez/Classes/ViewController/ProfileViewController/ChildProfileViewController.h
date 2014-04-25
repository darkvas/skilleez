//
//  ChildProfileViewController.h
//  skilleez
//
//  Created by Roma on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"
#import "ActivityIndicatorController.h"

@interface ChildProfileViewController : UIViewController

- (id)initWithFamilyMemberId:(NSString *)familyMemberId andShowFriends:(BOOL) showFriendsFamily;

@end
