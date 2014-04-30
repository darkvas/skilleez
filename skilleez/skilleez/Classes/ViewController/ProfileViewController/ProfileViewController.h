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

@protocol ProfileViewDelegate <NSObject>

- (void)profileChanged:(ProfileInfo *)profile;

@end

@interface ProfileViewController : UIViewController <UITextViewDelegate, FavoriteViewControllerDelegate, ColorViewControllerObserver>

@property (weak, nonatomic) id<ProfileViewDelegate> delegate;

- (id)initWithProfile:(ProfileInfo *)profileInfo editMode:(BOOL)edit;

@end
