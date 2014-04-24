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

extern const float CORNER_RADIUS_CP;
extern const int FONT_SIZE_CP;

@interface ChildProfileViewController : UIViewController

- (id)initWithFamilyMemberId:(NSString *)familyMemberId andShowFriends:(BOOL) showFriendsFamily;

@end
