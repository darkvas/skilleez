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
#import "ColorViewController.h"
#import "SelectFavoriteViewController.h"

extern const float CORNER_RADIUS_PV;
extern const float BORDER_WIDTH_PV;

@interface ProfileViewController : UIViewController <UITextViewDelegate, FavoriteViewControllerDelegate, ColorViewControllerObserver>

- (id)initWithProfile:(ProfileInfo *)profileInfo editMode:(BOOL)edit;

@end
