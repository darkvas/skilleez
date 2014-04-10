//
//  ProfileViewController.h
//  skilleez
//
//  Created by Roma on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"
#import "KeyboardViewController.h"

@interface ProfileViewController : UIViewController <UITextViewDelegate>

- (id)initWithProfile:(ProfileInfo *)profileInfo editMode:(BOOL)edit;

@end
