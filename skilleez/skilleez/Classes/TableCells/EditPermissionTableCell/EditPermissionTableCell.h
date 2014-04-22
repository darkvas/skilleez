//
//  EditPermissionTableCell.h
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"
#import "AdultPermission.h"

@protocol EditPermissionDelegate <NSObject>

@required

- (void)editPermissions:(AdultPermission*) permission forMember: (FamilyMemberModel*) familyMember;

@end


@interface EditPermissionTableCell : UITableViewCell

@property (nonatomic,strong) id delegate;

- (void)fillCell:(EditPermissionTableCell*) cell withMember:(FamilyMemberModel*) childMember andPermission:(AdultPermission*) permission;

@end
