//
//  ProfileViewController.h
//  skilleez
//
//  Created by Roma on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableCell.h"
#import "ColorViewController.h"
#import "SelectFavoriteViewController.h"

@interface EditProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ColorViewControllerObserver, FavoriteViewControllerDelegate>

@end