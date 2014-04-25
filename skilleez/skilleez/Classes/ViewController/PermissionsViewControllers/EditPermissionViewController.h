//
//  EditPermissionViewController.h
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPermissionTableCell.h"
#import "FamilyMemberModel.h"

@interface EditPermissionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EditPermissionDelegate>

- (id) initWithMemberInfo: (FamilyMemberModel*) member;

@end
