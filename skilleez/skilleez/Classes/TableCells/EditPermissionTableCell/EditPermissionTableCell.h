//
//  EditPermissionTableCell.h
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"

@protocol EditPermissionDelegate <NSObject>
@required
- (void)editPermissions:(NSInteger)tag;
@end

@interface EditPermissionTableCell : UITableViewCell

@property (nonatomic,strong) id delegate;

- (void)fillCell:(EditPermissionTableCell *)cell withChild:(FamilyMemberModel *)child andTag:(NSInteger)tag;

@end
